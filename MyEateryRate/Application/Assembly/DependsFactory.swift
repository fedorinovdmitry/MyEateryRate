//
//  DependsFactory.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 18.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation
import UIKit

class DependsFactory {
    static let sharedInstance = DependsFactory()
    private init() {}
    
    func makeUIAlertFactory(viewConroller: UIViewController)
        -> UIAlertFactory {
            return UIAlertCreatingController(viewController: viewConroller)
    }
    
    
}
