//
//  Eatery.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 17.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import Foundation

struct Eatery {
    
    var name: String
    var location: String
    var type: String
    var imageName: String
    
    static private let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]

    static func getEateries() -> [Eatery] {
        var eateries = [Eatery]()
        for eateryName in restaurantNames {
            eateries.append(Eatery(name: eateryName,
                                   location: "Орел",
                                   type: "Ресторан",
                                   imageName: eateryName))
        }
        return eateries
    }
}
