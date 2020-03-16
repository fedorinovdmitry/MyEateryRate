//
//  MainViewController.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 16.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Custom types
    
    // MARK: - Constants
    
    let restaurantNames = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    
    
    // MARK: - Outlets
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    // MARK: - IBAction
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Navigation

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - TableView data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        
        let eateryName = restaurantNames[indexPath.row]
        cell.textLabel?.text = eateryName
        cell.imageView?.image = UIImage(named: eateryName)
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
        
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
    
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
