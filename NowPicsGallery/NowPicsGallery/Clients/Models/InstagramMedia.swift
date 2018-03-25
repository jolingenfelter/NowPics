//
//  InstagramMedia.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/25/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

public struct InstagramMediaMe: Decodable {
    
    // MARK: - Properties
    public let images: Images
    public let userHasLiked: Bool
    public let link: URL
    
    public struct Images: Decodable {
        
        /// A Resolution object that contains the width, height and URL of the thumbnail.
        public let thumbnail: Resolution
        
        /// A Resolution object that contains the width, height and URL of the low resolution image.
        public let lowResolution: Resolution
        
        /// A Resolution object that contains the width, height and URL of the standard resolution image.
        public let standardResolution: Resolution
        
        private enum CodingKeys: String, CodingKey {
            case thumbnail
            case lowResolution = "low_resolution"
            case standardResolution = "standard_resolution"
        }
    }
    
    /// A struct containing the resolution of a video or image.
    public struct Resolution: Decodable {
        
        /// The width of the media.
        public let width: Int
        
        /// The height of the media.
        public let height: Int
        
        /// The URL to download the media.
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
