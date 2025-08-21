//
//  SearchMapViewController.swift
//  SeoulSpot
//
//  Created by Kyuhee hong on 3/31/25.
//

import UIKit
import NMapsMap
import CoreLocation

protocol SearchMapViewControllerDelegate: AnyObject {
    func didSelectEvent(_ event: CulturalEventModel)
}

final class SearchMapViewController: BaseViewController<SearchMapView, SearchMapViewModel> {

    // MARK: - Delegate
    var delegate: SearchMapViewControllerDelegate?
    
    // MARK: - Enum
    private enum CameraMoveContext {
        case userLocation
        case searchResult
        case markerTap
        case collectionViewScroll
    }

    // MARK: - Location Properties
    private let locationManager = CLLocationManager()
    private var initialLocationSet = false
    private var currentUserCoordinate: CLLocationCoordinate2D?

    // MARK: - Smart Navigation Properties
    private var visitedEventIds: Set<String> = []
    private var currentEventIndex: Int = 0
    private var hasInitialSort: Bool = false

    // MARK: - Map Properties
    private let infoWindow = NMFInfoWindow()
    private var markerDict: [String: NMFMarker] = [:]
    private let customSource = CustomTextViewSource()
    private var currentCameraMoveContext: CameraMoveContext = .userLocation
    private var lastCameraUpdateTime = Date()
    
    // MARK: - Data Properties
    private var currentFilters = FilterSelection(categories: [], districts: [], prices: [], audiences: [])
    private var searchResults: [CulturalEventModel] = []
    
    // MARK: - Constants
    private struct Constants {
        static let seoulBounds = NMGLatLngBounds(
            southWestLat: 37.413294, southWestLng: 126.734086,
            northEastLat: 37.715133, northEastLng: 127.269311
        )
        static let defaultZoomLevel: Double = 13.0
        static let detailZoomLevel: Double = 14.0
        static let minZoomLevel: Double = 10.0
        static let maxZoomLevel: Double = 20.0
        static let cameraIdleThreshold: TimeInterval = 2.0
        static let markerColor = UIColor(red: 41/255, green: 120/255, blue: 160/255, alpha: 1.0)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Setup
    private func setupViewController() {
        requestLocationAccess()
        setupMapView()
        setupInfoView()
        setupResultList()
        setupButtons()
    }
    
    private func setupButtons() {
        baseView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        baseView.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
    
    override func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.showLoading($0) }
            .store(in: &cancellables)
        
        viewModel.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.showError($0) }
            .store(in: &cancellables)
    }
}

// MARK: - Location Management
extension SearchMapViewController: CLLocationManagerDelegate {
    
    private func requestLocationAccess() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func currentLocationButtonTapped() {
        guard let currentLocation = locationManager.location else { return }
        focusOnCurrentLocation(currentLocation.coordinate)
        resetNavigationState()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !initialLocationSet, let location = locations.last else { return }
        initialLocationSet = true
        focusOnCurrentLocation(location.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    private func focusOnCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        let currentLatLng = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        
        let overlay = baseView.mapView.locationOverlay
        overlay.location = currentLatLng
        overlay.hidden = false
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: currentLatLng, zoomTo: Constants.detailZoomLevel)
        cameraUpdate.animation = .easeIn
        baseView.mapView.moveCamera(cameraUpdate)

        currentUserCoordinate = coordinate
        fetchEventsAndUpdateMarkers(near: coordinate)
    }
    
    private func resetNavigationState() {
        hasInitialSort = false
        currentEventIndex = 0
        visitedEventIds.removeAll()
    }
}

// MARK: - Map Setup & Interaction
extension SearchMapViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    
    private func setupMapView() {
        baseView.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        baseView.mapView.touchDelegate = self
        baseView.mapView.addCameraDelegate(delegate: self)
        baseView.mapView.animationDuration = 0.5
        baseView.mapView.extent = Constants.seoulBounds
        baseView.mapView.minZoomLevel = Constants.minZoomLevel
        baseView.mapView.maxZoomLevel = Constants.maxZoomLevel
    }
    
    private func setupInfoView() {
        infoWindow.touchHandler = makeInfoWindowTouchHandler()
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let now = Date()
        guard now.timeIntervalSince(lastCameraUpdateTime) > 2.0 else { return }
        lastCameraUpdateTime = now
        
        if !searchResults.isEmpty {
            sortSearchResultsByDistance()
            DispatchQueue.main.async { [weak self] in
                self?.baseView.resultCollectionView.reloadData()
            }
        }
    }
    
    private func connectHandler(_ marker: NMFMarker) {
        marker.touchHandler = makeMarkerTouchHandler(for: marker)
    }
    
    private func makeInfoWindowTouchHandler() -> ((NMFOverlay) -> Bool) {
        return { [weak self] overlay in
            guard let self = self else { return false }
            
            guard let marker = self.infoWindow.marker,
                  let event = marker.userInfo["event"] as? CulturalEventModel else {
                return false
            }
            
            self.delegate?.didSelectEvent(event)
            return true
        }
    }
    
    private func makeMarkerTouchHandler(for marker: NMFMarker) -> ((NMFOverlay) -> Bool) {
        return { [weak self] overlay in
            guard let self = self, let marker = overlay as? NMFMarker,
                  let event = marker.userInfo["event"] as? CulturalEventModel else {
                return false
            }
            customSource.title = event.title ?? ""
            infoWindow.dataSource = self.customSource
            currentCameraMoveContext = .markerTap
            focus(on: marker)
            return true
        }
    }
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        baseView.resultCollectionView.isHidden = true
        infoWindow.close()
    }
}

//MARK: - Event Data Management
extension SearchMapViewController {
    
    private func fetchEventsAndUpdateMarkers(near coordinate: CLLocationCoordinate2D) {
        viewModel.fetchNearByEvents(near: coordinate) { [weak self] events in
            guard let self = self else { return }
            
            let activeEvents = self.filterActiveEvents(events)
            self.searchResults = activeEvents
            
            if !self.hasInitialSort {
                self.performInitialSort()
            }
            
            self.updateEventMarkers(with: self.searchResults)
            self.reloadCollectionView()
        }
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.baseView.resultCollectionView.reloadData()
        }
    }
    
    private func performInitialSort() {
        sortSearchResultsByDistance()
        hasInitialSort = true
        currentEventIndex = 0
        visitedEventIds.removeAll()
    }
    
    private func filterActiveEvents(_ events: [CulturalEventModel]) -> [CulturalEventModel] {
        let activeEvents = events.filter { !$0.isEnded }
        let filteredCount = events.count - activeEvents.count
        
        if filteredCount > 0 {
            print("종료된 이벤트 \(filteredCount)개가 필터링 되었습니다.")
        }
        
        return activeEvents
    }
    
    private func sortSearchResultsByDistance() {
        guard let currentLocation = currentUserCoordinate else {
            print("cannot find current location coordinate")
            return
        }
        
        let currentCLLocation = CLLocation(latitude: currentLocation.latitude,
                                           longitude: currentLocation.longitude)
        
        searchResults.sort {
            guard let lat1 = $0.lat, let lon1 = $0.lot,
                  let lat2 = $1.lat, let lon2 = $1.lot else { return false }
            
            let distance1 = currentCLLocation.distance(from: CLLocation(latitude: lat1, longitude: lon1))
            let distance2 = currentCLLocation.distance(from: CLLocation(latitude: lat2, longitude: lon2))
            
            return distance1 < distance2
        }
        print("sorted search results by distance from current location")
    }
}

//MARKER: - Marker Management
extension SearchMapViewController {
        
    private func updateEventMarkers(with events: [CulturalEventModel]) {
        var newMarkers: [String: NMFMarker] = [:]
        
        for event in events {
            let id = "\(event.title ?? "")_\(event.lat ?? 0)_\(event.lot ?? 0)"
            if let existingMarker = markerDict[id] {
                newMarkers[id] = existingMarker
                continue
            }
            newMarkers[id] = createMarker(for: event)
        }
        
        let removedKeys = markerDict.keys.filter { newMarkers[$0] == nil }
        for id in removedKeys {
            markerDict[id]?.mapView = nil
        }
        markerDict = newMarkers
    }
    
    private func createMarker(for event: CulturalEventModel) -> NMFMarker {
        let marker = NMFMarker(position: NMGLatLng(lat: event.lat ?? 0, lng: event.lot ?? 0))
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor(red: 41/255.0, green: 120/255.0, blue: 160/255.0, alpha: 1.0)
        marker.width = 20
        marker.height = 28
        marker.userInfo = ["event": event]
        marker.mapView = baseView.mapView
        connectHandler(marker)
        return marker
    }
    
    private func adjustCameraToFit(events: [CulturalEventModel]) {
        let coords = events.compactMap { event -> NMGLatLng? in
            guard let lat = event.lat, let lng = event.lot else { return nil }
            return NMGLatLng(lat: lat, lng: lng)
        }
        
        guard !coords.isEmpty else { return }

        var minLat = coords[0].lat
        var maxLat = coords[0].lat
        var minLng = coords[0].lng
        var maxLng = coords[0].lng

        for coord in coords {
            minLat = min(minLat, coord.lat)
            maxLat = max(maxLat, coord.lat)
            minLng = min(minLng, coord.lng)
            maxLng = max(maxLng, coord.lng)
        }

        let southWest = NMGLatLng(lat: minLat, lng: minLng)
        let northEast = NMGLatLng(lat: maxLat, lng: maxLng)
        let bounds = NMGLatLngBounds(southWest: southWest, northEast: northEast)

        let cameraUpdate = NMFCameraUpdate(fit: bounds, padding: 80)
        cameraUpdate.animation = .easeIn
        baseView.mapView.moveCamera(cameraUpdate)
    }
    
    private func focus(on marker: NMFMarker) {
        switch currentCameraMoveContext {
        case .userLocation:
            baseView.resultCollectionView.isHidden = true
            return

        case .searchResult:
            baseView.resultCollectionView.isHidden = true
            let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
            cameraUpdate.animation = .easeIn
            baseView.mapView.moveCamera(cameraUpdate)

        case .markerTap:
            baseView.resultCollectionView.isHidden = true
            if let event = marker.userInfo["event"] as? CulturalEventModel,
               let index = searchResults.firstIndex(where: { $0.id == event.id }) {
                let indexPath = IndexPath(item: index, section: 0)
                baseView.resultCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            fallthrough

        case .collectionViewScroll:
            baseView.resultCollectionView.isHidden = false
            let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position, zoomTo: 14)
            cameraUpdate.animation = .easeIn
            baseView.mapView.moveCamera(cameraUpdate)
 
            if let event = marker.userInfo["event"] as? CulturalEventModel {
                self.customSource.title = event.title ?? ""
                self.infoWindow.dataSource = self.customSource
                self.infoWindow.close()
                self.infoWindow.open(with: marker)
            }
        }
    }
}

final class CustomTextViewSource: NSObject, NMFOverlayImageDataSource {
    var title: String = ""
    
    func view(with overlay: NMFOverlay) -> UIView {
        let label = PaddingLabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .black
        label.layer.cornerRadius = 6
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.gray.cgColor
        label.clipsToBounds = true
        
        let maxWidth: CGFloat = 200
        let horizontalPadding = label.leftInset + label.rightInset
        let verticalPadding = label.topInset + label.bottomInset
        
        let fittingSize = CGSize(width: maxWidth - horizontalPadding,
                                 height: CGFloat.greatestFiniteMagnitude)
        let contentSize = label.sizeThatFits(fittingSize)
        
        let finalSize = CGSize(width: min(maxWidth, contentSize.width + horizontalPadding),
                               height: contentSize.height + verticalPadding)
        label.frame = CGRect(origin: .zero, size: finalSize)
        
        return label
    }
}

// MARK: - Filter
extension SearchMapViewController: FilterSheetDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func setupResultList() {
        baseView.resultCollectionView.delegate = self
        baseView.resultCollectionView.dataSource = self
        baseView.resultCollectionView.register(BasicInfoCollectionViewCell.self, forCellWithReuseIdentifier: BasicInfoCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicInfoCollectionViewCell.identifier, for: indexPath) as? BasicInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: searchResults[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent = searchResults[indexPath.item]
        delegate?.didSelectEvent(selectedEvent)
    }

    @objc private func filterButtonTapped() {
        let filterVC = FilterSheetViewController(currentFilters: currentFilters)
        filterVC.delegate = self
        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(filterVC, animated: true)
    }
    
    func didApplyFilters(_ filters: FilterSelection) {
        self.currentFilters = filters
        fetchFilteredEventsAndUpdateMarkers()
    }
    
   
    
    func fetchFilteredEventsAndUpdateMarkers() {
        viewModel.fetchFilteredEvents(filters: currentFilters) { [weak self] events in
            guard let self = self else { return }
            
            let activeEvents = self.filterActiveEvents(events)
            self.searchResults = activeEvents
            
            self.visitedEventIds.removeAll()
            self.currentEventIndex = 0
            
            self.updateEventMarkers(with: self.searchResults)
            
            DispatchQueue.main.async {
                if self.searchResults.isEmpty {
                    self.showNoResultsMessage()
                } else {
                    self.baseView.resultCollectionView.reloadData()
                    self.adjustCameraToFit(events: self.searchResults)
                }
            }
        }
    }
    
    private func showNoResultsMessage() {
        baseView.makeToast("검색 결과가 없습니다.", duration: 2.0, position: .bottom)
        baseView.resultCollectionView.isHidden = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleCenter = CGPoint(
            x: baseView.resultCollectionView.contentOffset.x + baseView.resultCollectionView.bounds.width / 2,
            y: baseView.resultCollectionView.bounds.height / 2
        )

        if let indexPath = baseView.resultCollectionView.indexPathForItem(at: visibleCenter) {
            currentEventIndex = indexPath.item
            
            let currentEvent = searchResults[indexPath.item]
            visitedEventIds.insert(currentEvent.id)
            
            if let nextIndex = findNextUnvisitedEvent(from: currentEventIndex) {
                let nextEvent = searchResults[nextIndex]
                print("next event \(nextEvent.title ?? "")")
            }
                        
            if let marker = markerDict.values.first(where: {
                guard let mEvent = $0.userInfo["event"] as? CulturalEventModel else { return false }
                return mEvent.id == currentEvent.id
            }) {
                currentCameraMoveContext = .collectionViewScroll
                focus(on: marker)
            }
        }
    }
}

// MARK: - CollectionView
extension SearchMapViewController {
   
    
    private func findNextUnvisitedEvent(from currentIndex: Int) -> Int? {
        let currentEvent = searchResults[currentIndex]
        guard let currentLat = currentEvent.lat, let currentLot = currentEvent.lot else {
            // 현재 이벤트 위치 정보가 없으면 순차적으로 다음 이벤트
            return findNextUnvisitedEvent(from: currentIndex)
        }
        
        let currentLocation = CLLocation(latitude: currentLat, longitude: currentLot)
        
        var nearestIndex: Int?
        var nearestDistance: Double = Double.infinity
        
        for (index, event) in searchResults.enumerated() {
            // 현재 이벤트와 이미 확인한 이벤트는 스킵
            if index == currentIndex || visitedEventIds.contains(event.id) {
                continue
            }
            
            guard let lat = event.lat, let lot = event.lot else { continue }
            let eventLocation = CLLocation(latitude: lat, longitude: lot)
            let distance = currentLocation.distance(from: eventLocation)
            
            if distance < nearestDistance {
                nearestDistance = distance
                nearestIndex = index
            }
        }
        return nearestIndex ?? findNextSequentialEvent(from: currentIndex)
    }
    
    private func findNextSequentialEvent(from currentIndex: Int) -> Int? {
        let totalCount = searchResults.count
        
        for i in 1..<totalCount {
            let nextIndex = (currentIndex + i) % totalCount
            let nextEvent = searchResults[nextIndex]
            
            if !visitedEventIds.contains(nextEvent.id) {
                return nextIndex
            }
        }
        
        // 모든 이벤트를 다 봤으면 방문 기록을 초기화 하고 다음 이벤트로
        visitedEventIds.removeAll()
        return (currentIndex + 1) % totalCount
    }
}

extension NMGLatLng {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }
}
