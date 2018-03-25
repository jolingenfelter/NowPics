//
//  ViewController.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    var instagramClient = InstagramClient.shared
    var progressView: UIProgressView!
    var webView: WKWebView!
    var webViewProgressObservation: NSKeyValueObservation!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        edgesForExtendedLayout = []
        progressView = UIProgressView(progressViewStyle: .bar)
        webView = webViewSetup()
        
        view = LoginView(progressView: progressView, webView: webView)
        
        do {
            let request = try instagramClient.authorizationRequest(scopes: [.all])
            webView.load(request)
        } catch InstagramError.invalidRequest(let message){
            presentAlert(withTitle: "Error", andMessage: message)
        } catch let error {
            presentAlert(withTitle: "Error", andMessage: error.localizedDescription)
        }
        
    }
    
    func webViewSetup() -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = .nonPersistent()
        
        let webView = WKWebView(frame: CGRect.zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        
        webViewProgressObservation = webView.observe(\.estimatedProgress, changeHandler: progressViewChangeHandler)
        
        return webView
    }
    
    private func progressViewChangeHandler<Value>(webView: WKWebView, change: NSKeyValueObservedChange<Value>) {
        progressView.alpha = 1.0
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        
        if webView.estimatedProgress >= 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.progressView.alpha = 0.0
            }, completion: { (_ finished) in
                self.progressView.progress = 0
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        progressView.removeFromSuperview()
        webViewProgressObservation.invalidate()
    }
}

// MARK: - WebKitNavigationDelegate

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let urlString = navigationAction.request.url?.absoluteString else { return }
        guard let range = urlString.range(of: "#access_token=") else {
            decisionHandler(.allow)
            return
        }
        
        decisionHandler(.cancel)
        let accessToken = String(urlString[range.upperBound...])
        print(accessToken)
        instagramClient.storeAccessToken(accessToken)
    }
}














