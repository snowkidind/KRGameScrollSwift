//
//  KRGameScroll.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/14/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import UIKit
import SpriteKit

class KRGameScroll: SKNode {
    
    var pages: [SKNode] = []
  
    func addPage(newPage: SKNode){
        pages.append(newPage)
    }
    
    func enumPages(){
        
        for page:SKNode in pages  {
            
            let ud = page.userData!.objectForKey("class")!
            print(ud)
            
            // i want to iterate these objects and cast them to their respective classes as 
            // defined in userData; Because this will be for more than one application, i won't
            // specify the class names of the pages. My only guess is to store the class name in
            // userData like this, but I am not sure how I would cast the page iterator as a
            // variable (probably because I can't)
            
            // in objective c I can iterate the array and cast each one as a prototype class 
            // e.g. but apparently i can't do this in swift:
           
//            for (MenuPageTemplate *page in self.pages){
//                
//                // Asserting position here will position the contents of the page
//                CGPoint point;
//                if (isVertical) point = CGPointMake(0, acc);
//                else point = CGPointMake(acc, 0);
//                page.position = point;
//                page.identifier = i;
//                [self addChild:page];
//                ...
//            }

        }
    }
}
