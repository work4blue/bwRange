//
//  AppDelegate.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-1.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DataManager *dataManager;

//AppDelegate *delegate=(AppDelegate*)[[UIApplicationsharedApplication]delegate];
//delegate.dataManager;

+(AppDelegate*)sharedInstance;

@end
