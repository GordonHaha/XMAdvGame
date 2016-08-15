//
//  GameOverScene.swift
//  XMRun
//
//  Created by Gordon on 16/8/6.
//  Copyright © 2016年 Gordon. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var presentView: SKView?
    var menuView: MenuView?
    var gameScene: GameScene?
    
    var titleLabel: SKLabelNode?
    var subtitleLabel: SKLabelNode?
    
    init(size: CGSize, presentView:SKView, menuView:MenuView) {
        super.init(size: size)
        self.backgroundColor = SKColor.whiteColor()
        self.titleLabel = SKLabelNode(fontNamed: "Yuppy SC")
        self.titleLabel!.text = "啊！小明掉下去了！"
        self.titleLabel!.fontSize = 37
        self.titleLabel!.fontColor = SKColor.blackColor()
        self.titleLabel!.position = CGPoint.init(x: self.size.width / 2, y: self.size.height / 2 + 160)
        self.addChild(self.titleLabel!)
        
        self.subtitleLabel = SKLabelNode(fontNamed: "Yuppy SC")
        self.subtitleLabel!.fontSize = 20
        self.subtitleLabel!.fontColor = SKColor.blackColor()
        self.subtitleLabel!.position = CGPoint.init(x: self.size.width / 2, y: self.size.height / 2 + 50)
        self.addChild(self.subtitleLabel!)
        
        let startNode: SKSpriteNode = SKSpriteNode.init(color: SKColor.clearColor(), size: CGSize(width: 210, height: 60))
        startNode.texture = SKTexture(imageNamed: "restartGame")
        startNode.position = CGPoint.init(x: self.size.width / 2, y: self.size.height / 2 - 50)
        startNode.name = "restartGame"
        self.addChild(startNode)
        
        let returnNode: SKSpriteNode = SKSpriteNode.init(color: SKColor.clearColor(), size: CGSize(width: 210, height: 60))
        returnNode.texture = SKTexture(imageNamed: "returnMenu")
        returnNode.position = CGPoint.init(x: self.size.width / 2, y: startNode.frame.origin.y - 60)
        returnNode.name = "returnMenu"
        self.addChild(returnNode)
        
        self.menuView = menuView
        self.presentView = presentView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func refreshTime(time: CGFloat) {
        if time >= 60 && time < 120 {
            self.titleLabel!.text = "哎哟不错哦！居然挺过了1分钟！"
            self.titleLabel!.fontSize = 25
        } else if time >= 120 && time < 180 {
            self.titleLabel!.text = "坚持了2分钟的你离胜利已经不远了！"
            self.titleLabel!.fontSize = 22
        } else if time >= 180 && time < 240 {
            self.titleLabel!.text = "居然过了三分钟！但你依然坚持不到四分钟的！"
            self.titleLabel!.fontSize = 21
        } else if time >= 240 {
            self.titleLabel!.text = "你是电！你是光！你是唯一的神话！"
            self.titleLabel!.fontSize = 21
        }
        
        self.subtitleLabel!.text = String(format: "不可思议！你家小明竟然坚持了%0.1f秒", time)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchLoaction: CGPoint = touch.locationInNode(self)
        let node: SKNode = self.nodeAtPoint(touchLoaction)
        
        if node.name == "restartGame" {
            let reveal: SKTransition = SKTransition.flipVerticalWithDuration(0.5)
            self.gameScene = nil
            self.gameScene = GameScene.init(size: self.size, presentView: self.presentView!, menuView: self.menuView!)
            dispatch_async(dispatch_get_main_queue(), {
                self.presentView!.presentScene(self.gameScene!, transition: reveal)
            })
            self.gameScene!.startGame()
        } else if node.name == "returnMenu" {
            dispatch_async(dispatch_get_main_queue(), {
                UIView.transitionFromView(self.presentView!, toView: self.menuView!, duration: 0.5, options: .TransitionFlipFromRight, completion: nil)
            })
        }
    }
}
