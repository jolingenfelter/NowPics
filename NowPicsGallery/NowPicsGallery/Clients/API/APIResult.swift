//
//  APIResult.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

enum APIResult<T> {
    case success(T)
    case failure(Error)
}
