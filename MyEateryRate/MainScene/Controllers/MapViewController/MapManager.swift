//
//  MapManager.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 31.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import MapKit
import UIKit

protocol MapActionFactory: class {
    
    var locationManager: CLLocationManager { get }
    
    /// Определение центра отображаемой области карты
    func getCenterLocation(for mapView: MKMapView) -> CLLocation
    
    /// Устанавливает маркер заведения на мепвью
    func setupPlacemark(eatery: Eatery,
                        mapView: MKMapView)
    
    /// Проверка доступности сервисов геолокации
    func checkLocationServices(mapView: MKMapView,
                               segueIdentifier: String,
                               closure: () -> ())
    
    /// Проверка авторизации приложения для использования сервисов геолокации
    func checkLocationAuthorization(mapView: MKMapView,
                                    segueIdentifier: String)
    
    /// Центрирует mapView по позиции пользователя
    func showUserLocation(mapView: MKMapView)
    
    /// Строим маршрут от местоположения пользователя до заведения
    func getDirections(for mapView: MKMapView,
                       previousLocation: (CLLocation) -> (),
                       fastRouteSet: @escaping (MKRoute) -> ())
    
    /// Данный метод меняет отображаемую зону области карты в соответствии с перемещением пользователя
    /// - parameter closure: замыкание которое вовращает координаты центра отображаемой области в ходе перемещения пользователя
    /// - parameter currentLocation: текущие координаты пользователя
    func startTrakingUserLocation(for mapView: MKMapView,
                                  and location: CLLocation?,
                                  closure: (_ currentLocation: CLLocation) -> ())
    
//    init(viewController: UIViewController)
    
}

class MapManager: MapActionFactory {
    
    // MARK: - Custom types
    
    // MARK: - Constants
    
    let locationManager = CLLocationManager()
    private let regionInMeters = 1000.00
    
    
    // MARK: - Outlets
    
    // MARK: - Public Properties
    
    private var directionsArray: [MKDirections] = []
    private var eateryCoordinate: CLLocationCoordinate2D?
    
    // MARK: - Private Properties
    
    private lazy var showAlertController = DependsFactory.sharedInstance.makeUIAlertFactory()
    
    // MARK: - Init
    
    // MARK: - Methods
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // MARK: Setup
    
    func setupPlacemark(eatery: Eatery,
                        mapView: MKMapView) {
        
        guard let location = eatery.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error)  in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = eatery.name
            annotation.subtitle = eatery.type
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            self.eateryCoordinate = placemarkLocation.coordinate
            
            mapView.showAnnotations([annotation], animated: true)
            mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
    
    private func resetMapView(withNew directions: MKDirections, mapView: MKMapView) {
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
        
    }
    
    // MARK: Check location access
    
    func checkLocationServices(mapView: MKMapView,
                               segueIdentifier: String,
                               closure: () -> ()) {
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView,
                                       segueIdentifier: segueIdentifier)
            closure()
            
        } else {
            showAlertController.showGpsOffAlert()
        }
    }
    
    func checkLocationAuthorization(mapView: MKMapView,
                                    segueIdentifier: String) {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if segueIdentifier == "getAddress" {
                showUserLocation(mapView: mapView)
            }
            break
        case .denied:
            showAlertController.showGpsAccessRestriced()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlertController.showSimpleAlert(title: "CLL Status is restricted" , message: "")
            break
        case .authorizedAlways:
            break
        
        @unknown default:
            print("New case is available")
        }

    }
    
    // MARK: Work with map
    
    func showUserLocation(mapView: MKMapView) {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            
            mapView.setRegion(region,
                              animated: true)
        }
    }
    
    // MARK: Create Road functions

    func getDirections(for mapView: MKMapView,
                       previousLocation: (CLLocation) -> (),
                       fastRouteSet: @escaping (MKRoute) -> ()) {
        
        guard let location = locationManager.location?.coordinate else {
            showAlertController.showSimpleAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude,
                                    longitude: location.longitude))
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlertController.showSimpleAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions, mapView: mapView)
        
        //рассчет маршрута
        directions.calculate { [weak self, fastRouteSet] (response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response,
                var fastRoute = response.routes.first else {
                self?.showAlertController.showSimpleAlert(title: "Error",
                                                          message: "Destination is not avaible")
                return
            }
            var fastTime: Double = fastRoute.expectedTravelTime
            
            for route in response.routes {
                if route.expectedTravelTime < fastTime {
                    fastTime = route.expectedTravelTime
                    fastRoute = route
                }
                mapView.addOverlay(route.polyline)
                //отображение всего маршрута на карте
                mapView.setVisibleMapRect(route.polyline.boundingMapRect,
                                                animated: true)
                
            }
            
            fastRouteSet(fastRoute)
            
        }
    }
    
    private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        guard let destinationCoordinate = eateryCoordinate else { return nil }
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    func startTrakingUserLocation(for mapView: MKMapView,
                                  and location: CLLocation?,
                                  closure: (_ currentLocation: CLLocation) -> ()) {
        
        guard let previousLocation = location else { return }
        let center = getCenterLocation(for: mapView)
        guard center.distance(from: previousLocation) > 50 else { return }
        closure(center)
        
        
    }
    
}
