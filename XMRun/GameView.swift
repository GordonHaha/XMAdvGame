//
//  GameView.swift
//  XMRun
//
//  Created by Gordon on 16/8/6.
//  Copyright © 2016年 Gordon. All rights reserved.
//

import UIKit
import SpriteKit

class GameView: UIView {

    var skView: SKView?
    var gameScene: GameScene?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.skView = SKView(frame: self.bounds)
        self.skView!.backgroundColor = SKColor.whiteColor()
        
        self.gameScene = GameScene.init(size: self.bounds.size, presentView: self.skView!)
        self.skView!.presentScene(self.gameScene)
        
        self.addSubview(self.skView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func transmitReturnMenuDelegate(delegate: ReturnMenuDelegate) {
        self.gameScene!.returnMenuDelegate = delegate
    }
}
