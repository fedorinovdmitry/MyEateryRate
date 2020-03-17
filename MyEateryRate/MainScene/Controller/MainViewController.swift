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
    
    let eateries = Eatery.getEateries()
    
    
    // MARK: - Outlets
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    // MARK: - IBAction
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Navigation

    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - TableView data source
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return eateries.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EateryViewCell.identefier,
                                                 for: indexPath) as! EateryViewCell
        
        cell.configure(with: eateries[indexPath.row])
        return cell
    }
    
    
    // MARK: - TableView delegate
    
}
