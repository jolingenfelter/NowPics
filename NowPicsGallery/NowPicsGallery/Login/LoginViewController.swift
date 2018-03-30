//
//  ViewController.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit
import WebKit
import Reachability

class LoginViewController: UIViewController {
    
    typealias SuccessHandler = (_ accesToken: String) -> Void
    typealias FailureHandler = (_ error: InstagramError) -> Void
    
    var progressView: UIProgressView!
    var webView: WKWebView!
    var webViewProgressObservation: NSKeyValueObservation!
    
    var success: SuccessHandler?
    var failure: FailureHandler?
    
    let instagramClient: InstagramClient
    let reachability = Reachability()!
    
    // MARK: - Initializers
    init(instagramClient: InstagramClient) {
        self.instagramClient = instagramClient
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        edgesForExtendedLayout = []
        progressView = UIProgressView(progressViewStyle: .bar)
        webView = webViewSetup()
        
        view = LoginView(progressView: progressView, webView: webView)
        request()
        
        // Handlers
        success = { accessToken in
            self.instagramClient.storeAccessToken(accessToken)
            self.dismiss(animated: true, completion: nil)
        }
        
        failure = { error in
            self.presentAlert(withTitle: "Error", andMessage: error.errorDescription)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reachability Setup
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: nil)
        do {
            try reachability.startNotifier()
        } catch {
            let localizedError = NSLocalizedString("Error", comment: "")
            let localizedDescription = NSLocalizedString("Could not start reachability notifier", comment: "")
            self.presentAlert(withTitle: localizedError, andMessage: localizedDescription)
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
    
    func request() {
        do {
            let request = try instagramClient.authorizationRequest(scopes: [.all])
            webView.load(request)
        } catch InstagramError.invalidRequest{
            presentAlert(withTitle: "Error", andMessage: InstagramError.invalidRequest.errorDescription)
        } catch let error {
            presentAlert(withTitle: "Error", andMessage: error.localizedDescription)
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .none:
            let localizedError = NSLocalizedString("Error", comment: "")
            let localizedDescription = NSLocalizedString("Check your internet connection", comment: "")
            presentAlert(withTitle: localizedError, andMessage: localizedDescription)
        case .wifi, .cellular:
            request()
        }
    }
    
    deinit {
        progressView.removeFromSuperview()
        webViewProgressObservation.invalidate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
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
        success?(accessToken)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let httpResponse = navigationResponse.response as? HTTPURLResponse else {
            decisionHandler(.allow)
            return
        }
        
        switch httpResponse.statusCode {
        case 400:
            decisionHandler(.cancel)
            self.failure?(InstagramError.badRequest)
        default:
            decisionHandler(.allow)
        }
    }
}
