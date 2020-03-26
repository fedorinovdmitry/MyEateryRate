//
//  RatingControl.swift
//  MyEateryRate
//
//  Created by Дмитрий Федоринов on 19.03.2020.
//  Copyright © 2020 Дмитрий Федоринов. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    // MARK: - Custom types
    
    // MARK: - Constants
    
    // MARK: - Outlets
    
    // MARK: - Public Properties
    
    var rating = 0 {
        didSet {
            updateButtonsSelectionState()
        }
    }
    
    //чтобы отобразилось в сториборде, необходимо явно прописать тип
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0,
                                                 height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    
    // MARK: - Private Properties
    
    private var ratingButtons = [UIButton]()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: - LifeStyle ViewController
    
    // MARK: - Button Action
    
    @objc func ratingButtonTap(button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else {return}
        
        //calculate the rating of selected button
        let selectedRating = index + 1
        
        rating = selectedRating == rating ? 0 : selectedRating
        
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    private func updateButtonsSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
    private func setupButtons() {
        
        //очишение массива кнопок для последующей замены на нужноe число из сториборда
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //load button image
        //прописываем путь к ассету, чтобы явно указать для отображения звезд на сториборде
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar",
                                      in: bundle,
                                      compatibleWith: self.traitCollection)
        
        
        
        for _ in 0..<starCount {
            //create the button
            let button = UIButton()
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            //add constraints
            //отключает автоматически сгенерированые констрейты для кнопки
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //setup the button action
            button.addTarget(self, action: #selector(ratingButtonTap(button:)),
                             for: .touchUpInside)
            
            //add the button to the stack
            addArrangedSubview(button)
            
            //add the new button on the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonsSelectionState()
    }
    // MARK: - Navigation


}
