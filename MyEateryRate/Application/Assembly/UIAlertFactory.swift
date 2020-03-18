//
//  UIAlertFactory.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 18.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

///Фабрика по создания кастомных алертов
protocol UIAlertFactory {
    
    init(viewController: UIViewController)
}

class UIAlertCreatingController: UIAlertFactory {
    
    // MARK: - Custom types
    
    // MARK: - Constants
    
    // MARK: - Outlets
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let viewController: UIViewController
    
    
    // MARK: - Init
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    
    // MARK: - LifeStyle ViewController
    
    // MARK: - IBAction
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    private func addOnView(viewController: UIViewController) {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let customAlertController = self else { return }
            customAlertController.viewController.present(viewController,
                                                         animated: true,
                                                         completion: nil)
        })
    }
    
    // MARK: - Navigation
    
}

// MARK: - UIALertController Extension

extension UIAlertController {
    ///Добавления нескольких акшенов в массиве
    func addActions(actions: [UIAlertAction]) {
        for action in actions {
            self.addAction(action)
        }
    }
}
