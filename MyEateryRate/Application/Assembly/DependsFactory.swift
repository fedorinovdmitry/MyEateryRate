//
//  DependsFactory.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 18.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation
import UIKit

/// Создание зависимостей проекта
class DependsFactory {
    
    static let sharedInstance = DependsFactory()
    private init() {}
    
    func makeUIAlertFactory() -> UIAlertFactory {
            return UIAlertCreatingController()
    }
    
    func makeMapActionFactory() -> MapActionFactory {
        return MapManager()
    }
    
}
