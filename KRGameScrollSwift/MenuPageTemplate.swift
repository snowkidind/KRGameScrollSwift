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

    let nodes:NSMutableArray = []
    
    // Assuming you have set scene.scaleMode = .ResizeFill in your view
    // controller, the following should give you the appropriate
    // coordinate space for the device being viewed:
    let width:CGFloat = UIScreen.mainScreen().bounds.width
    let height:CGFloat = UIScreen.mainScreen().bounds.height
    var _page:Int
    
    init(page:Int){
        
        _page = page
        
        super.init()
        self.name = "page"
        
        
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
            nodes.addObject(menuBtn)
            startPoint += span;
        }
    
        startPoint = border;
    
        // Row 2
        for var i = 0; i < columns; i++ {
    
            let menuBtn = SKSpriteNode(texture:texture)
            menuBtn.position = CGPointMake(startPoint, height/10 * 6);
            self.addChild(menuBtn)
            menuBtn.name = "\(i + 1 + 3)"
            nodes.addObject(menuBtn)
            startPoint += span;
        }
    
        startPoint = border;
    
        // Row 3
        for var i = 0; i < columns; i++ {
            
            let menuBtn = SKSpriteNode(texture:texture)
            menuBtn.position = CGPointMake(startPoint, height/10 * 4.5);
            self.addChild(menuBtn)
            menuBtn.name = "\(i + 1 + 6)"
            nodes.addObject(menuBtn)
            startPoint += span;
        }
    }
    
    func printMonsterMash(){
        print("was a Monster mash...")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        print("touchesBegan \(_page)")
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // print("touchesMooved")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touchesEnded")
    }
    
}
