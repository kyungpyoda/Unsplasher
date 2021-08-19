//
//  POImageView.swift
//  Unsplasher
//
//  Created by 홍경표 on 2021/07/19.
//

import UIKit

final class POImageView: UIImageView {
    
    private var isFit: Bool = true {
        didSet {
            guard contentMode == .scaleAspectFit || contentMode == .scaleAspectFill
            else { return }
            contentMode = isFit ? .scaleAspectFit : .scaleAspectFill
        }
    }
    
    private let highlightView: UIView = {
        let highlightView = UIView()
        highlightView.backgroundColor = .label
        highlightView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        highlightView.alpha = 0
        return highlightView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    override init(image: UIImage?) {
        super.init(image: image)
        setUp()
    }
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setUp()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        isUserInteractionEnabled = true
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0
        tap.delegate = self
        addGestureRecognizer(tap)
        
        highlightView.frame.size = frame.size
        addSubview(highlightView)
        
        backgroundColor = .secondarySystemBackground
        contentMode = .scaleAspectFit
        layer.masksToBounds = true
    }
    
    @objc private func tapHandler(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            isFit.toggle()
        } else if gesture.state != .began {
            gesture.isEnabled = false
            gesture.isEnabled = true
        }
        highlightView.alpha = gesture.state == .began ? 0.1 : 0
    }
    
}

extension POImageView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
