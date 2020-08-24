//
//  LFImageIO.swift
//  Lensflare
//
//  Created by Oguz on 23.08.2020.
//

import UIKit

final class LFImageIO {
    
    private lazy var localData = PersistantManager.shared
    
    private lazy var entity = localData.fetch(OverlayEntity.self)
    
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
        if isThumbNail {
            guard let safeOverlay = entity.filter({ $0.overlayPreviewIconUrl == url?.absoluteString }).first else { return nil }
            if let localThumb = safeOverlay.thumb as? UIImage {
                return localThumb
            } else {
                guard let safeURL = url,
                    let imageSource = CGImageSourceCreateWithURL(safeURL, nil) else { return nil }
                let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                          kCGImageSourceShouldCacheImmediately: true,
                                          kCGImageSourceCreateThumbnailWithTransform: true,
                                          kCGImageSourceThumbnailMaxPixelSize: 100] as CFDictionary
                
                let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)!
                let image = UIImage(cgImage: downsampledImage)
                safeOverlay.thumb = image
                localData.saveContext()
                
                return UIImage(cgImage: downsampledImage)
            }
        } else {
            guard let safeOverlay = entity.filter({ $0.overlayUrl == url?.absoluteString }).first else { return UIImage() }
            
            if let localImage = safeOverlay.overlay as? UIImage {
                return localImage
            } else {
                guard let safeURL = url,
                    let imageSource = CGImageSourceCreateWithURL(safeURL, nil) else { return UIImage() }
                let options: [NSString:Any] = [kCGImageSourceShouldCacheImmediately: true]
                
                guard let cachedImage = CGImageSourceCreateImageAtIndex(imageSource, 0, options as CFDictionary) else { return UIImage() }
                let image = UIImage(cgImage: cachedImage)
                safeOverlay.overlay = image
                localData.saveContext()
                
                return UIImage(cgImage: cachedImage)
            }
        }
    }
}
