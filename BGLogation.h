//
//  BGLogation.h
//  locationdemo
//
//  Created by SIMPLE PLAN on 16/6/24.
//  Copyright © 2016年 SIMPLE PLAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface BGLogation : NSObject<CLLocationManagerDelegate>

- (void)startLocation ;
-(void)stopLocation ;
@end
