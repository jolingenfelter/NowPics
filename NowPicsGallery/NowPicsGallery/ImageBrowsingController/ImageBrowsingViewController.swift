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

    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !instagramClient.isAuthenticated {
            let loginController = LoginViewController(instagramClient: instagramClient)
            let navigationController = UINavigationController(rootViewController: loginController)
            present(navigationController, animated: true, completion: nil)
        }
        
        fetchImages()
    }
    
    func fetchImages() {
        instagramClient.fetchFromInstagram(endpoint: "/media/shortcode/D?", parameters: nil, success: { (media: InstagramMedia?) in
            print(media)
        }) { (error) in
            print(error)
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








