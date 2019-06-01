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

private let kRUN_PLAYER = "runPlayer"

private let kPlayerCategaory: __uint32_t = 0x1 << 0
private let kObjectCategaory: __uint32_t = 0x1 << 1
private let kGroundCategaory: __uint32_t = 0x1 << 2
private let kStageCategaory: __uint32_t = 0x1 << 3

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var presentView: SKView?
    private var gameOverScene: GameOverScene?
    private var player: SKSpriteNode?
    private var ground: SKSpriteNode?
    private var countLabel: SKLabelNode?
    private var timeLabel: SKLabelNode?
    private var stage: SKSpriteNode?
    private var menuView: MenuView?
    
    private var lastSpawnTimeInterval: TimeInterval
    private var lastUpdateTimeInterval: TimeInterval
    
    private var timer: DispatchSourceTimer?
    private var timeCount: CGFloat
    
    private var playerRunFrames: NSArray?
    private var isJumping: Bool
    
    private var audioPlayer: AVAudioPlayer?
    
    private var start: Bool
    
    init(size: CGSize, presentView:SKView, menuView:MenuView) {
        super.init(size: size)
        self.start = false
        self.backgroundColor = SKColor.white
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        self.physicsWorld.contactDelegate = self
        self.presentView = presentView
        self.menuView = menuView
        self.lastUpdateTimeInterval = 0
        self.lastSpawnTimeInterval = 0
        
        self.resetGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func startGame() {
        self.start = true
        self.presentView!.presentScene(self)
        self.resetGame()
        
        let act1 = SKAction.scale(to:1.2, duration: 1)
        let act2 = SKAction.scale(to:1.3, duration: 1)
        let act3 = SKAction.scale(to:1.4, duration: 1)
        let act4 = SKAction.scale(to:1.5, duration: 1)
        
        self.countLabel!.run(act1) {
            self.countLabel!.text = "2"
            self.countLabel!.run(act2, completion: {
                self.countLabel!.text = "1"
                self.countLabel!.run(act3, completion: {
                    self.countLabel!.text = "小明快跑！"
                    
                    //倒计时结束开始游戏计时
                    self.startTiming()
                    self.countLabel!.run(act4, completion: {
                        self.countLabel!.removeFromParent()
                    })
                })
            })
        }
        
        let actionMove: SKAction? = SKAction.moveTo(x:-self.size.width * 2, duration: 4)
        self.stage!.run(actionMove!) {
            self.stage!.removeFromParent()
        }
        
        self.runPlayer()
    }
    
    
    
    
    
    func resetGame() {
        self.removeAllChildren()
        self.createPlayer()
        self.initGround()
        self.initStage()
        self.createCountDownLabel()
        self.createTimeLabel()
    }
    /**
     创建开场倒计时
     */
    func createCountDownLabel() {
        
        self.countLabel = SKLabelNode(fontNamed: "Yuppy SC")
        self.countLabel!.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 110)
        self.countLabel!.text = "3"
        self.countLabel!.fontSize = 50
        self.countLabel!.fontColor = SKColor.black
        self.addChild(self.countLabel!)
    }
    
    /**
     创建底边界
     */
    func initGround() {
        self.ground = SKSpriteNode(texture: SKTexture(imageNamed: "sceneView_ground.png"), size: CGSize(width: self.size.width, height: 30))
        self.ground!.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 165)
        self.ground!.physicsBody = SKPhysicsBody.init(rectangleOf: self.ground!.size)
        self.ground!.physicsBody!.isDynamic = false
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
        self.stage = SKSpriteNode(color: SKColor.black, size: CGSize.init(width: self.size.width * 3, height: 250))
        self.stage!.position = CGPoint(x: self.size.width, y: self.frame.midY - 50)
        self.stage!.physicsBody = SKPhysicsBody(rectangleOf: self.stage!.size)
        self.stage!.physicsBody!.isDynamic = false;
        self.stage!.physicsBody!.affectedByGravity = false;
        self.stage!.physicsBody!.categoryBitMask = kStageCategaory;
        self.stage!.physicsBody!.collisionBitMask = kPlayerCategaory;
        self.stage!.physicsBody!.contactTestBitMask = kPlayerCategaory;
        self.stage!.physicsBody!.usesPreciseCollisionDetection = false;
        self.addChild(self.stage!)
    }
    
    /**
     添加移动平台
     */
    func addMoveStage() {
        var duration: TimeInterval = 2
        var width = arc4random() % 200 + 50
        var color: SKColor = SKColor.black
        
        let time = self.timeCount / 10
        if time > 60 {
            width = arc4random() % 100 + 150
            duration = 1.9
        }
        
        if time > 180 {
            color = SKColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        }
        
        let object = SKSpriteNode(color: color, size: CGSize.init(width: Int(width), height: 5))
        let x = self.size.width * 1.2 + object.size.width
        let y = self.frame.midY - CGFloat((arc4random() % 60 + 40))
        object.position = CGPoint.init(x: x, y: y)
        object.physicsBody = SKPhysicsBody(rectangleOf: object.size)
        object.physicsBody!.categoryBitMask = kObjectCategaory
        object.physicsBody!.collisionBitMask = kPlayerCategaory
        object.physicsBody!.contactTestBitMask = kPlayerCategaory
        object.physicsBody!.allowsRotation = false
        object.physicsBody!.affectedByGravity = false
        object.physicsBody!.isDynamic = false
        self.addChild(object)
        
        if time > 180 {
            object.physicsBody!.isDynamic = true
        }
        
        //        self.gameDifficultyChange()
        
        let actionMove: SKAction = SKAction.moveTo(x: -object.size.width / 2, duration: duration)
        let actionMoveDone: SKAction = SKAction.removeFromParent()
        object.run(SKAction.sequence([actionMove, actionMoveDone]))
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
            runFrames?.add(frame!)
        }
        self.playerRunFrames = runFrames
        
        //创建Sprite，并将其位置设置为屏幕左侧，然后将其添加到场景中
        let frame: SKTexture = self.playerRunFrames![0] as! SKTexture
        self.player = SKSpriteNode(texture: frame, size: CGSize(width: 30, height: 40))
        self.player!.position = CGPoint(x: 40, y: self.frame.midY + 95)
        //物理属性设置
        self.player!.physicsBody = SKPhysicsBody(rectangleOf: self.player!.size)
        self.player!.physicsBody!.isDynamic = true
        self.player!.physicsBody!.friction = 0;
        self.player!.physicsBody!.categoryBitMask = kPlayerCategaory
        self.player!.physicsBody!.contactTestBitMask = kObjectCategaory | kGroundCategaory | kStageCategaory
        self.player!.physicsBody!.collisionBitMask = kObjectCategaory | kGroundCategaory | kStageCategaory
        self.player!.physicsBody!.usesPreciseCollisionDetection = true
        self.player!.physicsBody!.allowsRotation = false
        self.addChild(self.player!)
    }
    
    /**
     人物奔跑动画
     */
    func runPlayer() {
        let act: SKAction? = SKAction.repeatForever(SKAction.animate(with: self.playerRunFrames as! [SKTexture], timePerFrame: 0.03, resize: false, restore: true))
        self.player!.run(act!, withKey: kRUN_PLAYER)
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
        let jumpAction = SKAction.animate(with: self.playerRunFrames as! [SKTexture], timePerFrame: 0.08, resize: false, restore: true)
        let moveUpAction = SKAction.move(to: CGPoint.init(x: self.player!.position.x, y: self.player!.position.y + 90), duration: duration)
        let holdAction = SKAction.wait(forDuration: 0.03)
        
        let actions = [jumpAction, SKAction.sequence([moveUpAction, holdAction])]
        weak var weakSelf: GameScene? = self
        weakSelf!.player!.run(SKAction.group(actions)) {
            weakSelf!.runPlayer()
        }
    }
    
    /**
     创建计时器
     */
    func createTimeLabel() {
        self.timeLabel = SKLabelNode(fontNamed: "Yuppy SC")
        self.timeLabel?.fontColor = SKColor.black
        self.timeLabel!.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 180)
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
        let timeQueue = DispatchQueue(label: "timeQueue", attributes: .concurrent)
        self.timer! = DispatchSource.makeTimerSource(flags: [], queue: timeQueue)
        self.timer!.schedule(wallDeadline: .now(), repeating: interval)
        self.timer!.setEventHandler {
            self.updateTime()
        }
        self.timer!.resume()
        
        
        let backgroundMusicURL: NSURL = Bundle.main.url(forResource: "bgm1", withExtension: "caf")! as NSURL
        do {
            self.audioPlayer = try AVAudioPlayer.init(contentsOf: backgroundMusicURL as URL)
        } catch let error as NSError {
            print(error.description)
        }
        self.audioPlayer!.numberOfLoops = -1; //循环播放
        self.audioPlayer!.play()
    }
    
    /**
     时间刷新
     */
    func updateTime() {
        self.timeCount += 1
        
        //应在主线程刷新UI
        DispatchQueue.main.async {
            self.timeLabel!.text = String(format: "%.1f", self.timeCount / 10)
        }
    }
    
    /**
     游戏难度递增
     */
    func gameDifficultyChange() {
        let act: SKAction = SKAction.moveTo(x: -self.size.width, duration: 5)
        let countLabel: SKLabelNode = SKLabelNode(fontNamed: "Yuppy SC")
        countLabel.position = CGPoint(x: self.size.width + countLabel.frame.size.width / 2, y: self.size.height / 2 + 110)
        countLabel.fontColor = SKColor.black
        countLabel.fontSize = 20
        
        let time = self.timeCount / 10
        if time > 60 && time < 60.3 {
            countLabel.text = "小明你竟然跑了1分钟了，看来得给你加点难度了"
            self.addChild(countLabel)
            countLabel.run(act, completion: {
                countLabel.removeFromParent()
            })
        } else if time > 180 && time < 180.3 {
            countLabel.text = "3分钟了！可是没有人能在这个游戏撑过4分钟！你也不行！"
            self.addChild(countLabel)
            countLabel.run(act, completion: {
                countLabel.removeFromParent()
            })
            let backgroundMusicURL: URL = Bundle.main.url(forResource: "bgm2", withExtension: "caf")!
            do {
                self.audioPlayer = try AVAudioPlayer.init(contentsOf: backgroundMusicURL as URL)
            } catch let error as NSError {
                print(error.description)
            }
            
            self.audioPlayer!.numberOfLoops = -1; //循环播放
            self.audioPlayer!.play()
        }
    }
    
    
    func updateWithTimeSinceLastUpdate(timeSinceLast: TimeInterval?) {
        //将上次更新（update调用）的时间追加到self.lastSpawnTimeInterval中
        self.lastSpawnTimeInterval = self.lastSpawnTimeInterval + timeSinceLast!
        let randomCount = TimeInterval(arc4random() % 30 + 70) / 100
        if (self.lastSpawnTimeInterval > randomCount) {
            self.lastSpawnTimeInterval = 0
            self.addMoveStage()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.start == false {
            return
        }
        var timeSinceLast: TimeInterval = currentTime - self.lastUpdateTimeInterval
        self.lastUpdateTimeInterval = currentTime
        if timeSinceLast > 1 {
            timeSinceLast = 1 / 60
        }
        self.updateWithTimeSinceLastUpdate(timeSinceLast: timeSinceLast)
        
        
        if self.player!.position.y <= self.ground!.position.y {
            self.gameOver()
        }
        if self.player!.position.x <= 40 {
            self.player!.run(SKAction.moveTo(x: 40, duration: 1))
        }
    }
    
    func gameOver() {
        let reveal: SKTransition = SKTransition.flipVertical(withDuration: 0.5)
        self.gameOverScene = nil
        self.gameOverScene = GameOverScene.init(size: self.size, presentView: self.presentView!, menuView: self.menuView!)
        self.gameOverScene!.gameScene = self
        self.gameOverScene!.refreshTime(time: self.timeCount / 10)
        self.presentView!.presentScene(self.gameOverScene!, transition: reveal)
        self.removeAllChildren()
        if self.timer != nil {
            self.timer = nil
        }
        self.audioPlayer!.stop()
        self.audioPlayer = nil
        self.start = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
                self.run(SKAction.playSoundFileNamed("gameOverSound.caf", waitForCompletion: false))
                self.gameOver()
            }
        }
    }
}
