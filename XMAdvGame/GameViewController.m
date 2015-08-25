//
//  GameViewController.m
//  XMAdvGame
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import "GameViewController.h"
#import "FirstGameScene.h"

@interface GameViewController ()

@end


@implementation GameViewController
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.skView=[[SKView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_skView];
    if (!_skView.scene) {
//        _skView.showsFPS=YES;
//        _skView.showsNodeCount=YES;
        _skView.backgroundColor=[SKColor redColor];
        
        SKScene *scene=[FirstGameScene sceneWithSize:_skView.bounds.size];
        [_skView presentScene:scene];
        
    }



}




@end
