//
//  ImageBrowsingDataSource.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/26/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class ImageBrowsingDataSource: NSObject {
    
    var instagramMediaItems: [InstagramMedia]
    let collectionView: UICollectionView
    
    init(collectionView: UICollectionView, instagramMediaItems: [InstagramMedia]) {
        self.collectionView = collectionView
        self.instagramMediaItems = instagramMediaItems

    }
}

extension ImageBrowsingDataSource: UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instagramMediaItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.cellForItem(at: indexPath) as! MediaViewCell
        
        return cell
    }
}
