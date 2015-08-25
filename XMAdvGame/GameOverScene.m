//
//  GameOverScene.m
//  XMAdvGame
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import "GameOverScene.h"
#import "FirstGameScene.h"
#import "MenuViewController.h"
#import "TimeManager.h"
#import "RootViewController.h"
@implementation GameOverScene
-(instancetype)initWithSize:(CGSize)size time:(float)time num:(int)num
{
    if (self=[super initWithSize:size]) {
        self.backgroundColor=[SKColor whiteColor];
        SKLabelNode *label=[SKLabelNode labelNodeWithFontNamed:@"Yuppy SC"];
        label.text=@"啊！小明掉下去了！";
        label.fontSize=37;
        if ([UIScreen mainScreen].bounds.size.width==375||[UIScreen mainScreen].bounds.size.width==414) {
            
            if ([TimeManager shareInstance].timeCount>=60.0f&&[TimeManager shareInstance].timeCount<120.0f) {
                label.text=@"哎哟不错哦！居然挺过了1分钟！";
                label.fontSize=25;
            }
            if ([TimeManager shareInstance].timeCount>=120.0f&&[TimeManager shareInstance].timeCount<180.0f) {
                label.text=@"坚持了2分钟的你离胜利已经不远了！";
                label.fontSize=22;
            }
            if ([TimeManager shareInstance].timeCount>=180.0f&&[TimeManager shareInstance].timeCount<240.0f) {
                label.text=@"居然过了三分钟！但你依然坚持不到四分钟的！";
                label.fontSize=21;
            }
            if ([TimeManager shareInstance].timeCount>=240.0f) {
                label.text=@"你是电！你是光！你是唯一的神话！";
                label.fontSize=21;
            }
        }
        label.fontColor=[SKColor blackColor];
        label.position=CGPointMake(self.size.width/2, self.size.height/2+160);
        [self addChild:label];
        
        SKLabelNode *timeLabel=[SKLabelNode labelNodeWithFontNamed:@"Yuppy SC"];
        timeLabel.text=[NSString stringWithFormat:@"不可思议！你家小明竟然坚持了%0.1f秒",[TimeManager shareInstance].timeCount];
        timeLabel.fontSize=20;
        timeLabel.fontColor=[SKColor blackColor];
        timeLabel.position=CGPointMake(self.size.width/2, self.size.height/2+50);
        [self addChild:timeLabel];
        if ([UIScreen mainScreen].bounds.size.width==320) {
            label.fontSize=28;
            
            if ([TimeManager shareInstance].timeCount>=60.0f&&[TimeManager shareInstance].timeCount<120.0f) {
                label.text=@"哎哟不错哦！居然挺过了1分钟！";
                label.fontSize=18;
            }
            if ([TimeManager shareInstance].timeCount>=120.0f&&[TimeManager shareInstance].timeCount<180.0f) {
                label.text=@"坚持了2分钟的你离胜利已经不远了！";
                label.fontSize=18;
            }
            if ([TimeManager shareInstance].timeCount>=180.0f&&[TimeManager shareInstance].timeCount<240.0f) {
                label.text=@"居然过了三分钟！但你依然坚持不到四分钟的！";
                label.fontSize=15;
            }
            if ([TimeManager shareInstance].timeCount>=240.0f) {
                label.text=@"你是电！你是光！你是唯一的神话！";
                label.fontSize=18;
            }
            label.position=CGPointMake(self.size.width/2, self.size.height/2+130);
            
            timeLabel.fontSize=17;
            
            
        }
        
        SKSpriteNode *startNode=[[SKSpriteNode alloc]initWithColor:nil size:CGSizeMake(210, 60)];
        startNode.texture=[SKTexture textureWithImageNamed:@"重新开始"];
        startNode.position=CGPointMake(self.size.width/2, self.size.height/2-50);
        startNode.name=@"重新开始";
        [self addChild:startNode];
        
        
        SKSpriteNode *returnNode=[[SKSpriteNode alloc]initWithColor:nil size:CGSizeMake(210, 60)];
        returnNode.texture=[SKTexture textureWithImageNamed:@"返回菜单"];
        returnNode.position=CGPointMake(self.size.width/2, CGRectGetMinY(startNode.frame)-timeLabel.frame.size.height*3.5);
        returnNode.name=@"返回菜单";
        [self addChild:returnNode];
        
        if ([UIScreen mainScreen].bounds.size.width==768) {
            label.fontSize=80;
            if ([TimeManager shareInstance].timeCount>=60.0f&&[TimeManager shareInstance].timeCount<120.0f) {
                label.text=@"哎哟不错哦！居然挺过了1分钟！";
                label.fontSize=45;
            }
            if ([TimeManager shareInstance].timeCount>=120.0f&&[TimeManager shareInstance].timeCount<180.0f) {
                label.text=@"坚持了2分钟的你离胜利已经不远了！";
                label.fontSize=45;
            }
            if ([TimeManager shareInstance].timeCount>=180.0f&&[TimeManager shareInstance].timeCount<240.0f) {
                label.text=@"居然过了三分钟！但你依然坚持不到四分钟的！";
                label.fontSize=36;
            }
            if ([TimeManager shareInstance].timeCount>=240.0f) {
                label.text=@"你是电！你是光！你是唯一的神话！";
                label.fontSize=45;
            }
            
            
            
            timeLabel.fontSize=40;
            startNode.size=CGSizeMake(350, 120);
            returnNode.size=CGSizeMake(350, 120);
            label.position=CGPointMake(self.size.width/2, self.size.height/2+220);
            timeLabel.position=CGPointMake(self.size.width/2, self.size.height/2+100);
            startNode.position=CGPointMake(self.size.width/2, self.size.height/2-50);
            returnNode.position=CGPointMake(self.size.width/2, CGRectGetMinY(startNode.frame)-120);
        }
        
        
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:touchLocation];
    
    if ([node.name isEqualToString:@"重新开始"]) {
        SKTransition *reveal=[SKTransition flipVerticalWithDuration:0.5];
        FirstGameScene *fgs=[[FirstGameScene alloc]initWithSize:self.size];
        [self.view presentScene:fgs transition:reveal];
    }else if([node.name isEqualToString:@"返回菜单"]){
        [RootViewController shareInstance].mvc=[[MenuViewController alloc]init];
        [UIView transitionFromView:[RootViewController shareInstance].gvc.view toView:[RootViewController shareInstance].mvc.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
        
    }
    
    
}
@end
