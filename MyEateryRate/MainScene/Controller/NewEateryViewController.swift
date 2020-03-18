//
//  NewEateryViewController.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 17.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

class NewEateryViewController: UITableViewController {

    // MARK: - Custom types
    
    // MARK: - Constants
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageOfEatery: UIImageView!
    

    // MARK: - Public Properties
    
    //MARK: Depends
    
    // MARK: - Private Properties
    
    // MARK: - Init
    
    // MARK: - LifeStyle ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IBAction
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK:
    private func addPhotoAlert() {
        
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera",
                                   style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        let cameraIcon = #imageLiteral(resourceName: "camera")
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let photo = UIAlertAction(title: "Photo",
                                  style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let photoIcon = #imageLiteral(resourceName: "photo")
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addActions(actions: [camera,
                                         photo,
                                         cancel])
        present(actionSheet,
                animated: true,
                completion: nil)
    }
    
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
    
}

// MARK: - ImagePicker delegate

extension NewEateryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageOfEatery.image = info[.editedImage] as? UIImage
        imageOfEatery.contentMode = .scaleAspectFill
        imageOfEatery.clipsToBounds = true
        dismiss(animated: true)
    }
}
