//
//  FirstGameScene.m
//  XMAdvGame
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import "FirstGameScene.h"
#import "GameOverScene.h"
#import "TimeManager.h"
#import "MenuViewController.h"
@import AVFoundation;

#define RunInPlacePlayer @"runInPlacePlayer"

static const uint32_t playerCategory       =  0x1 << 0;
static const uint32_t objectCategory       =  0x1 << 1;
static const uint32_t groundCategory       =  0x1 << 2;
static const uint32_t StageCategory        =  0x1 << 3;
//static const uint32_t BulletCategory       =  0x1 << 4;

@interface FirstGameScene ()<SKPhysicsContactDelegate>

@property (nonatomic, strong) SKSpriteNode *player;
@property (nonatomic, strong) SKSpriteNode *ground;
@property (nonatomic, strong) SKSpriteNode *object;
@property (nonatomic, strong) SKLabelNode *timeLabel;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)float timeCount;

@property (nonatomic, strong) NSArray *playerRunFrames;
@property (nonatomic) BOOL isJumping;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) SKAction *bg1;
@property (nonatomic, strong) SKAction *bg2;
@property (nonatomic, strong) SKAction *diebg;
@end


@implementation FirstGameScene
-(instancetype)initWithSize:(CGSize)size
{
    if (self=[super initWithSize:size]) {
        //打印出场景的size
        NSLog(@"Size:%@",NSStringFromCGSize(size));
        //设置场景背景色
        self.backgroundColor=[SKColor whiteColor];
        [self createPlayer];
        [self initGround];
        [self initStage];
        [self createTimeLabel];
        [self createCountLabel];
        
        self.physicsWorld.gravity=CGVectorMake(0, -5);
        self.physicsWorld.contactDelegate=self;
        
    }
    return self;
}
#pragma -mark 创建倒计时
-(void)createCountLabel
{
    SKLabelNode *countLabel=[[SKLabelNode alloc]initWithFontNamed:@"Yuppy SC"];
    countLabel.position=CGPointMake(self.size.width/2, self.size.height/2+110);
    countLabel.fontColor=[SKColor blackColor];
    countLabel.text=@"3";
    countLabel.fontSize=50;
    [self addChild:countLabel];
    SKAction *act1=[SKAction scaleTo:1.2 duration:1];
    SKAction *act2=[SKAction scaleTo:1.3 duration:1];
    SKAction *act3=[SKAction scaleTo:1.4 duration:1];
    SKAction *act4=[SKAction scaleTo:1.5 duration:1];
    if ([[UIDevice currentDevice].systemVersion floatValue]<=8.0) {
        act1=[SKAction scaleTo:1.2 duration:1.4];
        act2=[SKAction scaleTo:1.3 duration:1.4];
        act3=[SKAction scaleTo:1.4 duration:1.4];
        act4=[SKAction scaleTo:1.5 duration:1.4];
    }
    
    [countLabel runAction:act1 completion:^{
        countLabel.fontSize=50;
        countLabel.text=@"2";
        [countLabel runAction:act2 completion:^{
            countLabel.text=@"1";
            countLabel.fontSize=50;
            [countLabel runAction:act3 completion:^{
                countLabel.fontSize=50;
                countLabel.text=@"小明快跑！";
                //倒计时结束开始游戏计时
                [self startTime];
                [countLabel runAction:act4 completion:^{
                    [countLabel removeFromParent];
                    
                }];
            }];
        }];
        
    }];
    
}
#pragma -mark 创建底线
-(void)initGround
{
    self.ground=[[SKSpriteNode alloc]initWithTexture:[SKTexture textureWithImageNamed:@"sceneView_ground.png"] color:nil size:CGSizeMake(self.size.width, 30)];
    if ([[UIScreen mainScreen]bounds].size.width==768) {
        self.ground.size=CGSizeMake(self.size.width, 45);
    }
    self.ground.position=CGPointMake(self.size.width/2, CGRectGetMidY(self.frame)-165);
    [self addChild:self.ground];
    
    _ground.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:_ground.size];
    _ground.physicsBody.dynamic=NO;
    _ground.physicsBody.affectedByGravity=NO;
    _ground.physicsBody.contactTestBitMask=playerCategory;
    _ground.physicsBody.categoryBitMask=groundCategory;
    _ground.physicsBody.collisionBitMask=playerCategory;
    _ground.physicsBody.usesPreciseCollisionDetection=YES;
    
}
#pragma -mark 创建计时器
-(void)createTimeLabel
{
    
    self.timeLabel=[[SKLabelNode alloc]initWithFontNamed:@"Yuppy SC"];
    self.timeLabel.position=CGPointMake(self.size.width/2, self.size.height/2+180);
    self.timeLabel.fontSize=50;
    self.timeLabel.fontColor=[SKColor blackColor];
    self.timeLabel.text=@"0.0";
    self.timeCount=0.0;
    [self addChild:self.timeLabel];
    if ([UIScreen mainScreen].bounds.size.width==768) {
        self.timeLabel.fontSize=120;
        self.timeLabel.position=CGPointMake(self.size.width/2, self.size.height/2+250);
    }
    
}
- (void)startTime
{
    NSLog(@"计时开始");
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"11111");
    }
    __block FirstGameScene *blockSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        blockSelf->_timer=[NSTimer scheduledTimerWithTimeInterval:0.1
                                                           target:blockSelf
                                                         selector:@selector(addTime)
                                                         userInfo:nil
                                                          repeats:YES] ;
        [[NSRunLoop currentRunLoop] addTimer:blockSelf->_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    //    self.timer = [NSTimer timerWithTimeInterval:0.004 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    NSError *error;
    NSURL *backgroundMusicURL=[[NSBundle mainBundle]URLForResource:@"1" withExtension:@"caf"];
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:backgroundMusicURL error:&error];
    self.audioPlayer.numberOfLoops=-1;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
    
}
- (void)addTime{
    self.timeCount++;
    self.timeLabel.text = [NSString stringWithFormat:@"%.1f", self.timeCount/10];
    NSLog(@"%@",self.timeLabel.text);
}

#pragma -mark 创建初始平台
-(void)initStage
{
    
    SKSpriteNode *stage=[[SKSpriteNode alloc]initWithColor:[SKColor blackColor] size:CGSizeMake(self.frame.size.width*3,250)];
    
    stage.position=CGPointMake(self.size.width, CGRectGetMidY(self.frame)-50);
    [self addChild:stage];
    
    //初始平台
    stage.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:stage.size];
    stage.physicsBody.dynamic=NO;
    stage.physicsBody.affectedByGravity=NO;
    stage.physicsBody.categoryBitMask=StageCategory;
    stage.physicsBody.collisionBitMask=playerCategory;
    stage.physicsBody.contactTestBitMask=playerCategory;
    stage.physicsBody.usesPreciseCollisionDetection=YES;
    int duration=5;
    if ([UIScreen mainScreen].bounds.size.width==768) {
        stage.size=CGSizeMake(self.size.width*2, 250);
        duration=4;
    }
    SKAction *actionMove=[SKAction moveToX:-stage.size.width/2 duration:duration];
    [stage runAction:[SKAction sequence:@[actionMove,[SKAction removeFromParent]]]];
    
    
}
#pragma -mark 创建奔跑人物
-(void)createPlayer
{
    //构建一个用于保存跑步帧（run frame）
    NSMutableArray *runFrames=[NSMutableArray array];
    //加载纹理图集
    SKTextureAtlas *playerAnimatedAtlas=[SKTextureAtlas atlasNamed:@"perRun"];
    //构建帧列表
    NSInteger numImages=playerAnimatedAtlas.textureNames.count;
    for (int i=1; i<=numImages; i++) {
        NSString *textureName=[NSString stringWithFormat:@"perRun%d",i];
        SKTexture *temp=[playerAnimatedAtlas textureNamed:textureName];
        [runFrames addObject:temp];
    }
    _playerRunFrames=runFrames;
    //创建sprite，并将其位置设置为屏幕左侧，然后将其添加到场景中
    SKTexture *temp=_playerRunFrames[0];
    _player=[[SKSpriteNode alloc]initWithTexture:temp color:nil size:CGSizeMake(30,40)];
    if ([[UIScreen mainScreen]bounds].size.width==768) {
        _player.size=CGSizeMake(40, 55);
    }
    _player.position=CGPointMake(40, CGRectGetMidY(self.frame)+95);
    [self addChild:_player];
    [self runPlayer];
    
    //物理属性设置
    _player.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:_player.size];
    _player.physicsBody.dynamic=YES;
    _player.physicsBody.friction=0;
    _player.physicsBody.categoryBitMask=playerCategory;
    _player.physicsBody.contactTestBitMask=objectCategory | groundCategory |StageCategory;
    _player.physicsBody.collisionBitMask=objectCategory | groundCategory |StageCategory;
    _player.physicsBody.usesPreciseCollisionDetection=YES;
    _player.physicsBody.allowsRotation=NO;
    
}
#pragma -mark 添加人物奔跑方法
-(void)runPlayer
{
    [_player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_playerRunFrames timePerFrame:0.03f resize:NO restore:YES]]withKey:RunInPlacePlayer];
}
#pragma -makr 添加人物跳跃方法
-(void)jumpPlayer
{
    //设置为跳跃状态
    self.isJumping=YES;
    //删除跑的动画
    [self.player removeAllActions];
    //跳跃时的动画
    float duration=0.6;
    
    SKAction *jumpAction=[SKAction animateWithTextures:self.playerRunFrames timePerFrame:0.08 resize:NO restore:YES];
    
    
    //向上移动的动画
    SKAction *moveUpAction=[SKAction moveTo:CGPointMake(self.player.position.x, self.player.position.y+90) duration:duration/2+0.04];
    SKAction *holdAction=[SKAction waitForDuration:0.03];
    //    SKAction *moveDownAction=[SKAction moveTo:CGPointMake(self.player.position.x, self.player.position.y) duration:duration/2-0.04];
    
    __weak FirstGameScene *blockSelf=self;
    [self.player runAction:[SKAction group:@[jumpAction,[SKAction sequence:@[moveUpAction,holdAction]]]]completion:^{
        SKAction *runAction=[SKAction repeatActionForever:[SKAction animateWithTextures:blockSelf.playerRunFrames timePerFrame:0.03f resize:NO restore:YES]];
        [blockSelf.player runAction:runAction withKey:RunInPlacePlayer];
        
    }];
}

#pragma -mark 添加台阶
-(void)addObject
{
    
    //    self.object=[[SKSpriteNode alloc]initWithColor:[SKColor blackColor] size:CGSizeMake(arc4random()%20+200, arc4random()%95+35)];
    //    self.object.position=CGPointMake(self.frame.size.width+self.object.size.width, CGRectGetMidY(self.frame)-80+_object.size.height/2);
    int duration=2;
    int width=arc4random()%200+50;
    SKColor *color=[SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    if ([[UIScreen mainScreen]bounds].size.width==768) {
        duration=3;
    }
    if ([self.timeLabel.text floatValue]>60) {
        width=arc4random()%100+150;
        duration=1.9;
        NSLog(@"12313123123");
        
    }
    if([self.timeLabel.text floatValue]>180){
        color=[SKColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
        
    }
    
    self.object=[[SKSpriteNode alloc]initWithColor:color size:CGSizeMake(width, 5)];
    self.object.position=CGPointMake(self.frame.size.width*1.2+self.object.size.width, CGRectGetMidY(self.frame)-arc4random()%60+40+_object.size.height/2);
    [self addChild:self.object];
    
    
    _object.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:_object.size];
    _object.physicsBody.categoryBitMask=objectCategory;
    _object.physicsBody.collisionBitMask=playerCategory;
    _object.physicsBody.contactTestBitMask=playerCategory;
    _object.physicsBody.allowsRotation=NO;
    _object.physicsBody.affectedByGravity=NO;
    _object.physicsBody.dynamic=NO;
    if([self.timeLabel.text floatValue]>180){
        _object.physicsBody.dynamic=YES;
        
    }
    
    [self gameDifficultyChange];
    
    SKAction *actionMove=[SKAction moveToX:-_object.size.width/2 duration:duration];
    SKAction *actionMoveDone=[SKAction removeFromParent];
    
    [_object runAction:[SKAction sequence:@[actionMove,actionMoveDone]]];
}
#pragma -mark 游戏难度随时间递增
-(void)gameDifficultyChange
{
    SKAction *act=[SKAction moveToX:-self.size.width duration:5];
    SKLabelNode *countLabel=[[SKLabelNode alloc]initWithFontNamed:@"Yuppy SC"];
    countLabel.position=CGPointMake(self.size.width+countLabel.frame.size.width/2, self.size.height/2+110);
    countLabel.fontColor=[SKColor blackColor];
    countLabel.fontSize=20;
    if ([UIScreen mainScreen].bounds.size.width==768) {
        countLabel.fontSize=40;
    }
    if ([self.timeLabel.text floatValue]>60&[self.timeLabel.text floatValue]<60.3) {
        countLabel.text=@"小明你竟然跑了1分钟了，看来得给你加点难度了";
        [self addChild:countLabel];
        [countLabel runAction:act completion:^{
            [countLabel removeFromParent];
        }];
        
        NSError *error;
        NSURL *backgroundMusicURL=[[NSBundle mainBundle]URLForResource:@"2" withExtension:@"caf"];
        self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:backgroundMusicURL error:&error];
        self.audioPlayer.numberOfLoops=-1;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
    if ([self.timeLabel.text floatValue]>180&[self.timeLabel.text floatValue]<180.3) {
        countLabel.text=@"3分钟了！可是没有人能在这个游戏撑过4分钟！你也不行！";
        [self addChild:countLabel];
        [countLabel runAction:act completion:^{
            [countLabel removeFromParent];
        }];
    }
    
}
-(void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast{
    //将上次更新(update调用)的时间追加到self.lastSpawnTimeInterval中
    self.lastSpawnTimeInterval += timeSinceLast;
    //一旦该时间大于1秒，就在场景中新增一个怪兽，并将lastSpawnTimeInterval重置
    
    if (self.lastSpawnTimeInterval>(arc4random()%30+70)*0.01) {
        self.lastSpawnTimeInterval=0;
        [self addObject];
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    //处理时间增量
    CFTimeInterval timeSinceLast = currentTime-self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval=currentTime;
    if (timeSinceLast>1) {
        timeSinceLast=1.0/60.0;
        self.lastUpdateTimeInterval=currentTime;
    }
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    if (_player.position.y<=_ground.position.y) {
        [self gameOver];
    }
    if (_player.position.x<=40) {
        [_player runAction:[SKAction moveToX:40 duration:1]];;
    }
}


#pragma -mark 点击触发跳跃
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isJumping) {
        return;
    }
    NSLog(@"跳起来");
    [self jumpPlayer];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & objectCategory) != 0)
    {
        if (contact.contactPoint.y>firstBody.node.position.y) {
            NSLog(@"1=%f,2=%f",contact.contactPoint.y,firstBody.node.position.y);
            self.isJumping=YES;
        }else{
            NSLog(@"跳上了台阶");
            self.isJumping=NO;
        }
        
    }
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & groundCategory) != 0)
    {
        [self runAction:[SKAction playSoundFileNamed:@"3.caf" waitForCompletion:NO]];
        [self gameOver];
    }
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & StageCategory) != 0)
    {
        NSLog(@"初始台阶");
        self.isJumping=NO;
    }
    
}

-(void)gameOver
{
    SKTransition *reveal=[SKTransition flipVerticalWithDuration:0.5];
    [TimeManager shareInstance].timeCount=[self.timeLabel.text floatValue];
    GameOverScene *gos=[[GameOverScene alloc]initWithSize:self.size time:0 num:1];
    [self.view presentScene:gos transition:reveal];
    [self removeAllChildren];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"00000000");
    }
}
@end
