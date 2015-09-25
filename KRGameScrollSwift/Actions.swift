//
//  Actions.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/25/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

// The purpose of this file is to keep constantly used actions in one place in order to be used across multiple classes.

import Foundation
import SpriteKit

class Actions: SKNode {
    
    // This is to give a little popUp action when needed
    func scaleAction(node:SKNode){
        
        let scaleD:CGFloat = 0.95;
        let rtnScale:CGFloat = 1;
        let scaleU:CGFloat =  1.05;
        let nodeSelectDuration = 0.15
        
        var scaleAct:[SKAction] = []
        scaleAct.append(SKAction.scaleTo(scaleD, duration: nodeSelectDuration))
        scaleAct.append(SKAction.scaleTo(scaleU, duration: nodeSelectDuration))
        scaleAct.append(SKAction.scaleTo(rtnScale, duration: nodeSelectDuration))
        node.runAction(SKAction.sequence(scaleAct))
    }
}