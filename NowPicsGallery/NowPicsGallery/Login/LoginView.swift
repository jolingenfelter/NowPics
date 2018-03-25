//
//  LoginView.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/25/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit
import WebKit

class LoginView: UIView {

    var progressView: UIProgressView
    var webView: WKWebView
    
    init(progressView: UIProgressView, webView: WKWebView) {
        self.webView = webView
        self.progressView = progressView
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressViewLayout()
        webViewLayout()
    }
    
    private func webViewLayout() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: self.leftAnchor),
            webView.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
    }
    
    private func progressViewLayout() {
        progressView.progress = 0.0
        progressView.tintColor = UIColor(red: 0.88, green: 0.19, blue: 0.42, alpha: 1.0)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: self.topAnchor),
            progressView.leftAnchor.constraint(equalTo: self.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }

}
