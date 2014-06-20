//
//  Utils.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-3.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Utils : NSObject

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

+ (void)hideTabBar:(UIViewController*)viewController;
+ (void)hideNavBar:(UIViewController*)viewController;


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UITableViewCell *)getCellBySender:(UIView *)view;

+(BOOL)isFileExist:(NSString * )fileName;
+(BOOL)isPlistFileExist:(NSString * )fileName;

@end


