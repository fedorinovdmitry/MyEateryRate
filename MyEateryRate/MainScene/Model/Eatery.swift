//
//  Eatery.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 17.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.

import RealmSwift


class Eatery: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var imageData: Data?
    
    convenience init(name: String,
                     location: String?,
                     type: String?,
                     imageData: Data?) {
        self.init()
        
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}
