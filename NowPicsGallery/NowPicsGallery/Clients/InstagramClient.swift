//
//  InstagramClient.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

final class InstagramClient: APIClient {
    
    // MARK: - Types
    private struct KeychainKeys {
        static let accessToken = "AccessToken"
    }
    
    // MARK: - Properties
    
    internal let session: URLSession
    private let keychain: KeychainSwift
    private let API: InstagramAPI
   
    init() {
        session = URLSession(configuration: .default)
        keychain = KeychainSwift(keyPrefix: "NowPics_")
        API = InstagramAPI()
    }
    
    // MARK: - Authorization
    public func authorizationRequest(scopes: [InstagramScope]) throws -> URLRequest {
        guard let request = API.buildAuthorizationURLRequest(scopes: scopes) else {
            throw InstagramError.invalidRequest
        }
        return request
    }
    
    // MARK: - Fetch Media
    func fetchFromInstagram<T: Decodable>(endpoint: String, parameters: [String: Any]?, success: ((_ data: T?) -> Void)?, failure: ((Error) -> Void)?) {
        guard let accessToken = retrieveAccessToken() else {
            failure?(InstagramError.missingAccessToken)
            return
        }
        
        guard let request = API.buildRequest(endpoint: endpoint, withToken: accessToken, parameters: parameters) else {
            failure?(InstagramError.invalidRequest)
            return
        }
        
        fetchAPIData(withRequest: request, success: { (data) in
            do {
                let json = try JSONDecoder().decode(InstagramResponse<T>.self, from: data)
                if let jsonData = json.data {
                    success?(jsonData)
                } else if let _ = json.meta.errorMessage{
                    failure?(InstagramError.badRequest)
                } else {
                    failure?(InstagramError.unknownError)
                }
            } catch {
                failure?(InstagramError.dataParsingError)
            }
        }) { error in
            print(error)
            failure?(InstagramError.failureToDownloadData)
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








