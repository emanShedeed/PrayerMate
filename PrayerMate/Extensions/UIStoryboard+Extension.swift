//
//  UIStoryboard+Extension.swift
//  Ataba
//
//  Created by eman shedeed on 12/14/19.
//  Copyright © 2019 eman shedeed. All rights reserved.
//

import UIKit.UIStoryboard

// MARK: - Storyboards

extension UIStoryboard {
    
    static var main: UIStoryboard { .init(name: "Main", bundle: nil) }
    static var Home: UIStoryboard { .init(name: "Home", bundle: nil) }
    
//    static var Settings: UIStoryboard { .init(name: "Settings", bundle: nil) }
}


// MARK: - Functions

extension UIStoryboard {
    
    func bring<Controller: UIViewController>(_: Controller.Type) -> Controller {
        let identifier = String(describing: Controller.self)
        guard let screen = instantiateViewController(withIdentifier: identifier) as? Controller else {
            fatalError("Doesn't match.")
        }
        return screen
    }
    
}
