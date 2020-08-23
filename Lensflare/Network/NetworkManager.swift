//
//  NetworkManager.swift
//  Lensflare
//
//  Created by Oguz on 21.08.2020.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    
    private var components: URLComponents = {
        var comp = URLComponents()
        comp.scheme = "https"
        comp.host = "lyrebirdstudio.s3-us-west-2.amazonaws.com"
        return comp
    }()
    
    func getData<Model:Decodable>(type: Model.Type,_ httpMethod: HTTPMethod, params: [String:String], completed: @escaping (Result<Model,LErrors>) -> Void ){
        
        components.path = "/candidates/overlay.json"
        
        params.forEach {
            components.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        print("url",request)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                completed(.success(decodedData))
            } catch {
                print(error)
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
   private let imageCache = NSCache<NSString, UIImage>()
    
    func downloadImage(urlString: String?,isThumbNail: Bool, completion: @escaping (_ image: UIImage, _ error: Error?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else { completion(#imageLiteral(resourceName: "forbidden").withTintColor(.white), LErrors.invalidURL); return }
        DispatchQueue.global().async {
            if let cachedImage = self.imageCache.object(forKey: url.absoluteString as NSString) {
                completion(cachedImage, nil)
            } else {
                if let image = self.downsample(imageAt: url, isThumbNail: isThumbNail ) {
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion(#imageLiteral(resourceName: "forbidden").withTintColor(.white), LErrors.invalidData)
                }
            }
        }
    }
    
    
    private func downsample(imageAt imageURL: URL,isThumbNail:Bool) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: !isThumbNail] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else { return nil }
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


