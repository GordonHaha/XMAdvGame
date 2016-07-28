//
//  GameOverScene.h
//  XMAdvGame
//
//  Created by Gordon on 15/7/21.
//  Copyright (c) 2015年 Gordon. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverScene : SKScene

@property (nonatomic, assign) float time;
@property (nonatomic, assign) int score;

- (instancetype)initWithSize:(CGSize)size time:(float)time num:(int)num;

@end
