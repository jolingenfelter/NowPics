//
//  URL Extension.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

extension URL {
    
    func appendParameters(_ parameters: [String: Any]?) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        var queryItems = components.queryItems ?? []
        
        if let parameters = parameters {
            for parameter in parameters {
                let item = URLQueryItem(name: parameter.key, value: "\(parameter.value)")
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        
        return url
        
    }
}
