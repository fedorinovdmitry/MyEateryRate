//
//  MainViewController.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 16.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    // MARK: - Custom types
    
    // MARK: - Constants
    
    var eateries: Results<Eatery>!
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eateries = realm.objects(Eatery.self)
    }
    
    // MARK: - IBAction
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let eatery = eateries[indexPath.row]
            let newEateryVC = segue.destination as! NewEateryViewController
            newEateryVC.currentEatery = eatery
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newEateryVC = segue.source as? NewEateryViewController else { return }
        
        newEateryVC.saveEatery()
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - TableView data source
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return eateries.isEmpty ? 0 : eateries.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EateryViewCell.identefier, for: indexPath) as! EateryViewCell
        
        cell.configure(with: eateries[indexPath.row])
        return cell
    }
    
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let eatery = eateries[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.sharedInstance.deleteObject(eatery)
            tableView.deleteRows(at: [indexPath],
                                 with: .automatic)
        }
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
