//
//  MenuViewController.h
//  XMAdvGame
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SpriteKit;
#import "MenuView.h"
@interface MenuViewController : UIViewController
@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic) BOOL isReturnBack;
@property (nonatomic, strong) SKView *skView;
@end
