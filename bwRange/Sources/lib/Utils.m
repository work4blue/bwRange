//
//  Utils.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-3.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "Utils.h"
#import <AVFoundation/AVFoundation.h>

@implementation Utils

+ (void)hideNavBar:(UIViewController*)viewController{
   
    
    UINavigationBar * navbar = NULL;
    UITabBar *tabBar = viewController.tabBarController.tabBar;
    
    
    if( (viewController.navigationController.navigationBar != NULL) ||
       (viewController.navigationController.navigationBar != NULL) )
        navbar = viewController.navigationController.navigationBar;
    else
        return ;
    
    //内容显示区
    UIView *contentView;
    
    if ( [[viewController.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [viewController.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [viewController.tabBarController.view.subviews objectAtIndex:0];
    
    
    if(navbar.hidden == NO)
    {
        
        
        [ contentView setFrame:CGRectMake(contentView.bounds.origin.x,contentView.bounds.origin.y,
                                          contentView.bounds.size.width, contentView.bounds.size.height +
                                          tabBar.frame.size.height)];
        
     
        [ navbar setHidden:YES ];
        
    }
    else {
        
        
        [contentView setFrame:CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,
                                         contentView.bounds.size.width, contentView.bounds.size.height - navbar.frame.size.height)];
        
       
        [ navbar setHidden:NO ];
    }
}

+ (void)hideTabBar:(UIViewController*)viewController{
    
    if( (viewController.tabBarController == NULL) || (viewController.tabBarController.tabBar == NULL))
        return ;
    
    UINavigationBar * navbar = NULL;
    UITabBar *tabBar = viewController.tabBarController.tabBar;
    
    
    if( (viewController.navigationController.navigationBar != NULL) ||
       (viewController.navigationController.navigationBar != NULL) )
        navbar = viewController.navigationController.navigationBar;
    
    //内容显示区
    UIView *contentView;
    
    if ( [[viewController.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [viewController.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [viewController.tabBarController.view.subviews objectAtIndex:0];
    
    
    if(tabBar.hidden == NO)
    {
        
        
        [ contentView setFrame:CGRectMake(contentView.bounds.origin.x,contentView.bounds.origin.y,
                                          contentView.bounds.size.width, contentView.bounds.size.height +
                                          tabBar.frame.size.height)];
        
        [ tabBar setHidden:YES ];
        [ navbar setHidden:YES ];
        
    }
    else {
        
        
        [contentView setFrame:CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - tabBar.frame.size.height)];
        
        [ tabBar setHidden:NO ];
        [ navbar setHidden:NO ];
    }
    
    
    
    
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//iOS7 UITableViewCell -> UITableViewCellScrollView -->UITableViewCellContentView --> sender
//old version UITableViewCell -> UITableViewCellContentView --> sender

+ (UITableViewCell *)getCellBySender:(UIView *)view
{
    if ([[[view superview] superview] isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)[[view superview] superview];
    }
    else if ([[[[view superview] superview] superview] isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)[[[view superview] superview] superview];
    }
    else{
        NSLog(@"something Panic happens");
    }
    return nil;
}

+(BOOL)isPlistFileExist:(NSString * )fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    
    if(path==NULL)
        
        return NO;
    
    return YES;
}

+ (NSString*)getSandboxFilePath:(NSString*)fileName{
    //沙盒中的文件路径
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
    NSString *plistPath =[doucumentsDirectiory stringByAppendingPathComponent:fileName];       //根据需要更改文件名
    return plistPath;
}

//判断沙盒中名为plistname的文件是否存在
+(BOOL) isSandboxFileExists:(NSString*)fileName{
    
    NSString *plistPath =[ Utils getSandboxFilePath:fileName ];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if( [fileManager fileExistsAtPath:plistPath]== NO ) {
       // NSLog(@"not exists");
        return NO;
    }else{
        return YES;
    }
    
}


+(BOOL)isBundleFileExist:(NSString * )fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@""];
    
    if(path==NULL)
        
        return NO;
    
    return YES;
}

+ (void) writeToSandboxFile: (NSString*)fileName withData:(NSMutableArray *)data
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [data writeToFile:finalPath atomically: YES];
    /* This would change the firmware version in the plist to 1.1.1 by initing the NSDictionary with the plist, then changing the value of the string in the key "ProductVersion" to what you specified */
}

+ (NSMutableArray *) readFromSandboxFile: (NSString *)fileName {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
    
    if (fileExists) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:finalPath];
        return arr;
    } else {
        return nil;
    }
}

+ (void)playMp3:(NSString *)fileName{
    SystemSoundID soundId;
    NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundId);
    AudioServicesPlaySystemSound(soundId);
}



+ (UIViewController *)getOtherPageController:(UIViewController *)currentPageController index:(int)index{
    return [currentPageController.tabBarController.view.subviews objectAtIndex:index] ;
}



@end
