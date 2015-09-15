//
//  GameScene.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright (c) 2015 Art Of Communication, Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {

        let scroll = KRGameScroll()
        
        let menuPage1 = MenuPageTemplate(pageNum: 1)
        menuPage1.userData = ["class" : "MenuPageTemplate"]
        scroll.addPage(menuPage1)
        
        let menuPage2 = AnotherPage(pageNum: 2)
        menuPage2.userData = ["class" : "AnotherPage"]
        scroll.addPage(menuPage2)
        
        let menuPage3 = MenuPageTemplate(pageNum: 3)
        menuPage3.userData = ["class" : "MenuPageTemplate"]
        scroll.addPage(menuPage3)
        
        let menuPage4 = MenuPageTemplate(pageNum: 4)
        menuPage4.userData = ["class" : "MenuPageTemplate"]
        scroll.addPage(menuPage4)
        
        
        scroll.enumPages()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
//        for touch in touches {
//            
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func loadExternalPage(){
        print("Load External Page")
    }
    
    func registerObservers() {
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "loadExternalPage:",
            name: UIDeviceBatteryLevelDidChangeNotification,
            object: nil)
    }
    
    func removeObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "loadExternalPage", object: nil)
    }
}
