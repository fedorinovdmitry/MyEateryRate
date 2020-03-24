//
//  UserSettings.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 24.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation

final class UserSettings {
    static let sharedInstance = UserSettings()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    
    private enum SettingKeys: String {
        case isFirstAppLaunch
    }
    
    var isFirstAppLaunch: Bool {
        get {
            return !userDefaults.bool(forKey: SettingKeys.isFirstAppLaunch.rawValue)
        } set {
            userDefaults.set(newValue, forKey: SettingKeys.isFirstAppLaunch.rawValue)
        }
    }
    
}
