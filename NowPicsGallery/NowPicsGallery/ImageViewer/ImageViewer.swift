//
//  ImageViewer.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/27/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit
import Nuke

class ImageViewer: UIViewController {
    
    fileprivate let activityIndicator = UIActivityIndicatorView()
    fileprivate let imageScrollView = ImageScrollView()
    fileprivate let imageURL: URL
    fileprivate var downloadedImage: UIImage?
    fileprivate var saveOrShareButton: UIBarButtonItem?
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        navBarSetup()
        prepareImage()
        imageScrollViewSetup()
        activityIndicatorSetup()
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
        activityIndicator.color = .lightGray
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
        
        Manager.shared.loadImage(with: imageURL) { (result) in
            switch result {
            case .success(let image):
                self.imageScrollView.displayImage(image)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.downloadedImage = image
            case .failure(let error):
                let localizedError = NSLocalizedString("Error", comment: "")
                self.presentAlert(withTitle: localizedError, andMessage: error.localizedDescription)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - Navigation

extension ImageViewer {
    
    func navBarSetup() {
        saveOrShareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePressed))
        let localizedClose = NSLocalizedString("Close", comment: "")
        let closeButton = UIBarButtonItem(title: localizedClose, style: .done, target: self, action: #selector(closePressed))
        
        navigationItem.rightBarButtonItem = closeButton
        navigationItem.leftBarButtonItem = saveOrShareButton!
    }
    
    @objc func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sharePressed() {
        guard let image = downloadedImage else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = saveOrShareButton!
        
        self.present(activityController, animated: true, completion: nil)
    }
    
}
