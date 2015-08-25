//
//  TimeManager.m
//  XMAdvGame
//
//  Created by lanou on 15/7/27.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import "TimeManager.h"
static TimeManager *_instance=nil;
@implementation TimeManager
@synthesize timeCount=_timeCount;


+(TimeManager *)shareInstance
{
    if (_instance==nil) {
        _instance=[[super alloc]init];
    }
    return _instance;
}
@end
