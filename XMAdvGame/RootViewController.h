//
//  RootViewController.h
//  XMAdvGame
//
//  Created by lanou on 15/7/27.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "GameViewController.h"
@interface RootViewController : UIViewController
@property (nonatomic, strong) MenuViewController *mvc;
@property (nonatomic, strong) GameViewController *gvc;

+(RootViewController *)shareInstance;
@end
