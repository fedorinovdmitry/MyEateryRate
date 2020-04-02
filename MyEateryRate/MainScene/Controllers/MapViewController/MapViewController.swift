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
    
    var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrakingUserLocation(for: mapView,
                                                and: previousLocation) { [weak self] (currentLocation) in
                                                    guard let self = self else { return }
                                                    self.previousLocation = currentLocation
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                        self.mapManager.showUserLocation(mapView: self.mapView)
                                                    }
            }
        }
    }
    
    var centerPlacemark: CLPlacemark? {
           didSet {
               guard let streetName = centerPlacemark?.thoroughfare else { return }
               let buildNumber = centerPlacemark?.subThoroughfare

               DispatchQueue.main.async {
                   
                   self.addressLabel.text = "\(streetName) \(buildNumber ?? "")"
                   
               }
           }
       }
    
    // MARK: - Private Properties
    
    lazy var mapManager = DependsFactory.sharedInstance.makeMapActionFactory()
    

    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = ""
        setupMapView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - IBAction
    
    @IBAction func closeVC() {
        navigationController?.popViewController(animated: true)

    }
    
    @IBAction func centerViewInUserLocation() {
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        mapViewControllerDelegate?.getAddress(centerPlacemark)
        closeVC()
    }
    
    @IBAction func goButtonPressed() {
        mapManager.getDirections(for: mapView,
                                 previousLocation:
            { [weak self] (location) in
               guard let mapVC = self else { return }
                mapVC.previousLocation = location
        },
                                 fastRouteSet:
            { [weak self] (fastRoute) in
                guard let mapVC = self else { return }
                let distance = String(format: "%.1f",
                                      fastRoute.distance / 1000)
                let timeInterval = String(format: "%.0f",
                                          fastRoute.expectedTravelTime / 60)
                mapVC.fastRouteLabel.isHidden = false
                mapVC.fastRouteLabel.text = ("самый быстрый маршрут составит \(distance) км и продлится \(timeInterval) мин")
        })
    }
    
    // MARK: - Private methods
    
    // MARK: SetupsMethods
    
    private func setupMapView() {
        
        mapManager.checkLocationServices(mapView: mapView,
                                         segueIdentifier: incomeSegueIdentifier) {
                                            mapManager.locationManager.delegate = self
        }
        
        goButton.isHidden = true
        fastRouteLabel.isHidden = true
        
        if incomeSegueIdentifier == "showEatery" {
            
            goButton.isHidden = false
            
            mapPinImage.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            
            guard let eatery = eatery else { return }
            mapManager.setupPlacemark(eatery: eatery,
                                      mapView: mapView)
        }
    }

}

//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        mapManager.checkLocationAuthorization(mapView: mapView,
                                              segueIdentifier: incomeSegueIdentifier)
    }
    
}
