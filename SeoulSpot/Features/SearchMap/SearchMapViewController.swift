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

    var delegate: SearchMapViewControllerDelegate?
    
    private var initialLocationSet = false
    private let locationManager = CLLocationManager()
    
    private let infoWindow = NMFInfoWindow()
    private var markerDict: [String: NMFMarker] = [:] {
        didSet {
            self.searchResults = markerDict.values.compactMap {
                $0.userInfo["event"] as? CulturalEventModel
            }
            baseView.resultCollectionView.reloadData()
        }
    }
    private let customSource = CustomTextViewSource()
    
    private var lastCameraUpdateTime = Date()
    
    private enum CameraMoveContext {
        case user
        case searchResult
        case markerTap
        case collectionViewScroll
    }

    private var currentCameraMoveContext: CameraMoveContext = .user
    private var currentUserCoordinate: CLLocationCoordinate2D?
    private var currentFilters = FilterSelection(categories: [], districts: [], prices: [], audiences: [])
    private var searchResults: [CulturalEventModel] = []
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        requestLocationAccess()
        
        setupMapView()
        setupInfoView()
        setupResultList()
        addTargetToButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    private func addTargetToButton() {
        baseView.currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        baseView.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
    }
}

// MARK: - CoreLocation

extension SearchMapViewController: CLLocationManagerDelegate {
    
    private func requestLocationAccess() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc private func currentLocationButtonTapped() {
        guard let currentLocation = locationManager.location else { return }
        focusOnCurrentLocation(currentLocation.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        guard !initialLocationSet, let location = locations.last else { return }
        initialLocationSet = true
        focusOnCurrentLocation(location.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    private func focusOnCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        print(#function)
        let lat = coordinate.latitude
        let lng = coordinate.longitude
        let currentLatLng = NMGLatLng(lat: lat, lng: lng)
        
        let overlay = baseView.mapView.locationOverlay
        overlay.location = currentLatLng
        overlay.hidden = false
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: currentLatLng, zoomTo: 13)
        cameraUpdate.animation = .easeIn
//        baseView.mapView.zoomLevel = 13.0
        baseView.mapView.moveCamera(cameraUpdate)
        currentUserCoordinate = coordinate
        fetchEventsAndUpdateMarkers(near: coordinate)
    }
}

// MARK: - MapView
extension SearchMapViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    
    private func setupMapView() {
        print(#function)
        baseView.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        baseView.mapView.touchDelegate = self
        baseView.mapView.addCameraDelegate(delegate: self)
        baseView.mapView.animationDuration = 0.5 //
        
        let seoulLatLngBounds = NMGLatLngBounds(
            southWestLat: 37.413294, southWestLng: 126.734086, // 서울 남서쪽 끝
            northEastLat: 37.715133, northEastLng: 127.269311  // 서울 북동쪽 끝
        )
        baseView.mapView.extent = seoulLatLngBounds
        baseView.mapView.minZoomLevel = 10.0  // 너무 넓은 뷰 방지
        baseView.mapView.maxZoomLevel = 20.0  // 너무 상세한 뷰 방지
    }
    
    private func setupInfoView() {
        infoWindow.touchHandler = makeInfoWindowTouchHandler()
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
        print(#function)
        return { [weak self] overlay in
            guard let self = self, let marker = overlay as? NMFMarker,
                  let event = marker.userInfo["event"] as? CulturalEventModel else {
                return false
            }

            customSource.title = event.title ?? ""
            infoWindow.dataSource = self.customSource
            currentCameraMoveContext = .markerTap
            focus(on: marker)
//            let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
//            cameraUpdate.animation = .easeIn
//            self.baseView.mapView.moveCamera(cameraUpdate)
//
//            if self.infoWindow.marker == marker {
//                self.infoWindow.close()
//            } else {
//                self.infoWindow.open(with: marker)
//            }

            return true
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let now = Date()
        guard now.timeIntervalSince(lastCameraUpdateTime) > 0.8 else { return }
        lastCameraUpdateTime = now

        //(init) 서울 전체 이벤트 호출
//        fetchFilteredEventsAndUpdateMarkers()
    }
        
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        baseView.resultCollectionView.isHidden = true
        infoWindow.close()
    }
    
    private func fetchEventsAndUpdateMarkers(near coordinate: CLLocationCoordinate2D) {
        viewModel.fetchNearByEvents(near: coordinate) { [weak self] events in
            guard let self = self else { return }

            self.searchResults = events
            self.sortSearchResultsByDistance()
            
            self.updateEventMarkers(with: events)
        }
    }
    
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
        
        baseView.resultCollectionView.reloadData()
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
        print(#function, searchResults)
        switch currentCameraMoveContext {
        case .user:
            print(#function, "user")
            
            baseView.resultCollectionView.isHidden = true

            return // 아무 것도 하지 않음

        case .searchResult:
            print(#function, "searchResult")
            
            baseView.resultCollectionView.isHidden = true

            let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
            cameraUpdate.animation = .easeIn
            baseView.mapView.moveCamera(cameraUpdate)

        case .markerTap:
            print(#function, "markerTap")

            baseView.resultCollectionView.isHidden = true

            if let event = marker.userInfo["event"] as? CulturalEventModel,
               let index = searchResults.firstIndex(where: { $0.id == event.id }) {
                let indexPath = IndexPath(item: index, section: 0)
                baseView.resultCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            fallthrough

        case .collectionViewScroll:
            print(#function, "collectionViewScroll")

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
            
            self.searchResults = events
            self.sortSearchResultsByDistance()
            self.updateEventMarkers(with: events)

            if events.isEmpty {
                showNoResultsMessage()
            } else {
                baseView.resultCollectionView.reloadData()
                adjustCameraToFit(events: events)
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
            let event = searchResults[indexPath.item]

            if let marker = markerDict.values.first(where: {
                guard let mEvent = $0.userInfo["event"] as? CulturalEventModel else { return false }
                return mEvent.id == event.id
            }) {
                currentCameraMoveContext = .collectionViewScroll
                focus(on: marker)
            }
        }
    }

}

// MARK: - CollectionView
extension SearchMapViewController {
    private func sortSearchResultsByDistance() {
        guard let currentLocation = currentUserCoordinate else { return }

        let currentCLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)

        searchResults.sort {
            guard let lat1 = $0.lat, let lon1 = $0.lot,
                  let lat2 = $1.lat, let lon2 = $1.lot else { return false }

            let distance1 = currentCLLocation.distance(from: CLLocation(latitude: lat1, longitude: lon1))
            let distance2 = currentCLLocation.distance(from: CLLocation(latitude: lat2, longitude: lon2))

            return distance1 < distance2
        }
    }
}


extension NMGLatLng {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }
}
