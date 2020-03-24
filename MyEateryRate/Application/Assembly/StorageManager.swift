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
    
    func createStandartBase() {
        
        var standartEateries = [Eatery]()
        standartEateries.append(Eatery(name: "MyataLounge",
                                       location: "Moscow",
                                       type: "Hookah",
                                       imageData: UIImage(named: "myatalounge")?.pngData()))
        standartEateries.append(Eatery(name: "MCDonalds",
                                       location: "Belgorod",
                                       type: "Restaurant",
                                       imageData: UIImage(named: "mcdonalds")?.pngData()))
        standartEateries.append(Eatery(name: "Lenta",
                                       location: "Odintcovo",
                                       type: "Hypermarket",
                                       imageData: UIImage(named: "lenta")?.pngData()))
        standartEateries.append(Eatery(name: "KillFish",
                                       location: "Moscow",
                                       type: "Bar",
                                       imageData: UIImage(named: "kilfish")?.pngData()))
        standartEateries.append(Eatery(name: "BurgerKing",
                                       location: "Orel",
                                       type: "Restaurant",
                                       imageData: UIImage(named: "burgerking")?.pngData()))
        
        for eatery in standartEateries {
            saveObject(eatery)
        }
        
    }
}
