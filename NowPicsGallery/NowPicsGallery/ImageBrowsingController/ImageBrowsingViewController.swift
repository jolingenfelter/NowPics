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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !instagramClient.isAuthenticated {
            let loginController = LoginViewController(instagramClient: instagramClient)
            let navigationController = UINavigationController(rootViewController: loginController)
            present(navigationController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
