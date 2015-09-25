//
//  KRGameScroll.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import UIKit
import SpriteKit

// using objC protocol because touches notifications should only be implemented as needed.
@objc protocol ScrollPageProtocol {

    optional func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    optional func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    optional func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    func screenChanged()
    func cleanUpForSceneChange()
}

class KRGameScroll: SKNode {
    
    let showNavBoxes:Bool = true
    let minimumSlideLength:CGFloat = 5.0 // keep these CGFloats
    let minimumDragThreshold:CGFloat = 20.0 // keep these CGFloats
    let kScrollLayerStateIdle = 0
    let kScrollLayerStateSliding = 1
    let kShortDragDuration:Double = 0.10
    let kLongDragDuration:Double = 0.25
    
    var width:CGFloat = UIScreen.mainScreen().bounds.width
    var height:CGFloat = UIScreen.mainScreen().bounds.height
    var zeroPoint:CGFloat = 0
    
    var pages: [SKNode] = []
    var currentPage:Int = 0
    var isVertical:Bool
    
    var state:Int = 0 // Idle
    var lastPosition:CGFloat = 0.0
    var startSwipe:CGFloat = 0.0
    
    init(isVertical: Bool){
        
        self.isVertical = isVertical
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPage(newPage: SKNode){
        pages.append(newPage)
    }
    
    /*
    - (void) moveNavBoxes {
    
    // Need to know how many chapters exist; draw one less than that
    // Need to know which chapter is selected
    
    int tenthOfWidth = _scene.size.width  / 10; // 1/10th of the width
    int boxSpacing = tenthOfWidth * .5; // 1 = 10% of screen width
    int smallBoxes = (int)[self.pages count] - 1; // How many boxes exist
    
    // negative offset:
    // 1. amount of total boxes, big and small
    // 2. multiply by width of the box for total box footprint
    // 3. divide by negative 2 to get the negative offset from center
    // 4. add back half the width of one space for object offset adjustment
    int negativeOffset = (((smallBoxes + 1) * boxSpacing)/-2) + boxSpacing/2;
    
    // set the accumulator to the width of screen plus the negative offset
    int accSpacing;
    if (isVertical) accSpacing = _scene.size.height/2 - negativeOffset;
    else accSpacing = _scene.size.width/2 + negativeOffset;
    
    // create an array that contains the drawrering locations of X
    NSMutableArray *locations = [NSMutableArray arrayWithObjects:nil];
    
    // iterate and add locations to NSMA
    for (int i = 0; i < smallBoxes +1; i++){
    
    NSNumber *xCoord = [NSNumber numberWithInt:accSpacing];
    [locations addObject:xCoord];
    
    if (isVertical)accSpacing -= boxSpacing;
    else accSpacing += boxSpacing;
    }
    
    int x = 0;
    // the amount of locations is the total number of boxes (-1)
    int smBoxes = (int)[locations count];
    
    // so now we are looping through locations and applying x to the graphic, and setting an animation
    for (NSNumber *xCoord in locations){
    
    // BUT it is necessary to see which page is actually selected
    BOOL selected = NO;
    
    // which x + 2 does: x (0) page 1(unused) (page2 - bangkok)
    if (x + 1 == currentScreen){
    selected = YES;
    }
    if (!selected){
    
    // small boxes' tags start from 26. add box to location and subtract one
    SKSpriteNode *small = (SKSpriteNode*)[self childNodeWithName:[NSString stringWithFormat:@"%i", 24 + smBoxes]];
    SKAction *moveAction;
    if (isVertical) moveAction = [SKAction moveTo:CGPointMake(_scene.size.width / 10 * 9.4, [xCoord intValue]) duration:.25];
    else moveAction = [SKAction moveTo:CGPointMake([xCoord intValue],_scene.size.height / 10 * .6) duration:.25];
    [small runAction:moveAction];
    smBoxes -=1;
    }
    else {
    
    // large box, since there is only one; it's tag is 25
    SKSpriteNode *large = (SKSpriteNode*)[self childNodeWithName:@"25"];
    SKAction *moveAction;
    if (isVertical) moveAction = [SKAction moveTo:CGPointMake(_scene.size.width / 10 * 9.4, [xCoord intValue]) duration:.25];
    else moveAction = [SKAction moveTo:CGPointMake([xCoord intValue],_scene.size.height / 10 * .6) duration:.25];
    [large runAction:moveAction];
    }
    x += 1;
    }
    }
    
    - (void) drawNavBoxes {
    
    // id how many small boxes we need
    // need to subtract for the large box
    int smallBoxes = (int)[self.pages count] - 1;
    
    // going to put all boxes on a layer
    NSMutableArray *navBoxes = [NSMutableArray arrayWithObjects: nil];
    
    // create a large box, place offstage, downstage center
    SKTexture *largeBoxTex = [SKTexture textureWithImageNamed:@"largeNavBox.png"];
    SKSpriteNode *largeNavBox = [SKSpriteNode spriteNodeWithTexture:largeBoxTex];
    if (isVertical) largeNavBox.position =
    CGPointMake(_scene.size.width + largeNavBox.size.width, _scene.size.height / 2 );
    else largeNavBox.position = CGPointMake((_scene.size.width  / 10) * 5 , -_scene.size.height);
    largeNavBox.name = @"25";
    [navBoxes addObject:largeNavBox];
    [self addChild:largeNavBox];
    
    for (int i = 0; i < smallBoxes; i++){
    
    // create a small box, place offstage, downstage center
    SKTexture *smallBoxTex = [SKTexture textureWithImageNamed:@"smallNavBox.png"];
    SKSpriteNode *smallNavBox = [SKSpriteNode spriteNodeWithTexture:smallBoxTex];
    if (isVertical) smallNavBox.position = CGPointMake(_scene.size.width + smallNavBox.size.width, _scene.size.height / 2);
    else smallNavBox.position = CGPointMake((_scene.size.width  / 10) * 5 , -_scene.size.height);
    smallNavBox.name = [NSString stringWithFormat:@"%i", (26 + i)];
    [navBoxes addObject:smallNavBox];
    [self addChild:smallNavBox];
    }
    
    // and move into place...
    [self moveNavBoxes];
    }
    
    func drawNavBoxes(){
        
    }
    */
    
    func drawPagesAtIndex(index: Int){
        
        var acc:CGFloat = 0.0;
        
        // here we will draw the pages into the scene
        for obj in pages {
            
            // Asserting position here will position the contents of the page
            let point:CGPoint
            if isVertical {
                point = CGPointMake(zeroPoint, acc)
            }
            else {
                point = CGPointMake(acc, zeroPoint)
            }
            
            obj.position = point
            
            addChild(obj) // even pages (2 and 4) are responding to touches but do not appear in the display...
            
            if isVertical {
                acc -= height
            }
            else {
                acc += width // position next page to the right by acc.
            }
        }
        
        currentPage = index;
        
        if (showNavBoxes){
            // drawNavBoxes()
        }
    }
    
    func notifyMenuPagesCurrentScreenChanged() {
        
        // notify proper page of touch event
        for (i, pageNode) in pages.enumerate(){
            if let page = pageNode as? ScrollPageProtocol {
                if i+1 == currentPage {
                    page.screenChanged()
                }
            }
        }
    }
    
    func  currentScreenWillChange(){
        
        let pauseForDuration = SKAction.waitForDuration(kLongDragDuration)
        let notifyBlock = SKAction.runBlock {
            self.notifyMenuPagesCurrentScreenChanged()
        }
        let sequenceArray = [pauseForDuration, notifyBlock]
        let sequence = SKAction.sequence(sequenceArray)
        runAction(sequence)
    }
    
    func  setDefaultPage(page:Int){
        
        NSUserDefaults.standardUserDefaults().setInteger(page, forKey: "ScrollPage")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadExternalPage(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("loadExternalPage", object:nil)

    }
    
    func cleanUpForSceneChange() {
        
        // call this on all child pages.
        for pageNode in pages {
            if let page = pageNode as? ScrollPageProtocol {
                page.cleanUpForSceneChange()
            }
        }
        
        // remove the references contained in the _pages array
        pages.removeAll()

        // may need to remove actions
        // self.removeAllActions()

    }

    func moveToPage(page: Int) {

        let pageWidth:CGFloat
        
        if isVertical {
            pageWidth = height
        } else {
            pageWidth = width
        }
        
        var initialValuesArray: [CGFloat] = []
        var initialValue = pageWidth
        
        for var i = 0; i < pages.count; i++ {
            
            initialValuesArray.append(initialValue)
            initialValue += pageWidth;
        }
        
        var rtz = false
        var illegalMove = false
        
        if (page > pages.count || page == 0){
            illegalMove = true
        }
        else {
            
            let difference = CGFloat((currentPage - page) * -1)
            
            // if user initiated the transition use constants for drag duration
            // else calculate based on the travel distance:
            var dragDuration = CGFloat(kLongDragDuration)
            
            if (difference > 1 || difference < 1){
                
                // further thinking on this would scale the speed according to the amount of layers
                // to animate but 1:1 sounds appropro for now...
                dragDuration = difference * CGFloat(kLongDragDuration)
                
                if dragDuration < 0 { dragDuration *= -1 }
            }
            
            // Here we determine which direction the user is going and animate the selected page visible
            if page > currentPage {
                
                //going right
                for (i, page) in pages.enumerate(){

                    let initialItemValue = initialValuesArray[i]
                    let move:SKAction
                    
                    if (isVertical){
                        
                        let newPosition:CGFloat = (CGFloat(currentPage + 1) * pageWidth - initialItemValue) + pageWidth * (difference - 1)
                        move = SKAction.moveTo(CGPointMake(zeroPoint, newPosition), duration: Double(dragDuration))
                    }
                        
                    else {
                        var newPosition:CGFloat = (CGFloat(currentPage + 1) * pageWidth - initialItemValue) + pageWidth * (difference - 1)
                        newPosition *= -1
                        move = SKAction.moveTo(CGPointMake(newPosition, zeroPoint), duration:Double(dragDuration))
                    }

                    page.runAction(move)
                }
                
                currentPage = page
                currentScreenWillChange()
                setDefaultPage(page)
                
            }
                
            else if page < currentPage {
                
                // going left
                for (i, page) in pages.enumerate(){
                    
                    let initialItemValue = initialValuesArray[i]
                    let move:SKAction
                    
                    if isVertical{
                        
                        let newPosition = (CGFloat(currentPage) - 1) * pageWidth - initialItemValue + (pageWidth * (-1 * (difference + 1.0)))
                        move = SKAction.moveToY(newPosition, duration:Double(dragDuration))
                    }
                    else {
                        var newPosition = ( CGFloat(currentPage) - 1 )
                            * pageWidth - initialItemValue -
                            ( pageWidth * ((difference + 1) * -1) )
                        
                        newPosition *= -1
                        move = SKAction.moveToX(newPosition, duration:Double(dragDuration))
                    }
                    
                    page.runAction(move)
                }
                
                currentPage = page
                currentScreenWillChange()
                setDefaultPage(page)
            }
            else {
                rtz = true
            }
        }
        
        if (rtz || illegalMove){
            
            // reset page to current page
            
            for (i, page) in pages.enumerate(){

                let initialItemValue = initialValuesArray[i]
                let move:SKAction
                var newPosition:CGFloat
                
                if (isVertical){
                    
                    newPosition = -(initialItemValue - CGFloat(currentPage) * pageWidth);
                    move = SKAction.moveToY(newPosition, duration:Double(kShortDragDuration))
                }
                else {
                    newPosition = (initialItemValue - CGFloat(currentPage) * pageWidth);
                    move = SKAction.moveToX(newPosition, duration:Double(kShortDragDuration))
                }
                
                page.runAction(move)
            }
            
            if (page > pages.count){
                loadExternalPage()
            }
        }
        else {
            if (showNavBoxes){
                // moveNavBoxes()
            }
        }
    }

    func initialMoveToPage(page:Int) {
    
        if page == 1 {
            currentScreenWillChange()
        }
        moveToPage(page)
    }
    
    // pass touches down to page classes, this way the scroller knows touches happened,
    // and notifies the currently visible page of a touch when it happens.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        for touch in touches {
            let location:CGPoint = (touch as UITouch).locationInNode(self)
            
            if (isVertical) {
                lastPosition = location.y
                startSwipe = location.y
            }
            else {
                lastPosition = location.x
                startSwipe = location.x
            }
        }
        
        state = kScrollLayerStateIdle;

        
        // notify proper page of touch event
        for (i, pageNode) in pages.enumerate(){
            if let page = pageNode as? ScrollPageProtocol {
                if i+1 == currentPage {
                    page.touchesBegan!(touches, withEvent: event)
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            
            let location:CGPoint = (touch as UITouch).locationInNode(self)
            let moveDistance:CGFloat
            
            if isVertical {
                moveDistance = location.y - startSwipe
            } else {
                moveDistance = location.x - startSwipe
            }
            
            // If finger is dragged for more distance then minimum - start sliding and cancel pressed buttons.
            if (state != kScrollLayerStateSliding) && (moveDistance >= minimumSlideLength || moveDistance >= -minimumSlideLength ) {
                state = kScrollLayerStateSliding;
            }
            
            // drag ourselves along with user finger
            if (state == kScrollLayerStateSliding) {
                
                // Move individual pages to their relative positions.
                for var i = 0; i < pages.count; i++ {
                    
                    var moveToPosition:CGPoint
                    var newPosition:CGFloat
                    
                    if (isVertical){
                        newPosition = pages[i].position.y + (location.y - lastPosition )
                        moveToPosition = CGPointMake(zeroPoint,newPosition)
                    }
                    else {
                        newPosition = pages[i].position.x + (location.x - lastPosition )
                        moveToPosition = CGPointMake(newPosition,zeroPoint)
                    }
                    pages[i].position = moveToPosition;
                }
            }

            if isVertical {
                lastPosition = location.y
            } else {
                lastPosition = location.x;
            }
        }
        
        // notify proper page of touch event
        for (i, pageNode) in pages.enumerate(){
            if let page = pageNode as? ScrollPageProtocol {
                if i+1 == currentPage {
                    page.touchesMoved!(touches, withEvent: event)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

        for touch in touches {
            
            let location:CGPoint = (touch as UITouch).locationInNode(self)
        
            // Testing the drag length. offsetLoc is drag length, compared to minimum
            var offsetLoc:CGFloat = 0;
        
            if isVertical {
                offsetLoc = location.y - startSwipe
            } else {
                offsetLoc = (location.x - startSwipe)
            }
        
            // Logic to determine roughly what the user did
            if ( offsetLoc < -minimumDragThreshold) {
                if isVertical {
                    moveToPage(currentPage - 1)
                } else {
                    moveToPage(currentPage + 1)
                }
            }
            else if ( offsetLoc > minimumDragThreshold) {
                if isVertical {
                    moveToPage(currentPage+1)
                } else {
                    moveToPage(currentPage-1)
                }
            }
            else if ((currentPage-1) == 0 ) {
            
                if ( offsetLoc > minimumDragThreshold) {
                } else {
                    moveToPage(currentPage)
                }
            }
            else {
                moveToPage(currentPage)
            }
        
            state = kScrollLayerStateIdle;
        }
        
        // notify proper page of touch event
        for (i, pageNode) in pages.enumerate(){
            if let page = pageNode as? ScrollPageProtocol {
                if i+1 == currentPage {
                    page.touchesEnded!(touches, withEvent: event)
                }
            }
        }
    }
}
