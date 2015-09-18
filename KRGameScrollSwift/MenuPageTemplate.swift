//
//  MenuPageTemplate.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import UIKit
import SpriteKit

class MenuPageTemplate: SKNode, ScrollPageProtocol {

    var pageNum:Int
    
    init(pageNum: Int){
        self.pageNum = pageNum
        super.init()
        drawButton()
    }
    
    func drawButton() {
        
         let sprite = SKSpriteNode(imageNamed:"Spaceship")
        
         sprite.xScale = 0.5
         sprite.yScale = 0.5
         sprite.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        
         let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
         sprite.runAction(SKAction.repeatActionForever(action))
         
         self.addChild(sprite)
    }
    
    func printMonsterMash(){
        print("\(pageNum) was a Monster mash...")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
