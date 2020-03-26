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
    
    // MARK: - Outlets
    
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var eateries: Results<Eatery>!
    
    private var ascendingSorting = true
    
    //переменные для поиска 
    let searchController = UISearchController(searchResultsController: nil)
    var filtredEateries: Results<Eatery>!
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eateries = realm.objects(Eatery.self)
        
        ///Setup the searchController
        configSearchController()
        
    }
    
    // MARK: - IBAction
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            eateries = eateries.sorted(byKeyPath: "date",
                                       ascending: ascendingSorting)
        } else {
            eateries = eateries.sorted(byKeyPath: "name",
                                       ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let eatery = isFiltering ? filtredEateries[indexPath.row] : eateries[indexPath.row]
            
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
        if isFiltering {
            return filtredEateries.count
        }
        return eateries.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EateryViewCell.identefier, for: indexPath) as! EateryViewCell
        
        let eatery = isFiltering ? filtredEateries[indexPath.row] : eateries[indexPath.row]
        
        cell.configure(with: eatery)
        return cell
    }
    
    
    // MARK: - TableView delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
