//
//  BGLogation.m
//  locationdemo
//
//  Created by SIMPLE PLAN on 16/6/24.
//  Copyright © 2016年 SIMPLE PLAN. All rights reserved.
//

#import "BGLogation.h"
#import "BGTask.h"
#import "AppDelegate.h"

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface BGLogation()
{
    BOOL isCollect;

}
@property (strong , nonatomic) BGTask *bgTask; //后台任务
@property (strong , nonatomic) NSTimer *restarTimer; //重新开启后台任务定时器
@property (strong , nonatomic) NSTimer *closeCollectLocationTimer; //关闭定位定时器 （减少耗电）
@end
@implementation BGLogation
//初始化
-(instancetype)init
{
    if(self == [super init])
    {
        //
        _bgTask = [BGTask shareBGTask];
        isCollect = NO;
        //监听进入后台通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
  
    }
    return self;
}
+(CLLocationManager *)shareBGLocation
{
    static CLLocationManager *_locationManager;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        //            _locationManager.allowsBackgroundLocationUpdates = YES;
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=9.0) {
            
            _locationManager.allowsBackgroundLocationUpdates = YES;
            
        }
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        
    });
    return _locationManager;

}
//后台监听方法
-(void)applicationEnterBackground
{
    CLLocationManager *locationManager = [BGLogation shareBGLocation];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
        [locationManager requestAlwaysAuthorization];
    }
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=9.0) {
        
        locationManager.allowsBackgroundLocationUpdates = YES;
        
    }
    [locationManager startUpdatingLocation];
    [_bgTask beginNewBackgroundTask];
}


//重启定位服务
-(void)restartLocation
{
    NSLog(@"重新启动定位");
    CLLocationManager *locationManager = [BGLogation shareBGLocation];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [self.bgTask beginNewBackgroundTask];
}
//开启服务
- (void)startLocation {
    NSLog(@"开启定位");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        
        NSLog(@"locationServicesEnabled false");

    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            NSLog(@"authorizationStatus failed");
        } else {
            NSLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [BGLogation shareBGLocation];
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.delegate = self;
            if([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
    }
}

//停止后台定位
-(void)stopLocation
{
    NSLog(@"停止定位");
    isCollect = NO;
    CLLocationManager *locationManager = [BGLogation shareBGLocation];
    [locationManager stopUpdatingLocation];
}

#pragma mark --delegate
//定位回调里执行重启定位和关闭定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"定位收集");

    /**
     NSDictionary* testdic = BMKConvertBaiduCoorFrom(locations.lastObject.coordinate,BMK_COORDTYPE_COMMON);
     //转换GPS坐标至百度坐标(加密后的坐标)
     testdic = BMKConvertBaiduCoorFrom(locations.lastObject.coordinate,BMK_COORDTYPE_GPS);
     //    NSLog(@"x=%@,y=%@",[testdic objectForKey:@"x"],[testdic objectForKey:@"y"]);
     //解密加密后的坐标字典
     baiduCoor = BMKCoorDictionaryDecode(testdic);//转换后的百度坐标

     **/
  
}



- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请开启后台服务" message:@"应用没有不可以定位，需要在在设置/通用/后台应用刷新开启" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

@end
