//
//  NewEateryViewController.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 17.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class NewEateryViewController: UITableViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var eateryImage: UIImageView!
    @IBOutlet weak var eateryName: UITextField!
    @IBOutlet weak var eateryLocation: UITextField!
    @IBOutlet weak var eateryType: UITextField!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    // MARK: - Public Properties
    
    var currentEatery: Eatery?
    var imageIsChanged = false
    
    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationController?.navigationBar.isHidden = false
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        
        saveButton.isEnabled = false
        eateryName.addTarget(self,
                             action: #selector(textFieldChanged),
                             for: .editingChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setupEditScreen()
    }
    
    // MARK: - IBAction
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // MARK: - Public methods
    
    func saveEatery() {
        
        let newEatery = getNewEateryFromScreen()
        
        if let editEatery = currentEatery {
            StorageManager.sharedInstance.editingObject(editingEatery: editEatery,
                                                        newEatery: newEatery)
        } else {
            StorageManager.sharedInstance.saveObject(newEatery)
        }
        
    }
    
    func getNewEateryFromScreen() -> Eatery {
        
        let image = imageIsChanged ? eateryImage.image : #imageLiteral(resourceName: "imagePlaceholder")
        
        let imageData = image?.pngData()
        
        let newEatery = Eatery(name: eateryName.text!,
                               location: eateryLocation.text,
                               type: eateryType.text,
                               imageData: imageData,
                               rating: Double(ratingControl.rating))
        return newEatery
    }
    
    // MARK: - Private methods
    
    //MARK: Edit eatery screen setup
    
    private func setupEditScreen() {
        if let eatery = currentEatery {
            
            setupNavigationBar()
            imageIsChanged = true
            setupCellsContent(eatery: eatery)
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                        style: .plain,
                                                        target: nil,
                                                        action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentEatery?.name
        saveButton.isEnabled = true
    }
    
    private func setupCellsContent(eatery: Eatery) {
        guard let data = eatery.imageData,
            let image = UIImage(data: data) else {
                return
        }
        
        eateryImage.image = image
        eateryImage.contentMode = .scaleAspectFill
        eateryName.text = eatery.name
        eateryLocation.text = eatery.location
        eateryType.text = eatery.type
        ratingControl.rating = Int(eatery.rating)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier,
            let mapVC = segue.destination as? MapViewController
            else { return }
        
        mapVC.incomeSegueIdentifier = identifier
        mapVC.mapViewControllerDelegate = self
        
        if identifier == "showEatery" {
            mapVC.eatery = getNewEateryFromScreen()
        }
    }
    
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            addPhotoAlert()
        } else {
            view.endEditing(true)
        }
    }
    
}

//MARK: - Text field Delegate

extension NewEateryViewController: UITextFieldDelegate {
    
    //скрываем клавиатуру по нажатию на Done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        saveButton.isEnabled = eateryName.text?.isEmpty == false ? true : false
    }
    
}


//MARK: - MapViewController Delegate

extension NewEateryViewController: MapViewControllerDelegate {
    func getAddress(_ address: CLPlacemark?) {
        let cityName = address?.locality
        let streetName = address?.thoroughfare
        let buildNumber = address?.subThoroughfare
        
        eateryLocation.text = "\(cityName ?? ""), \(streetName ?? "") \(buildNumber ?? "")"
        
    }
}
