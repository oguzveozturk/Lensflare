//
//  UIImageExt.swift
//  Lensflare
//
//  Created by Oguz on 22.08.2020.
//

import UIKit

extension UIImage {
    func fittingSizeForGiven(height:CGFloat) -> CGSize {
        let screen = UIScreen.main.bounds
        let imageRatio = self.size.height / self.size.width
        
        if imageRatio > height/screen.width {
            let neededWidth = (1/imageRatio) * height
            return CGSize(width: neededWidth, height: height)

        } else {
            let neededHeight = imageRatio * screen.width
            return CGSize(width: screen.width, height: neededHeight)
        }
    }
}
