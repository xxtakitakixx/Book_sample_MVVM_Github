//
//  ImageDownloader.swift
//  Book_sample_MVVM_Github
//
//  Created by Taki on 2023/06/28.
//

import Foundation
import UIKit

final class ImageDownloader {
    var cacheImage: UIImage?
    
    func downloadImage(imageURL: String,
                       success: @escaping (UIImage) -> Void,
                       failure: @escaping (Error) -> Void) {
        
        if let chacheImage = cacheImage {
            success(cacheImage)
        }
        
        var request = URLRequest(url: URL(string: imageURL)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            guard let imageFromData = UIImage(data: data) else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            DispatchQueue.main.async {
                success(imageFromData)
            }
            self.cacheImage = imageFromData
        }
        task.resume()
    }
}
