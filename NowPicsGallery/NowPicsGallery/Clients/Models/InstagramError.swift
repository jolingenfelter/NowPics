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
    case invalidRequest(message: String)
    case missingAccessToken
    case dataParsingError(message: String)
    case failureToDownloadData(message: String)
    case unknownError(message: String)
    case failedRequest
}
