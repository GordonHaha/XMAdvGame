//
//  TimeManager.m
//  XMAdvGame
//
//  Created by Gordon on 15/7/27.
//  Copyright (c) 2015年 Gordon. All rights reserved.
//

#import "TimeManager.h"

@implementation TimeManager

@synthesize timeCount = _timeCount;

+ (TimeManager *)shareInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
@end
