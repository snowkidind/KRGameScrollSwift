//
//  GameScene.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright (c) 2015 Art Of Communication, Inc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let scroll = KRGameScroll(isVertical: NSUserDefaults.standardUserDefaults().boolForKey("verticalScroll"))
    
    override func didMoveToView(view: SKView) {

        // here we make menu pages and add them to the stack. the order of pages 
        // is defined by the order in which they are added to the scroll object
        
        let menuPage1 = AnotherPage(page: 1)
        scroll.addPage(menuPage1)
        
        let menuPage2 = MenuPageTemplate(page: 2)
        scroll.addPage(menuPage2)
        
        let menuPage3 = MenuPageTemplate(page: 3)
        scroll.addPage(menuPage3)
        
        let menuPage4 = AnotherPage(page: 4)
        scroll.addPage(menuPage4)
        
        scroll.drawPagesAtIndex(1)
        
        self.addChild(scroll)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // forward the touch to the scroller
        scroll.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        scroll.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        scroll.touchesEnded(touches, withEvent: event)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func loadExternalPage(){
        print("Load External Page")
    }
}
