//
//  RootViewController.m
//  XMAdvGame
//
//  Created by lanou on 15/7/27.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end
static RootViewController *_root=nil;
@implementation RootViewController
@synthesize mvc=_mvc;
@synthesize gvc=_gvc;

+(RootViewController *)shareInstance
{
    if (_root==nil) {
        _root=[[super alloc]init];
    }
    return _root;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.mvc=[[MenuViewController alloc]init];
    [self.view addSubview:_mvc.view];
    self.gvc=[[GameViewController alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
