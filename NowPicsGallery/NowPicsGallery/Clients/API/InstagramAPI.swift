//
//  InstagramAPI.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

struct InstagramAPI {
    
    private struct APIBaseURL {
        static var unauthorized = "https://api.instagram.com/oauth/authorize"
        static var authorized = "https://api.instagram.com/v1"
        
    }
    
    private var clientInformation: (clientID: String?, clientRedirectURI: String?)? {
        if let path = Bundle.main.path(forResource: "InstagramClient", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: String] {
            return (info["ClientID"], info["RedirectURI"])
        }
        return nil
    }
    
    // MARK: - Build URL's
    func buildAuthorizationURL(scopes: [InstagramScope]) -> URL? {
        guard var components = URLComponents(string: APIBaseURL.unauthorized)  else { return nil}
        
        guard let clientInformation = clientInformation, let clientID = clientInformation.clientID, let redirectURI = clientInformation.clientRedirectURI else { return nil }
        
        let scopeStrings = scopes.map { return $0.rawValue }
        
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: scopeStrings.joined(separator: "+"))
        ]
        
        guard let url = components.url else { return nil }
        return url
    }
    
    func buildRequest(endpoint: String, with accessToken: String?) -> URLRequest? {
        guard let url = URL(string: APIBaseURL.authorized + endpoint)?.appendParameters(["access_token" : accessToken ?? ""])else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
}
