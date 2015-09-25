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
        
        let menuPage1 = MenuPageTemplate(page: 1)
        scroll.addPage(menuPage1)
        
        let menuPage2 = AnotherPage(page: 2)
        scroll.addPage(menuPage2)
        
        let menuPage3 = MenuPageTemplate(page: 3)
        scroll.addPage(menuPage3)
        
        let menuPage4 = AnotherPage(page: 4)
        scroll.addPage(menuPage4)
        
        // You can set the width of the scroller, and the zero point as defined:
        // width: the width of the scroll swath
        // height: the height of the scroll swath in vertical orientation
        // zeroPoint: the offset for the lower right corner.
        // You can also choose to not set these and it 
        // defaults to UIScreen.mainScreen().bounds
        // in that case be sure to set scene.scaleMode = .ResizeFill in the view controller.
        // scroll.width = 100
        // scroll.height = 100
        // scroll.zeroPoint = 0
        
        scroll.drawPagesAtIndex(1)
        
        self.addChild(scroll)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // forward the three touch events to the scroller
        scroll.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // forward the three touch events to the scroller
        scroll.touchesMoved(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // forward the three touch events to the scroller
        scroll.touchesEnded(touches, withEvent: event)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func loadExternalPage(){
        print("Load External Page")
    }
}
