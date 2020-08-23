//
//  UIImageViewExt.swift
//  Lensflare
//
//  Created by Oguz on 23.08.2020.
//

import UIKit

extension UIImageView {
    func setImage(_ url: String?, isThumbNail: Bool){
        NetworkManager.shared.downloadImage(urlString: url,isThumbNail: isThumbNail,defaultImage: #imageLiteral(resourceName: "forbidden").withTintColor(.white)) { (image, error) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
