//
//  MenuPageTemplate.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import UIKit
import SpriteKit

class MenuPageTemplate: SKNode {

    var pageNum:Int
    
    init(pageNum: Int){
        self.pageNum = pageNum
        super.init()
    }
    
    // Q1: What's up with this?, Why is it required?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
