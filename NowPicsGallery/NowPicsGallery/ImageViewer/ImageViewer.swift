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
    fileprivate let imageURL: URL
    fileprivate let imageGetter: ImageGetter
    
    init(imageGetter: ImageGetter, imageURL: URL) {
        self.imageURL = imageURL
        self.imageGetter = imageGetter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageScrollViewSetup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.

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
