//
//  UIApplicationHelp.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 27.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

extension UIApplication {

    @discardableResult
    static func tryToOpenAppSettings() -> Bool {
        guard
            let settingsURL = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsURL)
            else {
                return false
        }

        UIApplication.shared.open(settingsURL)
        return true
    }
}
