//
//  NewEateryViewController.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 17.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//
import Foundation
import UIKit

class NewEateryViewController: UITableViewController {

    // MARK: - Custom types
    
    // MARK: - Constants
    
    // MARK: - Outlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var eateryImage: UIImageView!
    @IBOutlet weak var eateryName: UITextField!
    @IBOutlet weak var eateryLocation: UITextField!
    @IBOutlet weak var eateryType: UITextField!
    
    
    // MARK: - Public Properties
    
    var imageIsChanged = false
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        eateryName.addTarget(self,
                             action: #selector(textFieldChanged),
                             for: .editingChanged)
    }
    
    
    // MARK: - IBAction
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // MARK: - Public methods
    
    func saveNewEatery() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = eateryImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newEatery = Eatery(name: eateryName.text!,
                               location: eateryLocation.text,
                               type: eateryType.text,
                               imageData: imageData)
        
        StorageManager.sharedInstance.saveObject(newEatery)
        
    }
    
    // MARK: - Private methods
    
    
    // MARK: - Navigation

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
        if eateryName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
}
