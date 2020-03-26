//
//  MapViewController.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 26.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Custom types
    
    // MARK: - Constants
    let annotationIdentifier = "annotationIdentifier"
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - Public Properties
    
    var eatery: Eatery?
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlacemark()
        
    }
    
    
    // MARK: - IBAction
    
    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
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
            
            mapVC.mapView.showAnnotations([annotation], animated: true)
            mapVC.mapView.selectAnnotation(annotation, animated: true)
            
        }
    }
    
    
    // MARK: - Navigation

    

}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //если аннотация это текующее геопозиция пользователя то отмечать ее не будем
        if annotation is MKUserLocation { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView //приводим к типу который отображает марку
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                              reuseIdentifier: annotationIdentifier)
            
            //чтобы наша аннотация отобразилась в виде банера
            annotationView?.canShowCallout = true
        }
        
        if let imageData = eatery?.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        return annotationView
    }
}
