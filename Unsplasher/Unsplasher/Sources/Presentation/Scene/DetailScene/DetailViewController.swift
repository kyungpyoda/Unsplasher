//
//  DetailViewController.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/19.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit

final class DetailViewController: UIViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let poImageView: UIImageView = POImageView()
    private lazy var heartButton: UIButton = .init(type: .system).then {
        $0.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 15
    }
    private lazy var closeButton: UIButton = .init(type: .close).then {
        $0.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    init(reactor: DetailViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        view.addSubview(poImageView)
        poImageView.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(poImageView.snp.width)
        }
        view.addSubview(heartButton)
        heartButton.snp.makeConstraints {
            $0.top.equalTo(poImageView.snp.bottom).offset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(heartButton.snp.height)
        }
    }
    
    @objc private func back() {
        if presentingViewController == nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

// MARK: Bind Reactor

extension DetailViewController: View {
    func bind(reactor: DetailViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: DetailViewReactor) {
        heartButton.rx.tap
            .map { Reactor.Action.toggleFavorite }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: DetailViewReactor) {
        reactor
            .pulse(\.$imageModel)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { imageModel in
                if let imageURLStr = imageModel.urls?.small {
                    ImageService.loadImage(urlStr: imageURLStr) { [weak self] (image, urlStr) in
                        guard urlStr == imageURLStr else { return }
                        DispatchQueue.main.async {
                            self?.poImageView.image = image
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        reactor
            .pulse(\.$isFavorite)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isFavorite in
                let heart = isFavorite ? "❤️" : "🤍"
                self?.heartButton.setTitle(heart, for: .normal)
            })
            .disposed(by: disposeBag)
    }
}
