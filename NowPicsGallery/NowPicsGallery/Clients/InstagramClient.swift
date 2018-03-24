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
    
    private var clientInformation: (clientID: String?, clientRedirectURI: String?)? {
        if let path = Bundle.main.path(forResource: "InstagramClient", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: String] {
            return (info["ClientID"], info["RedirectURI"])
        }
        return nil
    }
    
    // MARK: - Initializers
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
}
