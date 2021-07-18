//
//  LaunchViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/06/21.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    private let titleLabel: UILabel = .init().then {
        $0.text = " Unsplasher "
        $0.font = .preferredFont(forTextStyle: .largeTitle)
        $0.adjustsFontSizeToFitWidth = true
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
        goMain()
    }
    
    private func setUp() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(self.view.safeAreaLayoutGuide)
            $0.trailing.lessThanOrEqualTo(self.view.safeAreaLayoutGuide)
            $0.center.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(titleLabel.font.lineHeight*2).multipliedBy(2)
        }
    }
    
    private func goMain() {
        do {
            let globalPropertyService = try GlobalPropertyService()
            let serviceProvider = ServiceProvider(globalPropertyService: globalPropertyService)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let mainTab = MainTabBarController(provider: serviceProvider)
                AppDelegate.shared?.swapVC(to: mainTab)
            }
        } catch {
            let alertVC = UIAlertController(
                title: "⚠️실행 불가",
                message: "[\(error) Error]\n\(error.localizedDescription)",
                preferredStyle: .alert
            )
            view.addSubview(alertVC.view)
            alertVC.view.snp.makeConstraints {
                $0.center.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }
    
}
