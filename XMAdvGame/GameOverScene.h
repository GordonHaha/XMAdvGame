//
//  GameOverScene.h
//  XMAdvGame
//
//  Created by lanou on 15/7/23.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene
@property (nonatomic, assign) float time;
@property (nonatomic, assign) int score;
-(instancetype)initWithSize:(CGSize)size time:(float)time num:(int)num;
@end
