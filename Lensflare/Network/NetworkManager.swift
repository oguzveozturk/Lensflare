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
    func downloadImage(urlString: String?, isThumbNail: Bool,defaultImage: UIImage, completion: @escaping (_ image: UIImage, _ error: Error?) -> Void) {
        guard let urlString = urlString,
            let url = NSURL(string: urlString) else {
                completion(defaultImage, LErrors.invalidURL)
                return
        }
        
        DispatchQueue.global().async {
            if let cachedImage = self.imageCache.object(forKey: url.absoluteString! as NSString) {
                completion(cachedImage, nil)
            } else {
                if let image = LFImageIO(url).downsample(isThumbNail: isThumbNail) {
                    self.imageCache.setObject(image, forKey: url.absoluteString! as NSString)
                    completion(image, nil)
                } else {
                    completion(defaultImage, LErrors.invalidData)
                }
            }
        }
    }
}


