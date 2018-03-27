//
//  ImageGetter.swift
//  SimpleImageDownloaderExample
//
//  Created by Joanna LINGENFELTER on 3/27/18.
//  Copyright © 2017 Andrew Carter. All rights reserved.
//
//  This code was written with help from Andrew Carter, a developer at Willow Tree Charlottesville

import UIKit

enum ImageResult<T> {
    case ok(T)
    case error(Error)
}

enum ImageGetterError: Error {
    case unknown
}

class ImageGetter {
    
    typealias CompletionHandler = (ImageResult<UIImage>) -> Void
    
    private let imageGetterQueue = DispatchQueue(label: "com.ImageGetter.imageGetterQueue")
    private let session = URLSession(configuration: .default)
    
    func getImage(from url: URL, completion: @escaping CompletionHandler) {
        let sessionTask = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            
            strongSelf.imageGetterQueue.async {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.error(error))
                    }
                } else if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(.ok(image))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.error(ImageGetterError.unknown))
                    }
                }
                
            }
        }
        sessionTask.resume()
    }
}
