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
    case failureToDownloadData
    case unknownError
    case badRequest

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
        case .failureToDownloadData:
            return NSLocalizedString("Failure to download Instagram data.  Check your network connection and then try closing and relaunching the app.", comment: "")
        case .unknownError:
            return NSLocalizedString("An unknown error occured", comment: "")
        case .badRequest:
            return NSLocalizedString("Failed web request with error description", comment: "")
        }
    }
}
