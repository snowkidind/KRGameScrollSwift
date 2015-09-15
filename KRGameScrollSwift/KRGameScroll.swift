//
//  KRGameScroll.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import UIKit
import SpriteKit

class KRGameScroll: SKNode {
    
    var pages: [MenuPageTemplate] = []
    
    func addPage(newPage: MenuPageTemplate){
        pages.append(newPage)
    }
    
    func enumPages(){
        
        for page in pages {
            page.printALine()
        }
    }
}
