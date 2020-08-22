//
//  UIImageExt.swift
//  Lensflare
//
//  Created by Oguz on 22.08.2020.
//

import UIKit

extension UIImage {
    var sizeForScreen: CGSize {
        let screen = UIScreen.main.bounds
        let imageRatio = self.size.height / self.size.width
        
        if imageRatio > screen.height/screen.width {
            let width = (1/imageRatio) * screen.height
            return CGSize(width: width, height: screen.height)

        } else {
            let height = imageRatio * screen.width
            return CGSize(width: screen.width, height: height)

        }
    }
}
