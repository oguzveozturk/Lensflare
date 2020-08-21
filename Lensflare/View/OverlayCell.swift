//
//  OverlayCell.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import UIKit

final class OverlayCell: UICollectionViewCell {
    static let identifier = "OverlayCell"
    
    var index = 0
    
    var cellData: OverlayModel? {
        didSet {
            if let url = cellData?.overlayPreviewIconUrl {
                NetworkManager.shared.downloadImage(urlString: url) { (image, error) in
                    DispatchQueue.main.async {
                        self.overlayThumb.image = image
                    }
                }
                titleLabel.text = cellData?.overlayName
            } else {
                overlayThumb.image = #imageLiteral(resourceName: "forbidden").withTintColor(.systemGray5)
                titleLabel.text = "None"
            }
        }
    }
    
   private var overlayThumb: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = #colorLiteral(red: 0, green: 0.007948690094, blue: 0.003851474961, alpha: 1)
        iv.layer.cornerRadius = 9
        iv.layer.borderColor = #colorLiteral(red: 0.1407748461, green: 0.4721385837, blue: 0.7627988458, alpha: 1).cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    private var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 12, weight: .regular)
        l.textColor = .systemGray5
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? (overlayThumb.layer.borderWidth = 2) : (overlayThumb.layer.borderWidth = 0)
        }
    }
    
    private func setupLayout() {
        contentView.addSubview(overlayThumb)
        NSLayoutConstraint.activate([
            overlayThumb.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            overlayThumb.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            overlayThumb.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.7),
            overlayThumb.heightAnchor.constraint(equalTo: overlayThumb.widthAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: overlayThumb.bottomAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            titleLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}
