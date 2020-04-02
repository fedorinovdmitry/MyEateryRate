//
//  UIAlertFactory.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 18.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

///Фабрика по создания кастомных алертов
protocol UIAlertFactory: class{
    
    func showSimpleAlert(title: String, message: String)
    func showGpsOffAlert()
    func showGpsAccessRestriced()
}

class UIAlertCreatingController: UIAlertFactory {
    
    
    // MARK: - Public methods
    
    func showSimpleAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        addAlertOnView(allertController: alertController)
    }
    
    func showGpsOffAlert() {
        let alertController = UIAlertController(title: "Gps is off" ,
                                                message: "Службаы геолокации отключены на данном устройстве, пожалуйста, перейдите в настройки -> конфиденциальность -> службы геолокации и переключите в состояние включено",
                                                preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        addAlertOnView(allertController: alertController)
    }
    
    func showGpsAccessRestriced() {
        let alertController = UIAlertController(title: "GPS access is restricted",
                                                message: "In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.",
                                                preferredStyle: .alert)
        let goToSetting = UIAlertAction(title: "Go to settins now", style: .default) { (_) in
            UIApplication.tryToOpenAppSettings()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addActions([goToSetting, cancel])
        addAlertOnView(allertController: alertController)
    }
    
    // MARK: - Private methods
    
    private func addAlertOnView(allertController: UIAlertController) {
        DispatchQueue.main.async(execute: {
            var rootViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            
            if let navigationController = rootViewController as? UINavigationController {
                rootViewController = navigationController.viewControllers.last
            }
            if let tabBarController = rootViewController as? UITabBarController {
                rootViewController = tabBarController.selectedViewController
            }
            
            rootViewController?.present(allertController, animated: true, completion: nil)
        })
    }
    
}

// MARK: - UIALertController Extension

extension UIAlertController {
    ///Добавления нескольких акшенов в массиве
    func addActions(_ actions: [UIAlertAction]) {
        for action in actions {
            self.addAction(action)
        }
    }
}
