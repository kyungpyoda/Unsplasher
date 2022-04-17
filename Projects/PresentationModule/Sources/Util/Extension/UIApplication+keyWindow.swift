//
//  UIApplication+keyWindow.swift
//  PresentationModule
//
//  Created by 홍경표 on 2022/04/18.
//  Copyright © 2022 pio. All rights reserved.
//

import UIKit

extension UIApplication {
    class var keyWindow: UIWindow? {
        guard let appDelegate = shared.delegate,
              let keyWindow = appDelegate.window
        else {
            fatalError("KeyWindow Error")
        }
        return keyWindow
    }
}
