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
public let UnhandledResponse = 30
public let AbnormalError: Int = 40

typealias successHandler = (Data) -> Void
typealias failureHandler = (Error) -> Void

protocol APIClient {
    var session: URLSession { get }
}

extension APIClient {
    
    func fetchAPIData(withRequest request: URLRequest, success: successHandler?, failure: failureHandler?) {
        DispatchQueue.global(qos: .utility).async {
            let task = self.session.dataTask(with: request) { (data, response, error) in
                guard let HTTPURLResponse = response as? HTTPURLResponse else {
                    let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("MissingHTTPResponse", comment: "")]
                    let error = NSError(domain: JLNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
                    DispatchQueue.main.async {
                        failure?(error)
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        switch HTTPURLResponse.statusCode {
                        case 200:
                            success?(data)
                        default:
                            let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString("Received HTTPURLREsponse: \(HTTPURLResponse.statusCode)", comment: "")]
                            let error = NSError(domain: JLNetworkingErrorDomain, code: UnhandledResponse, userInfo: userInfo)
                                failure?(error)
                        }
                    } else {
                        if let error = error {
                            failure?(error)
                        } else {
                            let userInfo = [NSLocalizedDescriptionKey: "An abnormal error occured"]
                            let error = NSError(domain: JLNetworkingErrorDomain, code: AbnormalError, userInfo: userInfo)
                            failure?(error)
                        }
                    }
                }
                
            }
            task.resume()
        }

    }
}
