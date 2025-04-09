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
    
    private let locationManager = CLLocationManager()
    private var initialLocationSet = false

    private let infoWindow = NMFInfoWindow()
    private var markerDict: [String: NMFMarker] = [:]
    private let customSource = CustomTextViewSource()
    
    private var lastCameraUpdateTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupInfoView()
        requestLocationAccess()
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

// MARK: - CoreLocation

extension SearchMapViewController: CLLocationManagerDelegate {
    
    private func requestLocationAccess() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        baseView.currentLocationButton.addTarget(self, action: #selector(didTapCurrentLocationButton), for: .touchUpInside)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !initialLocationSet, let location = locations.last else { return }
        initialLocationSet = true
        
        focusOnCurrentLocation(location.coordinate)
        
        locationManager.stopUpdatingLocation()
    }
    
    @objc func didTapCurrentLocationButton() {
        guard let currentLocation = locationManager.location else { return }
        focusOnCurrentLocation(currentLocation.coordinate)
    }
    
    private func focusOnCurrentLocation(_ coordinate: CLLocationCoordinate2D) {

        let lat = coordinate.latitude
        let lng = coordinate.longitude

        let currentLatLng = NMGLatLng(lat: lat, lng: lng)

        let overlay = baseView.mapView.locationOverlay
        overlay.location = currentLatLng
        overlay.hidden = false

        let cameraUpdate = NMFCameraUpdate(scrollTo: currentLatLng)
        cameraUpdate.animation = .easeIn
        baseView.mapView.zoomLevel = 13.0
        baseView.mapView.moveCamera(cameraUpdate)
        
        fetchEventsAndUpdateMarkers(near: coordinate)
        
    }
}

// MARK: - MapView

extension SearchMapViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    
    private func setupMapView() {
        baseView.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        baseView.mapView.touchDelegate = self
        baseView.mapView.addCameraDelegate(delegate: self)
    }
    
    private func setupInfoView() {
        infoWindow.touchHandler = { [weak self] overlay -> Bool in
            guard let self = self else { return false }
            
            if let marker = self.infoWindow.marker,
               let event = marker.userInfo["event"] as? CulturalEventModel {
                self.delegate?.didSelectEvent(event)
            }
            return true
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let now = Date()
        guard now.timeIntervalSince(lastCameraUpdateTime) > 0.8 else { return }
        lastCameraUpdateTime = now
        
        let center = mapView.cameraPosition.target
        let coordinate = CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng)
        
        fetchEventsAndUpdateMarkers(near: coordinate)
    }
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        infoWindow.close()
    }
    
    private func connectHandler(_ marker: NMFMarker) {
        marker.touchHandler = { [weak self] overlay -> Bool in
            guard let self = self, let marker = overlay as? NMFMarker,
                  let event = marker.userInfo["event"] as? CulturalEventModel
            else { return false }
            
            self.customSource.title = event.title ?? ""
            self.infoWindow.dataSource = self.customSource
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
            cameraUpdate.animation = .easeIn
            self.baseView.mapView.moveCamera(cameraUpdate)
            
            if self.infoWindow.marker == marker {
                self.infoWindow.close()
            } else {
                self.infoWindow.open(with: marker)
            }
            
            return true
        }
    }
    
    private func fetchEventsAndUpdateMarkers(near coordinate: CLLocationCoordinate2D) {
        viewModel.fetchNearByEvents(near: coordinate) { [weak self] events in
            guard let self = self else { return }
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
