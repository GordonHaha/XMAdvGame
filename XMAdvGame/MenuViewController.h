//
//  MenuViewController.h
//  XMAdvGame
//
//  Created by Gordon on 15/7/21.
//  Copyright (c) 2015年 Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"

@import SpriteKit;

@interface MenuViewController : UIViewController

@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic) BOOL isReturnBack;
@property (nonatomic, strong) SKView *skView;
@end
