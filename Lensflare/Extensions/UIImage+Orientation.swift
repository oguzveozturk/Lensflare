//
//  UIImage+Orientation.swift
//  Lensflare
//
//  Created by Oguz on 23.08.2020.
//

import UIKit

extension UIImage.Orientation {
    init(_ orientation: Int) {
        switch orientation {
            case 6: self = .right
            case 1: self = .up
            case 8: self = .left
            case 3: self = .up
        default:
            self = .up
        }
    }
}
