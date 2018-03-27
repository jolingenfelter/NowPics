//
//  ImageViewer.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/27/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class ImageViewer: UIViewController {
    
    fileprivate let activityIndicator = UIActivityIndicatorView()
    fileprivate let imageScrollView = ImageScrollView()
    fileprivate let imageURL: URL
    fileprivate let imageGetter: ImageGetter
    fileprivate var downloadedImage: UIImage?
    
    init(imageGetter: ImageGetter, imageURL: URL) {
        self.imageURL = imageURL
        self.imageGetter = imageGetter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        imageScrollViewSetup()
        activityIndicatorSetup()
        prepareImage()

    }
    
    func imageScrollViewSetup() {
        view.addSubview(imageScrollView)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageScrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
    }
    
    func activityIndicatorSetup() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        activityIndicator.isHidden = true
    }
    
    func prepareImage() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        imageGetter.getImage(from: imageURL) { (result) in
            switch result {
            case .ok(let image):
                DispatchQueue.main.async {
                    self.downloadedImage = image
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.imageScrollView.displayImage(image)
                }
            case .error(let error):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    let localizedError = NSLocalizedString("Error", comment: "")
                    self.presentAlert(withTitle: localizedError, andMessage: error.localizedDescription)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
