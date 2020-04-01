//
//  MKMapViewDelegate.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 27.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation
import MapKit

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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = mapManager.getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        if incomeSegueIdentifier == "showEatery" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.mapManager.showUserLocation(mapView: mapView)
            }
        }
        
        geocoder.cancelGeocode()
        
        geocoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks,
                let mapVC = self else { return }
            let placemark = placemarks.first
            mapVC.centerPlacemark = placemark
            
        }
        
    }
    
    //создание линии
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .orange
        
        return renderer
    }
}
