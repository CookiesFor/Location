//
//  BGTask.h
//  locationdemo
//
//  Created by SIMPLE PLAN on 16/6/24.
//  Copyright © 2016年 SIMPLE PLAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BGTask : NSObject
+(instancetype)shareBGTask;
-(UIBackgroundTaskIdentifier)beginNewBackgroundTask; //开启后台任务
-(void)endBackGroundTask:(BOOL)all;
@end
