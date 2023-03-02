//
//  SavedFoodController.swift
//  toxicFoodDetector
//
//  Created by hedi on 1/3/2023.
//

import UIKit

class SavedFoodController : UIViewController

{
    // MARK: - properties
    let pop = PopUp()
    
    // MARK: -  Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addSubview(pop)
        
    }
    
    init(title:String , description: String) {
        super.init(nibName: nil, bundle: nil)
        pop.set(title: title, description: description)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
