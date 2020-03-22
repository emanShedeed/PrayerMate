//
//  UIButton+Extension.swift
//  PrayerMate
//
//  Created by eman shedeed on 3/22/20.
//  Copyright © 2020 eman shedeed. All rights reserved.
//

import Foundation
import UIKit
extension UIButton
{
    func addBlurEffect()
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
       // blur.alpha=0.2
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView{
            self.bringSubviewToFront(imageView)
        }
    }
}
