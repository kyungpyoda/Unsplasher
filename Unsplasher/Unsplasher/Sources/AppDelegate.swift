//
//  AppDelegate.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/14.
//

import UIKit
import SnapKit
import Then

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        launch()
        
        return true
    }
    
    private func launch() {
        swapVC(to: LaunchViewController())
    }
    
    func swapVC(to vc: UIViewController) {
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
}
