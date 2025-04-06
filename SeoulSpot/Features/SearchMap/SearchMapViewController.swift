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
    
    private var eventMarkers: [NMFMarker] = []
    let infoWindow = NMFInfoWindow()
    let dataSource = NMFInfoWindowDefaultTextSource.data()
    
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
    }
    
    // 지도를 처음 띄웠을 때의 카메라 이동
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard !initialLocationSet, let location = locations.last else { return }
        initialLocationSet = true
        
        let lat = location.coordinate.latitude
        let lot = location.coordinate.longitude
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lot))
        cameraUpdate.animation = .easeIn
        baseView.mapView.moveCamera(cameraUpdate)
        
        // Stop continuous updates after getting initial position
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - MapView

extension SearchMapViewController: NMFMapViewTouchDelegate, NMFMapViewCameraDelegate {
    
    private func setupMapView() {
        baseView.mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        baseView.mapView.touchDelegate = self
        baseView.mapView.addCameraDelegate(delegate: self)
        
        // [TODO] 임시적으로 일단 모든 이벤트에 대해 처리
        updateEventMarkers(with: viewModel.fetchAllEvents())
    }
    
    private func setupInfoView() {
        infoWindow.touchHandler = { [weak self] overlay -> Bool in
            guard let self = self else { return false }
            
            // 현재 표시된 마커에 연결된 이벤트 찾기
            if let marker = self.infoWindow.marker,
               let event = marker.userInfo["event"] as? CulturalEventModel {
                self.delegate?.didSelectEvent(event)
            }
            
            return true
        }
    }
    
    // [TODO] 지도 위치에 따른 근처 값 가지고 오기
    //    func mapViewCameraIdle(_ mapView: NMFMapView) {
    //        let center = baseView.mapView.cameraPosition.target
    //        let coordinate = CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng)
    //        viewModel.fetchEvents(near: coordinate) { [weak self] events in
    //            self?.updateEventMarkers(with: events)
    //        }
    //    }
    
    private func updateEventMarkers(with events: [CulturalEventModel]) {
        // 기존 마커 제거
        eventMarkers.forEach { $0.mapView = nil }
        eventMarkers.removeAll()
        
        for event in events {
            let marker = NMFMarker(position: NMGLatLng(lat: event.lot ?? 0, lng: event.lat ?? 0)) // API 정보 오류 lat <-> lot
            marker.iconImage = NMF_MARKER_IMAGE_DEFAULT
            marker.width = 20
            marker.height = 28
            marker.userInfo = ["event": event]
            marker.mapView = baseView.mapView
            connectHandler(marker)
            eventMarkers.append(marker)
        }
    }
    
    private func connectHandler(_ marker: NMFMarker) {
        marker.touchHandler = { [weak self] overlay -> Bool in
            guard let self = self, let marker = overlay as? NMFMarker else { return false }
            
            // 데이터 소스 갱신
            if let event = marker.userInfo["event"] as? CulturalEventModel {
                self.dataSource.title = event.title ?? ""
                self.infoWindow.dataSource = self.dataSource
            }
            
            // 열려있던 정보창이 같은 마커라면 닫기
            if self.infoWindow.marker == marker {
                self.infoWindow.close()
            } else {
                self.infoWindow.open(with: marker)
            }
            
            return true
        }
    }
    
    // 지도를 탭하면 정보 창을 닫음
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        infoWindow.close()
    }
}
