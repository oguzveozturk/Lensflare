//
//  OverlayCell.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import UIKit

final class OverlayCell: UICollectionViewCell {
    static let identifier = "OverlayCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
