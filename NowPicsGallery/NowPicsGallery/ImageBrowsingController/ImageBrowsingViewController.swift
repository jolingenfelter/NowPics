//
//  ImageBrowsingViewController.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/25/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class ImageBrowsingViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var instagramMedia: [InstagramMedia]?
    let instagramClient: InstagramClient
    
    fileprivate let itemsPerRow: CGFloat = 3
    
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
        instagramClient.fetchUserImages { (result) in
            switch result {
            case .success(let media):
                self.instagramMedia = media
                self.collectionView.dataSource = self.dataSource

            case .failure(let error):
                if !self.instagramClient.isAuthenticated {
                    let loginController = LoginViewController(instagramClient: self.instagramClient)
                    let navigationController = UINavigationController(rootViewController: loginController)
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    let localizedError = NSLocalizedString("Error", comment: "")
                    
                    guard let instagramError = error as? InstagramError else {
                        self.presentAlert(withTitle: localizedError, andMessage: error.localizedDescription)
                        return
                    }
                    self.presentAlert(withTitle: localizedError, andMessage: instagramError.errorDescription)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - CollectionViewDelegateFlowLayout
extension ImageBrowsingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = itemsPerRow * 2
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
    
}








