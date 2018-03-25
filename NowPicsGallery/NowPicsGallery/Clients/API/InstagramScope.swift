//
//  InstagramScope.swift
//  NowPicsGallery
//
//  Created by Joanna LINGENFELTER on 3/24/18.
//  Copyright © 2018 Joanna LINGENFELTER. All rights reserved.
//

import Foundation

enum InstagramScope: String {
    case basic
    case publicContent = "public_content"
    case followerList = "follower_list"
    case comments
    case relationships
    case likes
    case all = "basic+public_content+follower_list+comments+relationships+likes"
}
