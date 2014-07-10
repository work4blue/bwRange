//
//  SharedUI.h
//  ProximityApp
//
//  Copyright (c) 2012 Nordic Semiconductor. All rights reserved.
//
//

#import <Foundation/Foundation.h>

#import "BleFinder.h"

@interface SharedUI : NSObject

+ (void) showFindPhoneDialog:(ProximityTagAlertLevel) alertLevel forTag:(BleFinder*) finder;
+ (void) showFailedConnectDialog:(BleFinder*) finder;
+ (void) showOutOfRangeDialog:(ProximityTagAlertLevel) alertLevel forTag:(BleFinder*) finder;

@end
