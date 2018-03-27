//
//  ImageGetter.swift
//  SimpleImageDownloaderExample
//
//  Created by Joanna LINGENFELTER on 3/27/18.
//  Copyright © 2017 Andrew Carter. All rights reserved.
//
//  This code was written with help from Andrew Carter, a developer at Willow Tree Charlottesville

import UIKit

class ImageGetter {

    enum ImageGetterError: Error {
        case unknown
    }
    
    typealias CompletionHandler = (Result<UIImage>) -> Void
    
    private let imageGetterQueue = DispatchQueue(label: "com.ImageGetter.imageGetterQueue")
    private let session = URLSession(configuration: .default)
    
}
