//
//  FirstLaunchConfig.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 24.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation

extension AppDelegate {
    
    func configFirstLaunch() {
        let userSettings = UserSettings.sharedInstance
        let storageManager = StorageManager.sharedInstance
        
        if userSettings.isFirstAppLaunch {
            storageManager.createStandartBase()
            userSettings.isFirstAppLaunch = true
        }
    }
}
