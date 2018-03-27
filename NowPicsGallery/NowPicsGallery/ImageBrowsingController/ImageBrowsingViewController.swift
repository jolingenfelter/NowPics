//
//  ImageBrowsingViewController.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/25/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class ImageBrowsingViewController: UIViewController {
    
    fileprivate var collectionView: UICollectionView!
    fileprivate let activityIndicator = UIActivityIndicatorView()
    
    fileprivate var instagramMedia: [InstagramMedia]?
    fileprivate let instagramClient: InstagramClient
    fileprivate let imageGetter = ImageGetter()

    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let edgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    
    lazy var dataSource: ImageBrowsingDataSource = {
        return ImageBrowsingDataSource(collectionView: self.collectionView, instagramMedia: self.instagramMedia)
    }()
    
    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    init(instagramClient: InstagramClient) {
        self.instagramClient = instagramClient
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "NowPics Gallery"
        
        edgesForExtendedLayout = []
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.register(MediaViewCell.self, forCellWithReuseIdentifier: MediaViewCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        self.view = collectionView
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchMedia()
    }
    
    func fetchMedia() {
        
        view.addSubview(activityIndicator)
        activityIndicatorSetup()
        activityIndicator.startAnimating()
        
        instagramClient.fetchUserImages { [weak self] (result) in
            
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let media):
                strongSelf.instagramMedia = media
                strongSelf.collectionView.dataSource = self?.dataSource
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.activityIndicator.removeFromSuperview()
                
            case .failure(let error):
                if !strongSelf.instagramClient.isAuthenticated {
                    let loginController = LoginViewController(instagramClient: strongSelf.instagramClient)
                    let navigationController = UINavigationController(rootViewController: loginController)
                    strongSelf.present(navigationController, animated: true, completion: nil)
                    
                } else {
                    let localizedError = NSLocalizedString("Error", comment: "")
                    
                    guard let instagramError = error as? InstagramError else {
                        strongSelf.presentAlert(withTitle: localizedError, andMessage: error.localizedDescription)
                        return
                    }
                    
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.activityIndicator.removeFromSuperview()
                    
                    strongSelf.presentAlert(withTitle: localizedError, andMessage: instagramError.errorDescription)
                }
            }
        }
    }
    
    func activityIndicatorSetup() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - CollectionViewDelegate

extension ImageBrowsingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let instagramMedia = instagramMedia {
            let mediaItem = instagramMedia[indexPath.row]
            let imageURL = mediaItem.images.standardResolution.url
            
            imageGetter.getImage(from: imageURL, completion: { [weak self] (result) in
                switch result {
                case .ok(let image):
                    let imageViewer = ImageViewer(image: image)
                    let navigationController = UINavigationController(rootViewController: imageViewer)
                    self?.present(navigationController, animated: true, completion: nil)
                case .error(let error):
                    let localizedError = NSLocalizedString("Error", comment: "")
                    self?.presentAlert(withTitle: localizedError, andMessage: error.localizedDescription)
                }
            })
        }
    }
}

// MARK: - CollectionViewDelegateFlowLayout
extension ImageBrowsingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = edgeInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return edgeInsets.bottom
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return edgeInsets.left
    }
    
}








