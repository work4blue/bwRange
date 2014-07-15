//
//  MainTabController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-7-1.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define MAIN_TAB_CONTROLLER  ((MainTabController*)(self.tabBarController))

#define MAIN_TAB_LOG  (2)
#define MAIN_TAB_CAMERA  (1)

@interface MainTabController : UITabBarController

//@property (nonatomic, strong) CBCentralManager * bleManager;
@property (nonatomic,strong) UIActivityIndicatorView *activity;


-(void)scanBleFinder;
@end
