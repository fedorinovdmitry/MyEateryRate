//
//  StorageManager.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 18.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    static let sharedInstance = StorageManager()
    private init() {}
    
    func saveObject(_ eatery: Eatery) {
        try! realm.write {
            realm.add(eatery)
        }
    }
}
