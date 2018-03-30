//
//  InstagramMedia.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/25/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

public struct InstagramMedia: Decodable {
    
    public let images: Images
    public let userHasLiked: Bool
    public let link: URL
    
    public struct Images: Decodable {
        
        public let thumbnail: Resolution
        public let lowResolution: Resolution
        public let standardResolution: Resolution
        
        private enum CodingKeys: String, CodingKey {
            case thumbnail
            case lowResolution = "low_resolution"
            case standardResolution = "standard_resolution"
        }
    }
    
    public struct Resolution: Decodable {
        
        public let width: Int
        public let height: Int
        public let url: URL
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, images, link
        case userHasLiked = "user_has_liked"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        link = try container.decode(URL.self, forKey: .link)
        images = try container.decode(Images.self, forKey: .images)
        userHasLiked = try container.decode(Bool.self, forKey: .userHasLiked)
    }
    
}
