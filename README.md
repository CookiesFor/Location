# Location
运用系统的定位方法，封装分一个定位类库，
因为iOS7、iOS8、iOS9和iOS10的定位各有不同，在类库中已经做好了判断，可以直接使用
使用方法：
现在项目中判断，设备定位是否可用：
//判断定位权限
    if([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusDenied)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"应用没有开启定位，需要在在设置-隐私-定位服务-应用中开启定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusRestricted)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不可以定位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
如果设备定位可用：则开启定位
 self.bgLocation = [[BGLogation alloc]init];
 [self.bgLocation startLocation];
 在需要的地方，关闭定位
[self.bgLocation stopLocation];





