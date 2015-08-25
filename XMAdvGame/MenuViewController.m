//
//  MenuViewController.m
//  XMAdvGame
//
//  Created by lanou on 15/7/21.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import "MenuViewController.h"
#import "GameViewController.h"
#import "FirstGameScene.h"
#import "RootViewController.h"
@interface MenuViewController ()
{
    GameViewController *gvc;
}


@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.menuView=[[MenuView alloc]initWithFrame:self.view.bounds];
    self.menuView.backgroundColor=[UIColor whiteColor];
    [self.menuView.startButton addTarget:self action:@selector(startButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView.guanYuButton addTarget:self action:@selector(guanYuButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuView];
   
}

#pragma -mark menu页面两个button的点击方法
-(void)startButton:(id)sender
{
    [RootViewController shareInstance].gvc=[[GameViewController alloc]init];
    NSLog(@"开始游戏");
//    [self presentViewController:[RootViewController shareInstance].gvc animated:YES completion:nil];
    [UIView transitionFromView:self.view toView:[RootViewController shareInstance].gvc.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
}
-(void)guanYuButton:(id)sender
{
    NSLog(@"关于游戏");
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"关于游戏" message:@"本游戏内音、图等资源皆来源于网络，仅供学习，交流使用。版权归原作者所有。对游戏有任何反馈意见可邮件至chenggeweiwu@163.com。\n\n开发者注：这个游戏很简单，不过估计基本没人能坚持到4分钟。排行及分享功能还有新关卡视情况在下个大版本中更新。" delegate:self cancelButtonTitle:@"谢谢关注！" otherButtonTitles:nil, nil];
    [alertView show];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
