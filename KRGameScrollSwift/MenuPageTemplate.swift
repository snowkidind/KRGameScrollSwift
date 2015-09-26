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

    var nodes: [SKSpriteNode] = []
    
    // Assuming you have set scene.scaleMode = .ResizeFill in your view
    // controller, the following should give you the appropriate
    // coordinate space for the device being viewed:
    var width:CGFloat = UIScreen.mainScreen().bounds.width
    var height:CGFloat = UIScreen.mainScreen().bounds.height
    
    let actions:Actions = Actions()
    
    var _page:Int
    
    init(page:Int){
        
        _page = page
        
        super.init()
        self.name = String(page)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        // begin page specific content here
        // the class assumes you are using the entire screen

        // may want to determine font size based on phone / tablet
        let fontSize:CGFloat = 24
        
        // Draw heading based on what page we are assigned (Architecture 1)
        let btnTex = SKTexture.init(imageNamed: "goTo.png")
        drawButtonArrayWithTexture(btnTex)
        
        var pageTitle:String
        
        switch (page) {
            
            case 1: pageTitle = "Rad Game 1"; break;
            case 2: pageTitle = "Rad Game 2"; break;
            case 3: pageTitle = "Rad Game 3"; break;
            case 4: pageTitle = "Rad Game 4"; break;
            default:pageTitle = "Rad Game"; break;
        }

        let pageLabel = SKLabelNode(fontNamed:"Thonburi-Bold")
        pageLabel.fontSize = fontSize;
        pageLabel.text = pageTitle;
        pageLabel.fontColor = SKColor.blueColor()
        pageLabel.position = CGPointMake(width/10 * 5,height/10 * 2)
        pageLabel.name = "label"
        self.addChild(pageLabel)
      
    }
    
    // Just to keep things simple we assume each page has 9 buttons.
    // This is a good reason to switch to architecture 2
    func drawButtonArrayWithTexture(texture:SKTexture) {
    
        // init and draw nodes, add reference to array
        let border = width / 10 * 3 // 30 percent outside border: edge to center of outside tile
        let totalBorder = border * 2
        let useableArea = width - totalBorder
        let columns = 3
        let spans = columns - 1
        let span = useableArea / CGFloat(spans)
        var startPoint = border
    
        // Row 1
        for var i = 0; i < columns; i++ {
    
            let menuBtn = SKSpriteNode(texture:texture)
            menuBtn.position = CGPointMake(startPoint, height/10 * 7.5);
            self.addChild(menuBtn)
            menuBtn.name = "\(i + 1)"
            nodes.append(menuBtn)
            startPoint += span;
        }
    
        startPoint = border;
    
        // Row 2
        for var i = 0; i < columns; i++ {
    
            let menuBtn = SKSpriteNode(texture:texture)
            menuBtn.position = CGPointMake(startPoint, height/10 * 6);
            self.addChild(menuBtn)
            menuBtn.name = "\(i + 1 + 3)"
            nodes.append(menuBtn)
            startPoint += span;
        }
    
        startPoint = border;
    
        // Row 3
        for var i = 0; i < columns; i++ {
            
            let menuBtn = SKSpriteNode(texture:texture)
            menuBtn.position = CGPointMake(startPoint, height/10 * 4.5);
            self.addChild(menuBtn)
            menuBtn.name = "\(i + 1 + 6)"
            nodes.append(menuBtn)
            startPoint += span;
        }
    }

    func redrawPage() {
        
        // handle rotation change
        // init and draw nodes, add reference to array
        let border = width / 10 * 3 // 30 percent outside border: edge to center of outside tile
        let totalBorder = border * 2
        let useableArea = width - totalBorder
        let columns = 3
        let spans = columns - 1
        let span = useableArea / CGFloat(spans)
        var startPoint = border
        
        // Row 1
        for var i = 0; i < columns; i++ {
            
            let menuBtn = self.childNodeWithName("\(i + 1)")
            menuBtn!.position = CGPointMake(startPoint, height/10 * 7.5)
            startPoint += span
        }
        
        startPoint = border
        
        // Row 2
        for var i = 0; i < columns; i++ {
            
            let menuBtn = self.childNodeWithName("\(i + 1 + 3)")
            menuBtn!.position = CGPointMake(startPoint, height/10 * 6)
            startPoint += span
        }
        
        startPoint = border
        
        // Row 3
        for var i = 0; i < columns; i++ {
            
            let menuBtn = self.childNodeWithName("\(i + 1 + 6)")
            menuBtn!.position = CGPointMake(startPoint, height/10 * 4.5)
            startPoint += span
            
        }
        
        self.childNodeWithName("label")?.position = CGPointMake(width/10 * 5,height/10 * 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // use touchesBegan for selection Animations and sound responsiveness
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
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
                    actions.scaleAction(selectedNode!)
                }
            }
        }
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
                    
                    print("Start Scene: \(_page) at Level: \(selectedNode!.name!)")

                    // load new scene here...
                    let tranny = SKTransition.crossFadeWithDuration(1)
                    let nextScene = GameLevel()
                    nextScene.scaleMode = SKSceneScaleMode.ResizeFill
                    self.scene?.view?.presentScene(nextScene, transition: tranny)
                    
                    // notify the scene to cleanup / remove observers etc
                    NSNotificationCenter.defaultCenter().postNotificationName("sceneWillChange", object:nil)
                    
                }
            }
        }
    }
    
    // This is required. Use it to start
    // an animation or run a sound when a page is scrolled upon.
    func screenChanged(){
        
    }
    
    // This is required. Use it to remove observers, deallocate objects etc
    func cleanUpForSceneChange(){
        self.removeAllActions()
        self.removeFromParent()
    }
    
    func deviceOrientationChanged()
    {
        if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation))
        {
            width = UIScreen.mainScreen().bounds.width
            height = UIScreen.mainScreen().bounds.height
            redrawPage()
        }
        
        if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation))
        {
            width = UIScreen.mainScreen().bounds.width
            height = UIScreen.mainScreen().bounds.height
            redrawPage()
        }
    }
}
