//
//  TimeManager.h
//  XMAdvGame
//
//  Created by lanou on 15/7/27.
//  Copyright (c) 2015年 龚诚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject
@property (nonatomic, assign) float timeCount;

+(TimeManager *)shareInstance;

@end
