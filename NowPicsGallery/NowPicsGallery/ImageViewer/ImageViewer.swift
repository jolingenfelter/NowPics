//
//  ImageViewer.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/27/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import UIKit

class ImageViewer: UIViewController {
    
    fileprivate let imageScrollView = ImageScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imageScrollViewSetup()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
