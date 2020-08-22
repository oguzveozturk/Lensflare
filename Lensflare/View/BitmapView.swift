//
//  BitmapView.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import UIKit

final class BitmapView: UIView {
        
    private var givenImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private var overlayImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ givenImage: UIImage) {
        self.init()
        self.givenImageView.image = givenImage
    }
}

extension BitmapView {
    private func setupLayout() {
        addSubview(givenImageView)
        NSLayoutConstraint.activate([
            givenImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            givenImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            givenImageView.widthAnchor.constraint(equalTo: widthAnchor),
            givenImageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        addSubview(overlayImageView)
        NSLayoutConstraint.activate([
            overlayImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            overlayImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            overlayImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            overlayImageView.heightAnchor.constraint(equalTo: overlayImageView.widthAnchor)
        ])
    }
}
extension BitmapView: ViewControllerDelegate {
    func viewControllerDelegate(_ vc: ViewController, selected image: UIImage?) {
            overlayImageView.image = image
    }
}
