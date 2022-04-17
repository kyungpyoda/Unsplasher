//
//  UIViewController+setToWindowRootVC.swift
//  PresentationModule
//
//  Created by 홍경표 on 2022/04/18.
//  Copyright © 2022 pio. All rights reserved.
//

import UIKit

extension UIViewController {
    func setToWindowRootVC(animated: Bool) {
        guard let window = UIApplication.keyWindow else { return }
        
        window.rootViewController = self
        
        guard animated else { return }
        
        let duration = 0.3
        let option: UIView.AnimationOptions = .transitionCrossDissolve
        
        UIView.transition(
            with: window,
            duration: duration,
            options: option,
            animations: {
            }
        )
    }
}
