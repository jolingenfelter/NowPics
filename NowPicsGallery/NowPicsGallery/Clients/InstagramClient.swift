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
    
    // MARK: - Authorization
    public func authorizationRequest(scopes: [InstagramScope]) throws -> URLRequest {
        guard let request = API.buildAuthorizationURLRequest(scopes: scopes) else {
            throw InstagramError.invalidRequest(message: "Error building web request")
        }
        return request
    }
    
    // MARK: - Fetch Media
    func fetchFromInstagram<T: Decodable>(withScopes: [InstagramScope], endpoint: String, parameters: [String: Any]?, completion: @escaping (APIResult<T>) -> Void) {
        guard let accessToken = retrieveAccessToken() else {
            completion(.failure(InstagramError.missingAccessToken))
            return
        }
        
        guard let request = API.buildRequest(endpoint: endpoint, withToken: accessToken, parameters: parameters) else {
            completion(.failure(InstagramError.invalidRequest(message: "Invalid request")))
            return
        }
        
        fetchAPIData(withRequest: request, success: { (data) in
            do {
                let json = try JSONDecoder().decode(InstagramResponse<T>.self, from: data)
                if let jsonData = json.data {
                    completion(.success(jsonData))
                } else if let message = json.meta.errorMessage{
                    completion(.failure(InstagramError.invalidRequest(message: message)))
                } else {
                    completion(.failure(InstagramError.unknownError(message: "An unknown error occured")))
                }
            } catch let error {
                completion(.failure(InstagramError.dataParsingError(message: error.localizedDescription)))
            }
        }) { (error) in
            completion(.failure(InstagramError.failureToDownloadData(message: error.localizedDescription)))
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








