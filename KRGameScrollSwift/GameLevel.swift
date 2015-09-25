//
//  GameLevel.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/25/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import SpriteKit

class GameLevel: SKScene {
    
    var nodes:[SKSpriteNode] = []
    
    let width:CGFloat = UIScreen.mainScreen().bounds.width
    let height:CGFloat = UIScreen.mainScreen().bounds.height

    override func didMoveToView(view: SKView) {
        
        userInteractionEnabled = true
        
        let btnTex = SKTexture.init(imageNamed: "goTo.png")
        let menuBtn = SKSpriteNode(texture:btnTex)
        menuBtn.position = CGPointMake(width/2, height/2);
        self.addChild(menuBtn)
        menuBtn.name = "1"
        nodes.append(menuBtn)
        
        
        // switch the scroller mode from horizontal to vertical and vice-versa
        if !NSUserDefaults.standardUserDefaults().boolForKey("verticalScroll") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "verticalScroll")
        }
        else {
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "verticalScroll")
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var selectedNode:SKNode?
        
        for touch in touches {
            
            let location:CGPoint = (touch as UITouch).locationInNode(self)
            for node in self.nodesAtPoint(location){
                if (node.name != nil) {
                    selectedNode = node
                }
            }
        }
        
        if selectedNode != nil {
            for node:SKSpriteNode in nodes {
                if node == selectedNode {

                    sceneWillChange()
                    
                    let tranny = SKTransition.crossFadeWithDuration(1)
                    let nextScene = GameScene()
                    nextScene.scaleMode = SKSceneScaleMode.ResizeFill
                    self.scene?.view?.presentScene(nextScene, transition: tranny)
                    
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func sceneWillChange(){
        
    }
}