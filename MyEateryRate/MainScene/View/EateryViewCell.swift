//
//  EateryViewCell.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 17.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

class EateryViewCell: UITableViewCell {

    // MARK: - Custom types
    
    // MARK: - Constants
    
    static let identefier = "eateryCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageOfPlace: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    // MARK: - IBAction
    
    // MARK: - Public methods
    
    func configure(with eatery: Eatery){
        
        nameLabel.text = eatery.name
        
        locationLabel.text = eatery.location
        
        typeLabel.text = eatery.type
        
        imageOfPlace.image = UIImage(data: eatery.imageData!)
        
        imageOfPlace.layer.cornerRadius = imageOfPlace.frame.size.height / 2
        imageOfPlace.clipsToBounds = true
        
        
    }
    
    
    // MARK: - Private methods
    
    // MARK: - Navigation

}
