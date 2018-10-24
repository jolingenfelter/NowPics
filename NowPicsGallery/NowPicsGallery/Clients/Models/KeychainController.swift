//
//  KeychainController.swift
//  NowPicsGallery
//
//  Created by Jo Lingenfelter on 10/23/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

public struct KeychainController {
    private enum KeychainKeys {
        static let accessToken = "AccessToken"
    }
    
    private static let keychain: KeychainSwift = KeychainSwift(keyPrefix: "NowPics_")
    
    public static var isAuthenticated: Bool {
        return retrieveAccessToken() != nil
    }

    // Returns active access token
    public static func retrieveAccessToken() -> String? {
        return keychain.get(KeychainKeys.accessToken)
    }

    private static func deleteAccessToken() {
        keychain.delete(KeychainKeys.accessToken)
    }

    public static func logOut() {
        deleteAccessToken()
    }

    public static func storeAccessToken(_ accessToken: String) {
        keychain.set(accessToken, forKey: KeychainKeys.accessToken)
    }
}
