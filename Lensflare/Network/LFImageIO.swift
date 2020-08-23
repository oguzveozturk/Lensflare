//
//  LFImageIO.swift
//  Lensflare
//
//  Created by Oguz on 23.08.2020.
//

import UIKit

final class LFImageIO {
    
    let url: NSURL?
    
    init(_ url: NSURL?) {
        self.url = url
    }
    
     func cachedImage() -> UIImage? {
        guard let safeURL = url,
            let imageSource = CGImageSourceCreateWithURL(safeURL, nil) else { return nil }
        
        let options: [NSString:Any] = [kCGImageSourceShouldCacheImmediately: true]
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary)! as NSDictionary
        guard let cachedImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary) else { return nil }
        
        let oriantation = imageProperties[kCGImagePropertyOrientation as String] as? Int ?? 1

        let image = UIImage(cgImage: cachedImage, scale: 1, orientation: UIImage.Orientation(oriantation))
        
        return image
    }
    
    func downsample(isThumbNail:Bool) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: !isThumbNail] as CFDictionary
        guard let safeURL = url,
            let imageSource = CGImageSourceCreateWithURL(safeURL, imageSourceOptions) else { return nil }
        
        if isThumbNail {
            let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                      kCGImageSourceShouldCacheImmediately: true,
                                      kCGImageSourceCreateThumbnailWithTransform: true,
                                      kCGImageSourceThumbnailMaxPixelSize: 100] as CFDictionary
            
            let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)!
            
            return UIImage(cgImage: downsampledImage)
        } else {
                let options: [NSString:Any] = [kCGImageSourceShouldCacheImmediately: true]
                
                guard let cachedImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary) else { return nil }
                return UIImage(cgImage: cachedImage)
        }
    }
}
