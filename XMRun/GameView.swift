//
//  GameView.swift
//  XMRun
//
//  Created by Gordon on 16/8/6.
//  Copyright © 2016年 Gordon. All rights reserved.
//

import UIKit
import SpriteKit

class GameView: SKView {
    
    private var gameScene: GameScene?
    private var menuView: MenuView?
    
    init(frame: CGRect, menuView:MenuView) {
        super.init(frame: frame)
        self.backgroundColor = SKColor.white
        self.menuView = menuView
        
        self.gameScene = GameScene.init(size: self.bounds.size, presentView: self, menuView: self.menuView!)
        self.presentScene(self.gameScene)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startGame() {
        self.gameScene!.startGame()
    }
}
