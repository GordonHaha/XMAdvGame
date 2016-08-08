//
//  GameOverScene.swift
//  XMRun
//
//  Created by Gordon on 16/8/6.
//  Copyright © 2016年 Gordon. All rights reserved.
//

import UIKit
import SpriteKit

protocol GameOverSceneDelegate {
    func gameoverSceneOnReturnMenuClicked()
}


class GameOverScene: SKScene {
    
    var endTime: String?
    var gameOverDelegate: GameOverSceneDelegate!
    
    init(size: CGSize, time: CGFloat, delegate: GameOverSceneDelegate) {
        super.init(size: size)
        self.backgroundColor = SKColor.whiteColor()
        let titleLabel: SKLabelNode = SKLabelNode(fontNamed: "Yuppy SC")
        titleLabel.text = "啊！小明掉下去了！"
        titleLabel.fontSize = 37
        
        if time >= 60 && time < 120 {
            titleLabel.text = "哎哟不错哦！居然挺过了1分钟！"
            titleLabel.fontSize = 25
        } else if time >= 120 && time < 180 {
            titleLabel.text = "坚持了2分钟的你离胜利已经不远了！"
            titleLabel.fontSize = 22
        } else if time >= 180 && time < 240 {
            titleLabel.text = "居然过了三分钟！但你依然坚持不到四分钟的！"
            titleLabel.fontSize = 21
        } else if time >= 240 {
            titleLabel.text = "你是电！你是光！你是唯一的神话！"
            titleLabel.fontSize = 21
        }
        titleLabel.fontColor = SKColor.blackColor()
        titleLabel.position = CGPoint.init(x: self.size.width / 2, y: self.size.height / 2 + 160)
        self .addChild(titleLabel)
        
        let subtitleLabel: SKLabelNode = SKLabelNode(fontNamed: "Yuppy SC")
        subtitleLabel.text = String(format: "不可思议！你家小明竟然坚持了%0.1f秒", time)
        subtitleLabel.fontSize = 20
        subtitleLabel.fontColor = SKColor.blackColor()
        subtitleLabel.position = CGPoint.init(x: self.size.width / 2, y: self.size.height / 2 + 50)
        self.addChild(subtitleLabel)
        
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

        self.gameOverDelegate = delegate
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchLoaction: CGPoint = touch.locationInNode(self)
        let node: SKNode = self.nodeAtPoint(touchLoaction)
        
        if node.name == "restartGame" {
            let reveal: SKTransition = SKTransition.flipVerticalWithDuration(0.5)
            let gameScene: GameScene = GameScene(size: self.size)
            self.view!.presentScene(gameScene, transition: reveal)
        } else if node.name == "returnMenu" {
            self.gameOverDelegate.gameoverSceneOnReturnMenuClicked()
            self.removeAllActions()
        }
    }

}
