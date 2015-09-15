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

    var pageNum:Int = 0
    
    func pageId(pageNumber: Int){
        pageNum = pageNumber
    }
    
    func printALine(){
        print("GergdeBurgedeMPT \(pageNum)")
    }
}
