//
//  AddPhotoAllert.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 18.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

extension NewEateryViewController {
    
     func addPhotoAlert() {
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = configCameraAction()
        let photo = configPhotoAction()
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addActions(actions: [camera,
                                         photo,
                                         cancel])
        present(actionSheet,
                animated: true,
                completion: nil)
    }
    
    private func configCameraAction() -> UIAlertAction {
        let camera = UIAlertAction(title: "Camera",
                                   style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        let cameraIcon = #imageLiteral(resourceName: "camera")
        camera.setValue(cameraIcon, forKey: "image")
        camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        return camera
    }
    
    private func configPhotoAction() -> UIAlertAction {
        let photo = UIAlertAction(title: "Photo",
                                  style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let photoIcon = #imageLiteral(resourceName: "photo")
        photo.setValue(photoIcon, forKey: "image")
        photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        return photo
    }
}
