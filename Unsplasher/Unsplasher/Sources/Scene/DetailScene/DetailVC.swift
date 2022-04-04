//
//  DetailVC.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/19.
//

import UIKit

final class DetailVC: UIViewController {
    
    private let storageManager: StorageManager = .init()
    private var imageModel: ImageModel
    private var isFavorite: Bool {
        didSet {
            let heart = isFavorite ? "❤️" : "🤍"
            heartButton.setTitle(heart, for: .normal)
        }
    }
    
    private let poImageView: UIImageView = POImageView()
    private lazy var heartButton: UIButton = .init(type: .system).then {
        $0.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        $0.backgroundColor = .secondarySystemBackground
        $0.layer.cornerRadius = 15
        let heart = isFavorite ? "❤️" : "🤍"
        $0.setTitle(heart, for: .normal)
        $0.addTarget(self, action: #selector(heartTap), for: .touchUpInside)
    }
    private lazy var closeButton: UIButton = .init(type: .close).then {
        $0.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    init(imageModel: ImageModel) {
        // 이미 저장된 데이터면 id값으로 저장된 객체를 가져옴
        if let stored = storageManager.read(type: ImageModel.self, key: imageModel.id) {
            self.imageModel = stored
            isFavorite = true
        } else {
            // 저장된 데이터가 아니면 깊은 복사로 새로운 객체 생성
            // 이렇게 안하면 이 인스턴스가 Realm에서 삭제되면서 invalidate 오류 뜸
            self.imageModel = ImageModel(value: imageModel)
            isFavorite = false
        }
        super.init(nibName: nil, bundle: nil)
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
        
        if let imageURLStr = imageModel.urls?.small {
            ImageService.loadImage(urlStr: imageURLStr) { [weak self] (image, urlStr) in
                guard urlStr == imageURLStr else { return }
                DispatchQueue.main.async {
                    self?.poImageView.image = image
                }
            }
        }
    }
    
    @objc private func heartTap(sender: UIButton) {
        if isFavorite {
            let temp = ImageModel(value: imageModel)
            if storageManager.delete(imageModel) {
                isFavorite.toggle()
                self.imageModel = temp
            }
        } else {
            if storageManager.create(imageModel) {
                isFavorite.toggle()
            }
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
