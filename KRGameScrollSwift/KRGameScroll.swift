//
//  KRGameScroll.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import UIKit
import SpriteKit

//MARK: Scroll Page Protocol

// using objC protocol because touches notifications should only be implemented as needed.
@objc protocol ScrollPageProtocol {

    optional func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    optional func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    optional func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    func screenChanged()
    func cleanUpForSceneChange()
}

class KRGameScroll: SKNode {

// MARK: Properties
    
    // config properties
    // Turns Navigation Boxes on or off true:false
    var showNavBoxes:Bool = true
    
    // This is the length a user must move their finger in order to 
    // move the scroller graphic at all.
    var minimumSlideLength:CGFloat = 5.0 // keep these CGFloats
    
    // the threshold a user must move their finger in order to trigger 
    // a moving to another page.
    var minimumDragThreshold:CGFloat = 20.0 // keep these CGFloats

    // shortDragDuration is the time it takes for the scroller to return to a
    // normal state after an “Illegal” move. An illegal move is considered: the
    // user scrolled, but did not scroll past the threshold for when to go to
    // the next page; also if the user scrolled to either end of the scroll
    // menu and there were no more pages to display.
    var shortDragDuration:Double = 0.10
    
    // LongDragDuration is the time it takes to scroll from the point where
    // the user lets go to the final resting place in the next displayed page
    var longDragDuration:Double = 0.25
    
    // width and height is the width of the scroll node. Defaults to screen 
    // bounds but can be set to any size
    // typically the bottom left corner of the scroller node but behaves as 
    // a vertical offset recommended: 0
    var width:CGFloat = UIScreen.mainScreen().bounds.width
    var height:CGFloat = UIScreen.mainScreen().bounds.height
    var zeroPoint:CGFloat = 0

// MARK: Instance Variables
    
    // used to determine drag length
    private let scrollLayerStateIdle = 0
    private let scrollLayerStateSliding = 1
    private var state:Int = 0
    private var lastPosition:CGFloat = 0.0
    private var startSwipe:CGFloat = 0.0
    
    // this is the array that stores the user classes.
    private var pages: [SKNode] = []
    
    // this stores the page which is currently being used. 
    // note this is also stored into UserDefaults
    private var currentPage:Int = 0
    
    // determines if the scroller should display Vertically or Horizontally
    private var isVertical:Bool

// MARK: init
    
    init(isVertical: Bool){
        
        self.isVertical = isVertical
        super.init()

        // register for rotation notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceOrientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // adds a page to the scroller node, call repetitively to load in your custom classes
    func addPage(newPage: SKNode){
        pages.append(newPage)
        addChild(newPage)
    }
    
    // once pages are added, this positions the pages and adds the objects to the scroller node
    // this and the next function could be consolidated.
    func drawPages(){
        
        // accumulator variable
        var acc:CGFloat = 0.0;
        
        // draw the pages into the scene
        for obj in pages {
            
            // Asserting position here will position the contents of the page
            let point:CGPoint
            if isVertical {
                point = CGPointMake(zeroPoint, acc)
            }
            else {
                point = CGPointMake(acc, zeroPoint)
            }
            
            // Set position
            obj.position = point
            
            if isVertical {
                acc -= height
            }
            else {
                acc += width // position next page to the right by acc.
            }
        }
        
        currentPage = 1;
        
        if (showNavBoxes){
            
            // creates navBoxes
            drawNavBoxes()
        }
    }
    
    // will redraw pages during a rotation instance, or if you want to add a 
    // page subsequently after calling drawPages. Note, Navboxes are not supported 
    // when adding pages, disable them
    func redrawPages() {
        
        // accumulator variable
        var acc:CGFloat = 0.0;
        
        // redraw the pages for rotation change
        for obj in pages {
            
            // Asserting position here will position the contents of the page
            let point:CGPoint
            if isVertical {
                point = CGPointMake(zeroPoint, acc)
            }
            else {
                point = CGPointMake(acc, zeroPoint)
            }
            
            // Set position
            obj.position = point
            
            if isVertical {
                acc -= height
            }
            else {
                acc += width // position next page to the right by acc.
            }
        }

        // Simple redraw does not animate...
        moveToPage(currentPage, animates:false)
        
        // another difference here is that we are not creating new navBoxes
        if (showNavBoxes){
            moveNavBoxes()
        }
    }

// MARK: Scroller Logic

    // allows for a simple call to moveToPage
    func moveToPage(page: Int) {
        moveToPage(page, animates:true)
    }
    
    // moves scroller to selected Page. Animates either rolls to next page 
    // from previous page or not. Meat and Potatoes of the KRGameScroll
    // This is similar in algorithm to Cocos 2d v2's scroller class.
    func moveToPage(page: Int, animates:Bool) {

        // setup
        let pageWidth:CGFloat
        if isVertical {
            pageWidth = height
        } else {
            pageWidth = width
        }
        
        // building an array of where the individual pages should be at position zero
        var initialValuesArray: [CGFloat] = []
        var initialValue = pageWidth
        for var i = 0; i < pages.count; i++ {
            initialValuesArray.append(initialValue)
            initialValue += pageWidth;
        }
        
        // routing
        var rtz = false
        var illegalMove = false
        
        if (page > pages.count || page == 0){
            illegalMove = true
        }
        else {
            
            // the difference between current page and where we are going.
            let difference = CGFloat((currentPage - page) * -1)
            
            // if user initiated the transition use constants for drag duration
            // else calculate based on the travel distance:
            var dragDuration = CGFloat(longDragDuration)
            
            if (difference > 1 || difference < 1){

                // further thinking on this would scale the speed according to the amount of layers
                // to animate but 1:1 sounds appropro for now...
                dragDuration = difference * CGFloat(longDragDuration)
                if dragDuration < 0 { dragDuration *= -1 }
            }
            
            // Here we determine which direction the user is going and animate the selected page visible
            if page > currentPage {
                
                //going right
                for (i, page) in pages.enumerate(){

                    let initialItemValue = initialValuesArray[i]
                    let move:SKAction
                    
                    if (isVertical){
                        
                        // this is a busy equation to put on one line, but less temp variables
                        // determines position of pages and then moves into position.
                        
                        //  Side A
                        // initialItemValue contains the original placement of the page from zero
                        // here we determine the target amount the page will slide to the right 
                        // from it's current position
                        // (currentPage + 1) * pageWidth - initialItemValue

                        //  Side B
                        // difference is normally 1.0 when scrolling forward. backward, -1 only zero
                        // when not scrolling, but that's considered an illegal move
                        // usually this will cancel itself out unless you are at page 2 going to page 4 where the difference is greater than 1
                        // pagewidth * difference - 1
                        
                        let newPosition:CGFloat = (CGFloat(currentPage + 1) * pageWidth - initialItemValue) + pageWidth * (difference - 1)
                        
                        if animates {
                            move = SKAction.moveTo(CGPointMake(zeroPoint, newPosition), duration: Double(dragDuration))
                        } else {
                            move = SKAction.moveTo(CGPointMake(zeroPoint, newPosition), duration: 0)
                        }
                    }
                        
                    else {
                        var newPosition:CGFloat = (CGFloat(currentPage + 1) * pageWidth - initialItemValue) + pageWidth * (difference - 1)
                        newPosition *= -1
                        if animates {
                            move = SKAction.moveTo(CGPointMake(newPosition, zeroPoint), duration:Double(dragDuration))
                        } else {
                            move = SKAction.moveTo(CGPointMake(newPosition, zeroPoint), duration:0)
                        }
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
                        if animates {
                            move = SKAction.moveToY(newPosition, duration:Double(dragDuration))
                        } else {
                            move = SKAction.moveToY(newPosition, duration:0)
                        }
                    }
                    else {
                        var newPosition = ( CGFloat(currentPage) - 1 )
                            * pageWidth - initialItemValue -
                            ( pageWidth * ((difference + 1) * -1) )
                        
                        newPosition *= -1
                        if animates {
                            move = SKAction.moveToX(newPosition, duration:Double(dragDuration))
                        } else {
                            move = SKAction.moveToX(newPosition, duration:0)
                        }
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
                    if animates {
                        move = SKAction.moveToY(newPosition, duration:Double(shortDragDuration))
                    } else {
                        move = SKAction.moveToY(newPosition, duration:0)
                    }
                }
                else {
                    newPosition = (initialItemValue - CGFloat(currentPage) * pageWidth);
                    if animates {
                        move = SKAction.moveToX(newPosition, duration:Double(shortDragDuration))
                    } else {
                        move = SKAction.moveToX(newPosition, duration:0)
                    }
                }
                
                page.runAction(move)
            }
            
            if (page > pages.count){
                loadExternalPage()
            }
        }
        else {
            if (showNavBoxes){
                moveNavBoxes()
            }
        }
    }
    
// MARK: user interaction
    
    // touchesBegan handles establishing a start position to 
    // determine swipe gesture length. Then it notifies the selected page 
    // that a touch event occured.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        // determine location of touch and assign starter var's
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
        
        // ensure that a new touch starts at idle state
        state = scrollLayerStateIdle;

        
        // notify proper page of touch event
        for (i, pageNode) in pages.enumerate(){
            if let page = pageNode as? ScrollPageProtocol {
                if i+1 == currentPage {
                    page.touchesBegan!(touches, withEvent: event)
                }
            }
        }
    }
    
    // touchesMoved moves pages along with swipe gesture movement. Then it notifies 
    // the selected page that a touch event occured.
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
            if (state != scrollLayerStateSliding) && (moveDistance >= minimumSlideLength || moveDistance >= -minimumSlideLength ) {
                state = scrollLayerStateSliding;
            }
            
            // drag ourselves along with user finger
            if (state == scrollLayerStateSliding) {
                
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
    
    // touchesMoved calculates swipe length and determines when the threshold
    // for changing the page has been reached. Then it notifies the selected page
    // that a touch event occured.
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
        
            state = scrollLayerStateIdle;
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
    
// MARK: nav boxes
    
    // moveNavBoxes repositions navboxes so that large navbox relates to the 
    // selected page.
    func moveNavBoxes(){
        
        let tenthOfWidth:CGFloat = width  / 10 // 1/10th of the width
        let boxSpacing:CGFloat = tenthOfWidth * 0.5 // 1 = 10% of screen width
        let smallBoxesMath:CGFloat = CGFloat(pages.count - 1)
        
        // negative offset:
        // 1. amount of total boxes, big and small
        // 2. multiply by width of the box for total box footprint
        // 3. divide by negative 2 to get the negative offset from center
        // 4. add back half the width of one space for object offset adjustment
        let negativeOffset = (((smallBoxesMath + 1) * boxSpacing) / -2) + boxSpacing/2
        
        // set the accumulator to the width of screen plus the negative offset
        var accSpacing:CGFloat
        
        if isVertical { accSpacing = height/2 - negativeOffset }
        else { accSpacing = width/2 + negativeOffset }
        
        // create an array that contains the drawrering locations of X
        var locations:[CGFloat] = []
        
        // iterate and add locations to NSMA
        for var i = 0; i < pages.count; i++ {
            
            let xCoord:CGFloat = accSpacing
            locations.append(xCoord)
            
            if isVertical { accSpacing -= boxSpacing }
            else { accSpacing += boxSpacing }
        }
        
        // the amount of locations is the total number of boxes (-1)
        var smBoxes = locations.count
        
        // so now we are looping through locations and applying x to the graphic, and setting an animation
        for (x, xCoord) in locations.enumerate() {
            
            // BUT it is necessary to see which page is actually selected
            var selected = false
            
            if (x + 1 == currentPage){
                selected = true;
            }
            
            if (!selected){
                
                // small boxes' tags start from 26. add box to location and subtract one
                let small = self.childNodeWithName("\(24 + smBoxes)")
                let moveAction:SKAction
                if isVertical {
                    moveAction = SKAction.moveTo(CGPointMake(width/10 * 9.4, xCoord), duration: 0.25)
                }
                else {
                    moveAction = SKAction.moveTo(CGPointMake(xCoord, height/10 * 0.6), duration: 0.25)
                }
                small!.runAction(moveAction)
                smBoxes -= 1
            }
            else {
                // large box, since there is only one; it's tag is 25
                let large = self.childNodeWithName("25")
                let moveAction:SKAction
                if isVertical {
                    moveAction = SKAction.moveTo(CGPointMake(width/10 * 9.4, xCoord), duration: 0.25)
                }
                else {
                    moveAction = SKAction.moveTo(CGPointMake(xCoord, height/10 * 0.6), duration: 0.25)
                }
                large!.runAction(moveAction)
            }
        }
    }

    // drawNavBoxes: draws navboxes offscreen. only call at init 
    // future code should support adding a page wherein a new navbox is added or 
    // existing navboxes are destroyed and then this is reinitialized.
    func drawNavBoxes() {
        
        // id how many small boxes we need
        // need to subtract for the large box
        let smallBoxes = pages.count - 1
        
        // going to put all boxes on a layer
        var navBoxes: [SKSpriteNode] = []
        
        // create a large box, place offstage, downstage center
        
        let largeBoxTex = SKTexture.init(imageNamed: "largeNavBox.png")
        let largeNavBox = SKSpriteNode(texture:largeBoxTex)
        if isVertical {
            largeNavBox.position = CGPointMake(width + largeNavBox.size.width, height/2)
        }
        else {
            largeNavBox.position = CGPointMake((width / 10 * 5), -largeNavBox.size.height)
        }
        
        largeNavBox.name = "25"
        navBoxes.append(largeNavBox)
        self.addChild(largeNavBox)
        
        for var i = 0; i < smallBoxes; i++ {
            
            // create a small box, place offstage, downstage center
            let smallBoxTex = SKTexture.init(imageNamed: "smallNavBox.png")
            let smallNavBox = SKSpriteNode(texture:smallBoxTex)
            if isVertical {
                smallNavBox.position = CGPointMake(width + smallNavBox.size.width, height/2)
            }
            else {
                smallNavBox.position = CGPointMake((width / 10 * 5), -largeNavBox.size.height)
            }
            smallNavBox.name = "\(26 + i)"
            navBoxes.append(smallNavBox)
            self.addChild(smallNavBox)
            
        }
        
        // and move into place...
        moveNavBoxes()
    }
    
// MARK: Utility
    
    // setting default page allows the app to remember the previously selected page upon startup.
    func  setDefaultPage(page:Int){
        
        NSUserDefaults.standardUserDefaults().setInteger(page, forKey: "ScrollPage")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // post a notification so that an external scene can be loaded when the user scrolls all the way to the end.
    func loadExternalPage(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("loadExternalPage", object:nil)
        
    }
    
    // Used to trigger an animation or run a sound when a page is scrolled upon.
    func notifyMenuPagesCurrentScreenChanged() {
        
        for (i, pageNode) in pages.enumerate(){
            if let page = pageNode as? ScrollPageProtocol {
                if i+1 == currentPage {
                    page.screenChanged()
                }
            }
        }
    }
    
    // handle maintenance tasks related to the changing of a screen
    func  currentScreenWillChange(){
        
        let pauseForDuration = SKAction.waitForDuration(longDragDuration)
        let notifyBlock = SKAction.runBlock {
            
            // this could be refactored as an anonymous function
            self.notifyMenuPagesCurrentScreenChanged()
        }
        let sequenceArray = [pauseForDuration, notifyBlock]
        let sequence = SKAction.sequence(sequenceArray)
        runAction(sequence)
    }
    
    // handle device rotation event
    func deviceOrientationChanged()
    {
        width = UIScreen.mainScreen().bounds.width
        height = UIScreen.mainScreen().bounds.height
        redrawPages()
    }
    
    // handle cleanup when scene changes.
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
}
