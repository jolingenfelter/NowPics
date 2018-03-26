//
//  InstagramError.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

enum InstagramError: Error {
    case invalidClientCredentials
    case invalidRequest
    case missingAccessToken
    case dataParsingError
    case failureToDownloadData(message: String)
    case unknownError
    case badRequest(message: String)

}

extension InstagramError {
    public var errorDescription: String {
        switch self {
        case .invalidClientCredentials:
            return NSLocalizedString("Invalid client credentials", comment: "")
        case .invalidRequest:
            return NSLocalizedString("Invalid web request", comment: "")
        case .missingAccessToken:
            return NSLocalizedString("Missing access token", comment: "")
        case .dataParsingError:
            return NSLocalizedString("Error parsing Instagram data", comment: "")
        case .failureToDownloadData(let message):
            return NSLocalizedString("Failure to download Instagram data: \(message)", comment: "")
        case .unknownError:
            return NSLocalizedString("An unknown error occured", comment: "")
        case .badRequest(let message):
            return NSLocalizedString("Failed web request with error description: \(message)", comment: "")
        }
    }
}
