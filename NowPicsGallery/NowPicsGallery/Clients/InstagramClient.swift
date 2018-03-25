//
//  InstagramClient.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class InstagramClient: APIClient {
    
    // MARK: - Types
    private struct KeychainKeys {
        static let accessToken = "AccessToken"
    }
    
    // MARK: - Properties
    
    static let shared = InstagramClient()
    
    internal let session: URLSession
    private let keychain: KeychainSwift
    private let API: InstagramAPI
    
    // MARK: Initialization
    private init() {
        session = URLSession(configuration: .default)
        keychain = KeychainSwift(keyPrefix: "NowPics_")
        API = InstagramAPI()
    }
    
    // MARK: - Fetch Media
    func fetchFromInstagram<T: Decodable>(withScopes: [InstagramScope], endpoint: String, parameters: [String: Any]?, success: ((_ data: T?) -> Void)?, failure: ((Error) -> Void)?) {
        guard let accessToken = retrieveAccessToken() else {
            failure?(InstagramError.missingAccessToken)
            return
        }
        
        guard let request = API.buildRequest(endpoint: endpoint, withToken: accessToken, parameters: parameters) else {
            failure?(InstagramError.invalidRequest(message: "Error building web request"))
            return
        }
        
        fetch(request) { (result) in
            switch result {
            case .success(let data):
                do {
                    let json = try JSONDecoder().decode(InstagramResponse<T>.self, from: data)
                    if let data = json.data {
                        success?(data)
                    } else if let message = json.meta.errorMessage {
                        failure?(InstagramError.invalidRequest(message: message))
                    } else {
                        failure?(InstagramError.unknownError(message: "Unknown error occored"))
                    }
                } catch let error {
                    failure?(InstagramError.dataParsingError(message: error.localizedDescription))
                }
            case .failure(let error):
                failure?(InstagramError.failureToDownloadData(message: error.localizedDescription))
            }
        }
    
    }
  
    // MARK: - Keychain
    
    public var isAuthenticated: Bool {
        return retrieveAccessToken() != nil
    }
    
    // Returns active access token
    public func retrieveAccessToken() -> String? {
        return keychain.get(KeychainKeys.accessToken)
    }
    
    private func deleteAccessToken() {
        keychain.delete(KeychainKeys.accessToken)
    }
    
    public func logOut() {
        deleteAccessToken()
    }
    
    public func storeAccessToken(_ accessToken: String) {
        keychain.set(accessToken, forKey: KeychainKeys.accessToken)
    }
}








