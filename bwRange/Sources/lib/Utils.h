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

+(BOOL)isBundleFileExist:(NSString * )fileName;
+(BOOL) isSandboxFileExists:(NSString*)fileName;
+ (NSString*)getSandboxFilePath:(NSString*)fileName;

+ (void) writeToSandboxFile: (NSString*)fileName withData:(NSMutableArray *)data;
+ (NSMutableArray *) readFromSandboxFile: (NSString *)fileName;

+ (void)playMp3:(NSString *)fileName;

//一个页去调用另一个页的方法。
+ (UIViewController *)getOtherPageController:(UIViewController *)currentPageController index:(int)index;


+(void) playVibrate;

+(void)playSystemSound;

@end


