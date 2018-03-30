//
//  InstagramResponse.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/25/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

struct InstagramResponse<T: Decodable>: Decodable {

    let data: T?
    let meta: Meta
    let pagination: Pagination?
    
    struct Meta: Decodable {
        let code: Int
        let errorType: String?
        let errorMessage: String?
        
        private enum CodingKeys: String, CodingKey {
            case code
            case errorType = "error_type"
            case errorMessage = "error_message"
        }
    }
    
    struct Pagination: Decodable {
        let nextURL: String?
        let nextMaxId: String?
        
        private enum CodingKeys: String, CodingKey {
            case nextURL = "next_url"
            case nextMaxId = "next_max_id"
        }
    }
}
