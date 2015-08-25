//
//  MenuView.m
//  XMAdvGame
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.Title=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height/2-170, 280, 90)];
        if ([UIScreen mainScreen].bounds.size.height==320) {
            self.Title.frame=CGRectMake(0, 110, 260, 60);
        }
        self.Title.backgroundColor=[UIColor cyanColor];
        self.Title.image=[UIImage imageNamed:@"标题"];
        [self addSubview:self.Title];
        
        self.startButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.startButton.frame=CGRectMake(0, self.frame.size.height/2+30, 210, 60);
        [self.startButton setBackgroundImage:[UIImage imageNamed:@"开始游戏"] forState:UIControlStateNormal];
        [self.startButton setBackgroundImage:[UIImage imageNamed:@"开始游戏"] forState:UIControlStateHighlighted];
        [self addSubview:self.startButton];
        
        self.guanYuButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.guanYuButton.frame=CGRectMake(0, self.startButton.frame.origin.y+100,210, 60);
        [self.guanYuButton setBackgroundImage:[UIImage imageNamed:@"关于游戏"] forState:UIControlStateNormal];
        [self.guanYuButton setBackgroundImage:[UIImage imageNamed:@"关于游戏"] forState:UIControlStateHighlighted];
        [self addSubview:self.guanYuButton];
        
        if ([UIScreen mainScreen].bounds.size.width==768) {
            self.Title.frame=CGRectMake(0, 140, 600, 170);
            self.startButton.frame=CGRectMake(0, self.frame.size.height/2, 350, 120);
            self.guanYuButton.frame=CGRectMake(0, self.startButton.frame.origin.y+200,350, 120);
        }
        self.Title.center=CGPointMake(self.center.x, self.Title.center.y);
        self.startButton.center=CGPointMake(self.center.x, self.startButton.center.y);
        self.guanYuButton.center=CGPointMake(self.center.x, self.guanYuButton.center.y);

    }
    return self;
}

@end
