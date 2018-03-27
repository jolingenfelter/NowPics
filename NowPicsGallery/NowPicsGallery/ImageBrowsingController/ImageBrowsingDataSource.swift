//
//  ImageBrowsingDataSource.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/26/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class ImageBrowsingDataSource: NSObject {
    
    var instagramMedia: [InstagramMedia]?
    let collectionView: UICollectionView
    
    init(collectionView: UICollectionView, instagramMedia: [InstagramMedia]?) {
        self.collectionView = collectionView
        self.instagramMedia = instagramMedia

    }
}

extension ImageBrowsingDataSource: UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let instagramMedia = instagramMedia {
            return instagramMedia.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaViewCell.reuseIdentifier, for: indexPath) as! MediaViewCell
        
        if let instagramMedia = instagramMedia {
            let mediaItem = instagramMedia[indexPath.row]

        }
        
        cell.imageView.backgroundColor = .blue
        
        return cell
    }
}
