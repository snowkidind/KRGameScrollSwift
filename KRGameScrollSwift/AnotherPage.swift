//
//  AnotherPage.swift
//  KRGameScrollSwift
//
//  Created by Keny Ruyter on 9/15/15.
//  Copyright © 2015 Art Of Communication, Inc. All rights reserved.
//

import UIKit
import SpriteKit

class AnotherPage: SKNode, ScrollPageProtocol {
    
    override init(){
        super.init()
        self.name = "page"
    }

    func printMonsterMash(){
        print("was a graveYard smash")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
