//
//  OverlayCell.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import UIKit

final class OverlayCell: UICollectionViewCell, ReusableView {
    
    struct ViewModel {
        let overlayPreviewIconUrl: String?
        let overlayName: String?
    }
    
    static let identifier = "OverlayCell"
    
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
        l.textColor = .white
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
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
            if isSelected {
                titleLabel.textColor = #colorLiteral(red: 0.1407748461, green: 0.4721385837, blue: 0.7627988458, alpha: 1)
                overlayThumb.layer.borderWidth = 2
            } else {
                titleLabel.textColor = .white
                overlayThumb.layer.borderWidth = 0
            }
        }
    }
    
    func set(_ viewModel: ViewModel) {
        overlayThumb.setImage(viewModel.overlayPreviewIconUrl,isThumbNail: true)
        titleLabel.text = viewModel.overlayName
    }
    
    private func setupLayout() {
        contentView.addSubview(overlayThumb)
        NSLayoutConstraint.activate([
            overlayThumb.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            overlayThumb.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            overlayThumb.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            overlayThumb.heightAnchor.constraint(equalTo: overlayThumb.widthAnchor)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: overlayThumb.bottomAnchor, constant: 5),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            titleLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}


