//
//  KRGameScroll.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import UIKit
import SpriteKit

protocol ScrollPageProtocol {
    
    var pageNum:Int { get set }
    func printMonsterMash()
}

class KRGameScroll: SKNode {
    
    var pages: [SKNode] = []
  
    func addPage(newPage: SKNode){
        pages.append(newPage)
    }
    
    func enumPages(){
        
        for obj in pages {
            if let commonObj = obj as? ScrollPageProtocol {
                print("Page \(commonObj.pageNum)")
                commonObj.printMonsterMash()
            } else {
                print("Not a CommonStuff, couldn't do thing")
            }
        }
    }
}
