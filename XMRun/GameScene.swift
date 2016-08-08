//
//  GameScene.swift
//  XMRun
//
//  Created by Gordon on 16/8/6.
//  Copyright © 2016年 Gordon. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

let kRUN_PLAYER = "runPlayer"

let kPlayerCategaory: __uint32_t = 0x1 << 0
let kObjectCategaory: __uint32_t = 0x1 << 1
let kGroundCategaory: __uint32_t = 0x1 << 2
let kStageCategaory: __uint32_t = 0x1 << 3

protocol ReturnMenuDelegate {
    func returnMenu()
}

class GameScene: SKScene, SKPhysicsContactDelegate, GameOverSceneDelegate {
    
    var presentView: SKView?
    
    var player: SKSpriteNode?
    var ground: SKSpriteNode?
    var timeLabel: SKLabelNode?
    
    var lastSpawnTimeInterval: NSTimeInterval?
    var lastUpdateTimeInterval: NSTimeInterval?
    
    var timer: dispatch_source_t?
    var timeCount: CGFloat?
    
    var playerRunFrames: NSArray?
    var isJumping: Bool?
    
    var audioPlayer: AVAudioPlayer?
    
    var returnMenuDelegate: ReturnMenuDelegate?
    
    init(size: CGSize, presentView:SKView) {
        super.init(size: size)
        self.backgroundColor = SKColor.whiteColor()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        self.physicsWorld.contactDelegate = self
        self.presentView = presentView
        self.lastUpdateTimeInterval = 0
        self.lastSpawnTimeInterval = 0
        self.createPlayer()
        self.initGround()
        self.initStage()
        self.createCountDownLabel()
        self.createTimeLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /**
     创建开场倒计时
     */
    func createCountDownLabel() {
        
        let countLabel = SKLabelNode(fontNamed: "Yuppy SC")
        countLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 110)
        countLabel.text = "3"
        countLabel.fontSize = 50
        countLabel.fontColor = SKColor.blackColor()
        self.addChild(countLabel)
        
        let act1 = SKAction.scaleTo(1.2, duration: 1)
        let act2 = SKAction.scaleTo(1.3, duration: 1)
        let act3 = SKAction.scaleTo(1.4, duration: 1)
        let act4 = SKAction.scaleTo(1.5, duration: 1)
        
        countLabel.runAction(act1) {
            countLabel.text = "2"
            countLabel.runAction(act2, completion: {
                countLabel.text = "1"
                countLabel.runAction(act3, completion: {
                    countLabel.text = "小明快跑！"
                    
                    //倒计时结束开始游戏计时
                    self.startTiming()
                    countLabel.runAction(act4, completion: {
                        countLabel.removeFromParent()
                    })
                })
            })
        }
    }
    
    /**
     创建底边界
     */
    func initGround() {
        self.ground = SKSpriteNode(texture: SKTexture(imageNamed: "sceneView_ground.png"), size: CGSize(width: self.size.width, height: 30))
        self.ground!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) - 165)
        self.ground!.physicsBody = SKPhysicsBody.init(rectangleOfSize: self.ground!.size)
        self.ground!.physicsBody!.dynamic = false
        self.ground!.physicsBody!.affectedByGravity = false
        self.ground!.physicsBody!.contactTestBitMask = kPlayerCategaory
        self.ground!.physicsBody!.categoryBitMask = kGroundCategaory
        self.ground!.physicsBody!.usesPreciseCollisionDetection = true
        self.addChild(self.ground!)
    }
    
    /**
     创建初始平台
     */
    func initStage() {
        let stage: SKSpriteNode = SKSpriteNode(color: SKColor.blackColor(), size: CGSize.init(width: self.size.width * 3, height: 250))
        stage.position = CGPoint(x: self.size.width, y: CGRectGetMidY(self.frame) - 50)
        stage.physicsBody = SKPhysicsBody(rectangleOfSize: stage.size)
        stage.physicsBody!.dynamic = false;
        stage.physicsBody!.affectedByGravity = false;
        stage.physicsBody!.categoryBitMask = kStageCategaory;
        stage.physicsBody!.collisionBitMask = kPlayerCategaory;
        stage.physicsBody!.contactTestBitMask = kPlayerCategaory;
        stage.physicsBody!.usesPreciseCollisionDetection = false;
        self.addChild(stage)
        
        let actionMove: SKAction? = SKAction.moveToX(-self.size.width * 2, duration: 4)
        stage.runAction(actionMove!) { 
            stage.removeFromParent()
        }
    }
    
    /**
     添加移动平台
     */
    func addMoveStage() {
        var duration: NSTimeInterval = 2
        var width = arc4random() % 200 + 50
        var color: SKColor = SKColor.blackColor()
        
        let time = self.timeCount! / 10
        if time > 60 {
            width = arc4random() % 100 + 150
            duration = 1.9
        }
        
        if time > 180 {
            color = SKColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        }
        
        let object = SKSpriteNode(color: color, size: CGSize.init(width: Int(width), height: 5))
        let x = self.size.width * 1.2 + object.size.width
        let y = CGRectGetMidY(self.frame) - CGFloat((arc4random() % 60 + 40))
        object.position = CGPoint.init(x: x, y: y)
        object.physicsBody = SKPhysicsBody(rectangleOfSize: object.size)
        object.physicsBody!.categoryBitMask = kObjectCategaory
        object.physicsBody!.collisionBitMask = kPlayerCategaory
        object.physicsBody!.contactTestBitMask = kPlayerCategaory
        object.physicsBody!.allowsRotation = false
        object.physicsBody!.affectedByGravity = false
        object.physicsBody!.dynamic = false
        self.addChild(object)
        
        if time > 180 {
            object.physicsBody!.dynamic = true
        }
        
        //        self.gameDifficultyChange()
        
        let actionMove: SKAction = SKAction.moveToX(-object.size.width / 2, duration: duration)
        let actionMoveDone: SKAction = SKAction.removeFromParent()
        object.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    /**
     创建奔跑人物
     */
    func createPlayer() {
        let playerFrameName = "perRun"
        //构建一个用于保存跑步帧的可变数组（run frames）
        let runFrames: NSMutableArray? = NSMutableArray()
        //加载纹理图集
        let playerAnimatedAtlas: SKTextureAtlas? = SKTextureAtlas(named: playerFrameName)
        //构建帧列表
        let numImages: NSInteger = playerAnimatedAtlas!.textureNames.count
        for i in 1...numImages {
            let textrueName = String(format: "perRun%d", i)
            let frame:SKTexture? = playerAnimatedAtlas?.textureNamed(textrueName)
            runFrames?.addObject(frame!)
        }
        self.playerRunFrames = runFrames
        
        //创建Sprite，并将其位置设置为屏幕左侧，然后将其添加到场景中
        let frame: SKTexture = self.playerRunFrames![0] as! SKTexture
        self.player = SKSpriteNode(texture: frame, size: CGSize(width: 30, height: 40))
        self.player!.position = CGPoint(x: 40, y: CGRectGetMidY(self.frame) + 95)
        //物理属性设置
        self.player!.physicsBody = SKPhysicsBody(rectangleOfSize: self.player!.size)
        self.player!.physicsBody!.dynamic = true
        self.player!.physicsBody!.friction = 0;
        self.player!.physicsBody!.categoryBitMask = kPlayerCategaory
        self.player!.physicsBody!.contactTestBitMask = kObjectCategaory | kGroundCategaory | kStageCategaory
        self.player!.physicsBody!.collisionBitMask = kObjectCategaory | kGroundCategaory | kStageCategaory
        self.player!.physicsBody!.usesPreciseCollisionDetection = true
        self.player!.physicsBody!.allowsRotation = false
        self.addChild(self.player!)
        
        self.runPlayer()
    }
    
    /**
     人物奔跑动画
     */
    func runPlayer() {
        let act: SKAction? = SKAction.repeatActionForever(SKAction.animateWithTextures(self.playerRunFrames as! [SKTexture], timePerFrame: 0.03, resize: false, restore: true))
        self.player!.runAction(act!, withKey: kRUN_PLAYER)
    }
    
    /**
     人物跳跃动画
     */
    func jumpPlayer() {
        //设置为跳跃状态
        self.isJumping = true
        //删除跑步动画
        self.player!.removeAllActions()
        //跳跃时动画
        let duration = 0.3
        let jumpAction = SKAction.animateWithTextures(self.playerRunFrames as! [SKTexture], timePerFrame: 0.08, resize: false, restore: true)
        let moveUpAction = SKAction.moveTo(CGPoint.init(x: self.player!.position.x, y: self.player!.position.y + 90), duration: duration)
        let holdAction = SKAction.waitForDuration(0.03)
        
        let actions = [jumpAction, SKAction.sequence([moveUpAction, holdAction])]
        weak var weakSelf: GameScene? = self
        weakSelf!.player!.runAction(SKAction.group(actions)) {
            weakSelf!.runPlayer()
        }
    }
    
    /**
     创建计时器
     */
    func createTimeLabel() {
        self.timeLabel = SKLabelNode(fontNamed: "Yuppy SC")
        self.timeLabel?.fontColor = SKColor.blackColor()
        self.timeLabel!.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame) + 180)
        self.timeLabel!.fontSize = 50
        self.timeLabel!.text = "0.0"
        self.timeCount = 0.0
        self.addChild(self.timeLabel!)
    }
    
    /**
     开始计时
     */
    func startTiming() {
        self.timer = nil
        self.timeCount = 0.0
        
        let interval: __uint64_t = NSEC_PER_SEC / 10
        let timeQueue: dispatch_queue_t = dispatch_queue_create("timeQueue", DISPATCH_QUEUE_CONCURRENT)
        weak var weakSelf: GameScene? = self
        weakSelf!.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timeQueue)
        dispatch_source_set_timer(weakSelf!.timer!, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0)
        dispatch_source_set_event_handler(weakSelf!.timer!) {
            weakSelf?.updateTime()
        }
        dispatch_resume(weakSelf!.timer!)
        
        
        let backgroundMusicURL: NSURL = NSBundle.mainBundle().URLForResource("bgm1", withExtension: "caf")!
        do {
            self.audioPlayer = try AVAudioPlayer.init(contentsOfURL: backgroundMusicURL)
        } catch let error as NSError {
            print(error.description)
        }
        self.audioPlayer!.numberOfLoops = -1; //循环播放
        self.audioPlayer!.prepareToPlay()
        self.audioPlayer!.play()
    }
    
    /**
     时间刷新
     */
    func updateTime() {
        self.timeCount!++
        
        //应在主线程刷新UI
        weak var weakSelf: GameScene? = self
        dispatch_async(dispatch_get_main_queue(), {
            weakSelf!.timeLabel!.text = String(format: "%.1f", self.timeCount! / 10)
        })
    }
    
    /**
     游戏难度递增
     */
    func gameDifficultyChange() {
        let act: SKAction = SKAction.moveToX(-self.size.width, duration: 5)
        let countLabel: SKLabelNode = SKLabelNode(fontNamed: "Yuppy SC")
        countLabel.position = CGPoint(x: self.size.width + countLabel.frame.size.width / 2, y: self.size.height / 2 + 110)
        countLabel.fontColor = SKColor.blackColor()
        countLabel.fontSize = 20
        
        let time = self.timeCount! / 10
        if time > 60 && time < 60.3 {
            countLabel.text = "小明你竟然跑了1分钟了，看来得给你加点难度了"
            self.addChild(countLabel)
            countLabel.runAction(act, completion: {
                countLabel.removeFromParent()
            })
        } else if time > 180 && time < 180.3 {
            countLabel.text = "3分钟了！可是没有人能在这个游戏撑过4分钟！你也不行！"
            self.addChild(countLabel)
            countLabel.runAction(act, completion: {
                countLabel.removeFromParent()
            })
            let backgroundMusicURL: NSURL = NSBundle.mainBundle().URLForResource("bgm2", withExtension: "caf")!
            do {
                self.audioPlayer = try AVAudioPlayer.init(contentsOfURL: backgroundMusicURL)
            } catch let error as NSError {
                print(error.description)
            }
            
            self.audioPlayer!.numberOfLoops = -1; //循环播放
            self.audioPlayer!.prepareToPlay()
            self.audioPlayer!.play()
        }
    }
    
    
    func updateWithTimeSinceLastUpdate(timeSinceLast: NSTimeInterval?) {
        //将上次更新（update调用）的时间追加到self.lastSpawnTimeInterval中
        self.lastSpawnTimeInterval = self.lastSpawnTimeInterval! + timeSinceLast!
        let randomCount = NSTimeInterval(arc4random() % 30 + 70) / 100
        if (self.lastSpawnTimeInterval > randomCount) {
            self.lastSpawnTimeInterval = 0
            dispatch_async(dispatch_get_main_queue(), {
                self.addMoveStage()
            })
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        var timeSinceLast: NSTimeInterval = currentTime - self.lastUpdateTimeInterval!
        self.lastUpdateTimeInterval = currentTime
        if timeSinceLast > 1 {
            timeSinceLast = 1 / 60
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.updateWithTimeSinceLastUpdate(timeSinceLast)
        }
        
        if self.player!.position.y <= self.ground!.position.y {
            self.gameOver()
        }
        if self.player!.position.x <= 40 {
            self.player!.runAction(SKAction.moveToX(40, duration: 1))
        }
    }
    
    func gameOver() {
        let reveal: SKTransition = SKTransition.flipVerticalWithDuration(0.5)
        let gameOverScene: GameOverScene = GameOverScene.init(size: self.size, time: self.timeCount! / 10, presentView: self.presentView!, delegate: self)
        self.presentView!.presentScene(gameOverScene, transition: reveal)
        self.removeAllChildren()
        if self.timer != nil {
            self.timer = nil
        }
        self.audioPlayer!.stop()
        self.audioPlayer = nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.isJumping != false) {
            return
        }
        
        self.jumpPlayer()
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody?, secondBody: SKPhysicsBody? = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody!.categoryBitMask & kPlayerCategaory) != 0) {
            if (secondBody!.categoryBitMask & kStageCategaory) != 0 {
                self.isJumping = false
            } else if (secondBody!.categoryBitMask & kObjectCategaory) != 0 {
                self.isJumping = contact.contactPoint.y > firstBody!.node!.position.y
            } else if (secondBody!.categoryBitMask & kGroundCategaory) != 0 {
                self.runAction(SKAction.playSoundFileNamed("gameOverSound.caf", waitForCompletion: false))
                self.gameOver()
            }
        }
    }
    
    func gameoverSceneOnReturnMenuClicked() {
        self.audioPlayer = nil
        self.returnMenuDelegate!.returnMenu()
    }
}
