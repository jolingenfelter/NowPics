//
//  InstagramClient.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class InstagramClient {
    
    // MARK: - Properties
    var configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    // MARK: - Initializers
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
}
