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
    
    func deleteObject(_ eatery: Eatery) {
        try! realm.write {
            realm.delete(eatery)
        }
    }
    
    func editingObject(editingEatery: Eatery, newEatery: Eatery) {
        try! realm.write {
            editingEatery.name = newEatery.name
            editingEatery.location = newEatery.location
            editingEatery.imageData = newEatery.imageData
            editingEatery.type = newEatery.type
            editingEatery.rating = newEatery.rating
        }
    }
    
    
}


//MARK: - Preinstall Eateries

extension StorageManager {
    
    func createStandartBase() {
        
        var standartEateries = [Eatery]()
        standartEateries.append(Eatery(name: "MyataLounge",
                                       location: "Moscow",
                                       type: "Hookah",
                                       imageData: UIImage(named: "myatalounge")?.pngData(),
                                       rating: 5.0))
        standartEateries.append(Eatery(name: "MCDonalds",
                                       location: "Belgorod",
                                       type: "Restaurant",
                                       imageData: UIImage(named: "mcdonalds")?.pngData(),
                                       rating: 4.0))
        standartEateries.append(Eatery(name: "Lenta",
                                       location: "Odintcovo",
                                       type: "Hypermarket",
                                       imageData: UIImage(named: "lenta")?.pngData(),
                                       rating: 4.0))
        standartEateries.append(Eatery(name: "KillFish",
                                       location: "Moscow",
                                       type: "Bar",
                                       imageData: UIImage(named: "kilfish")?.pngData(),
                                       rating: 2.0))
        standartEateries.append(Eatery(name: "BurgerKing",
                                       location: "Orel",
                                       type: "Restaurant",
                                       imageData: UIImage(named: "burgerking")?.pngData(),
                                       rating: 3.0))
        
        for eatery in standartEateries {
            saveObject(eatery)
        }
        
    }
}
