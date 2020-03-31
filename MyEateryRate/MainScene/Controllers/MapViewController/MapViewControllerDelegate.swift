//
//  MapViewControllerDelegate.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 30.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation
import MapKit

protocol MapViewControllerDelegate {
    func getAddress(_ address: CLPlacemark?)
    
}

