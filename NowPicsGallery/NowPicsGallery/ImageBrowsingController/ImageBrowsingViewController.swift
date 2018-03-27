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
    let instagramClient: InstagramClient
    
    fileprivate let itemsPerRow: CGFloat = 3
    
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
            case .success(let media): print(media)
            case .failure(let error):
                if !self.instagramClient.isAuthenticated {
                    let loginController = LoginViewController(instagramClient: self.instagramClient)
                    let navigationController = UINavigationController(rootViewController: loginController)
                    self.present(navigationController, animated: true, completion: nil)
                } else {
                    print(error)
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








