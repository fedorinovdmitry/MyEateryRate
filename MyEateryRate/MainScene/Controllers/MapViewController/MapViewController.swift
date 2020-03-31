//
//  MapViewController.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 26.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    // MARK: - Custom types
    
    // MARK: - Constants
    
    let annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
    let regionInMeters = 10000.00
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPinImage: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var fastRouteLabel: UILabel!
    
    
    // MARK: - Public Properties
    
    var eatery: Eatery?
    var incomeSegueIdentifier = ""
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var eateryCoordinate: CLLocationCoordinate2D?
    
    // MARK: - Private Properties
    
    var centerPlacemark: CLPlacemark? {
        didSet {
            guard let streetName = centerPlacemark?.thoroughfare else { return }
            let buildNumber = centerPlacemark?.subThoroughfare

            DispatchQueue.main.async {
                
                self.addressLabel.text = "\(streetName) \(buildNumber ?? "")"
                
            }
        }
    }
    
    private lazy var showAlertController = DependsFactory.sharedInstance.makeUIAlertFactory(viewConroller: self)
    
    // MARK: - Init
    

    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressLabel.text = ""
        setupMapView()
        checkLocationServices()
    }
    
    
    // MARK: - IBAction
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    @IBAction func centerViewInUserLocation() {
        showUserLocation()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        mapViewControllerDelegate?.getAddress(centerPlacemark)
        dismiss(animated: true)
    }
    
    @IBAction func goButtonPressed() {
        getDirections()
    }
    
    // MARK: - Public methods
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // MARK: - Private methods
    
    // MARK: SetupsMethods
    
    private func setupMapView() {
        
        goButton.isHidden = true
        fastRouteLabel.isHidden = true
        
        if incomeSegueIdentifier == "showEatery" {
            setupPlacemark()
            
            goButton.isHidden = false
            
            
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
        }
    }
    
    private func setupPlacemark() {
        
        guard let location = eatery?.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] (placemarks, error)  in
            guard let mapVC = self else { return }
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = mapVC.eatery?.name
            annotation.subtitle = mapVC.eatery?.type
            
            guard let placemarkLocation = placemark?.location else { return }
            
            annotation.coordinate = placemarkLocation.coordinate
            mapVC.eateryCoordinate = placemarkLocation.coordinate
            
            mapVC.mapView.showAnnotations([annotation], animated: true)
            mapVC.mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: Check location access
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            
        } else {
            showAlertController.showGpsOffAlert()
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAddress" {
                showUserLocation()
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
    
    private func showUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            
            mapView.setRegion(region,
                              animated: true)
        }
    }
    
    // MARK: Create Road functions

    private func getDirections() {
        guard let loccation = locationManager.location?.coordinate else {
            showAlertController.showSimpleAlert(title: "Error", message: "Current location is not found")
            return
        }
        
        guard let request = createDirectionsRequest(from: loccation) else {
            showAlertController.showSimpleAlert(title: "Error", message: "Destination is not found")
            return
        }
        
        let directions = MKDirections(request: request)
        
        //рассчет маршрута
        directions.calculate { [weak self] (response, error) in
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
                self?.mapView.addOverlay(route.polyline)
                //отображение всего маршрута на карте
                self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
            }
            let distance = String(format: "%.1f", fastRoute.distance / 1000)
            let timeInterval = String(format: "%.0f", fastRoute.expectedTravelTime / 60)
            self?.fastRouteLabel.isHidden = false
            self?.fastRouteLabel.text = ("самый быстрый маршрут составит \(distance) км и продлится \(timeInterval) мин")
            
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
    
}

//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}
