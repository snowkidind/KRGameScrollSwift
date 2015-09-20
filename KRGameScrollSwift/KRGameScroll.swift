//
//  KRGameScroll.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import UIKit
import SpriteKit

@objc protocol ScrollPageProtocol {
    
    var pageNum:Int { get set }
    func printMonsterMash()
    optional func optionalFunc()
}

class KRGameScroll: SKNode {
    
    var pages: [SKNode] = []
    
    init(orientation: Bool){
        super.init()
        self.userInteractionEnabled = true
        print("initScroll:\(orientation)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPage(newPage: SKNode){
        pages.append(newPage)
    }
    
    func drawPagesAtIndex(index: Int){
        
        print("drawPagesAtIndex:\(index)")
        
        // here we will draw the pages into the scene
        for obj in pages {
            
            if let commonObj = obj as? ScrollPageProtocol {
                
                // do the do's
                print("Page \(commonObj.pageNum)")
                commonObj.printMonsterMash()
                
                var acc = 0;
                
                var i = 1;
    
//               // Asserting position here will position the contents of the page
//               CGPoint point;
//               if (isVertical) point = CGPointMake(0, acc);
//               else point = CGPointMake(acc, 0);
//               page.position = point;
//               page.identifier = i;
//               [self addChild:page];
//               
//               if (isVertical) acc -= _scene.size.height;
//               else acc += _scene.size.width; // position next page to the right by acc.
//               
//               i += 1;
//
//                currentScreen = index;
   
                
            } else {
                print("Be sure to implement the ScrollPageProtocol when building your class, e.g.:")
                print("class YourClassName: SKNode, ScrollPageProtocol { ")
                
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("TouchesBegan in krgamescroll")
    }
}
