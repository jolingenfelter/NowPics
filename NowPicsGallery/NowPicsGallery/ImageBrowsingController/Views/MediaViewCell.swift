//
//  MediaViewCell.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/25/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit
import Nuke

class MediaViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(MediaViewCell.self)"
    let imageView = UIImageView()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewSetup()
    }
    
    func imageViewSetup() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
    
    }
    
    func configureCellwithImage(atURL: URL) {
        self.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFit
        Manager.shared.loadImage(with: atURL, into: imageView)
    }
}
