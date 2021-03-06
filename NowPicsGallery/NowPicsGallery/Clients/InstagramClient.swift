//
//  InstagramClient.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

final class InstagramClient: APIClient {
    // MARK: - Properties
    
    static let shared = InstagramClient()
    
    internal let session: URLSession
    private let API: InstagramAPI
   
    private init() {
        session = URLSession(configuration: .default)
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
    private func fetchFromInstagram<T: Decodable>(endpoint: String, parameters: [String: Any]?, success: ((_ data: T) -> Void)?, failure: ((Error) -> Void)?) {
        guard let accessToken = KeychainController.retrieveAccessToken() else {
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
            } catch let error {
                print(error)
                failure?(InstagramError.dataParsingError)
            }
        }) { _ in
            failure?(InstagramError.failureToDownloadData)
        }
    
    }
    
    func fetchUserImages(completion: @escaping (APIResult<[InstagramMedia]>) -> Void) {
        fetchFromInstagram(endpoint: "users/self/media/recent/?", parameters: nil, success: { (media: [InstagramMedia]) in
            completion(.success(media))
        }) { error in
            completion(.failure(error))
        }
    }
}








