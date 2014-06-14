//
//  Utils.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-3.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "Utils.h"

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

+ (UIImage *)imageWithFinderType:(int)type
{
    NSString * imageName ;
    
    switch(type){
        case 0: imageName =@"icon_bag"; break;
        case 1: imageName =@"icon_keys"; break;
        case 2: imageName =@"icon_laptop"; break;
        case 3: imageName =@"icon_wallet"; break;
            
    }
    
    return [UIImage imageNamed:imageName];
}

+ (NSString  *)stringWithFinderType:(int)type{
    
    
    switch(type){
        default:
        case 0: return @"公文包"; break;
        case 1: return @"钥匙"; break;
        case 2: return @"笔记本"; break;
        case 3: return @"钱包"; break;
            
    }
}

+ (NSString  *)stringWithFinderDistance:(int)type{
        
        
        switch(type){
            default:
            case 0: return @"远"; break;
            case 1: return @"近"; break;
   
                
        }
    
  
      }





@end
