//
//  APIClient.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

public let JLNetworkingErrorDomain = "com.jolingenfelter.NowPicsGallery.NetworkingError"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20
public let UnhandledResponse = 30
public let AbnormalError: Int = 40

typealias taskCompletion = (Data?, HTTPURLResponse?, NSError?) -> Void


protocol APIClient {
    var session: URLSession { get }
}

extension APIClient {
    private func jsonTaskWithRequest(_ request: URLRequest, completion: @escaping taskCompletion) -> URLSessionTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPURLResponse = response as? HTTPURLResponse else {
                let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("MissingHTTPResponse", comment: "")]
                let error = NSError(domain: JLNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                completion(nil, nil, error)
                return
            }
            
            if let data = data {
                switch HTTPURLResponse.statusCode {
                case 200:
                    completion(data, HTTPURLResponse, nil)
                default:
                    let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Received HTTPURLREsponse: \(HTTPURLResponse.statusCode)", comment: "")]
                    let error = NSError(domain: JLNetworkingErrorDomain, code: UnhandledResponse, userInfo: userInfo)
                    completion(nil, HTTPURLResponse, error)
                }
            } else {
                if let error = error {
                    completion(nil, HTTPURLResponse, error as NSError?)
                }
            }
        }
        
        return task
    }
    
    func fetch<T>(_ request: URLRequest, parse: @escaping (Data) -> T?, completion: @escaping (APIResult<T>) -> Void) {
        let task = jsonTaskWithRequest(request) { (data, _ , error) in
            DispatchQueue.global(qos: .utility).async {
                guard let data = data else {
                    if let error = error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Abnormal Error Handeling JSON", comment: "")]
                        let error = NSError(domain: JLNetworkingErrorDomain, code: AbnormalError, userInfo: userInfo)
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                    
                    return
                }
                
                if let value = parse(data) {
                    DispatchQueue.main.async {
                        completion(.success(value))
                    }
                }
            }
        }
        
        task.resume()
    }
}
