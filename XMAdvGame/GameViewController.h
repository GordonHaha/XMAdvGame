//
//  GameViewController.h
//  XMAdvGame
//

//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface GameViewController : UIViewController
@property (nonatomic, strong) SKView *skView;
@property (nonatomic, assign)float timeCount;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic) BOOL isStart;

@end
