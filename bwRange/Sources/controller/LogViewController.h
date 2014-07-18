//
//  LogViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-30.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>




#ifdef DEBUG
  #define BW_DEBUG_LOG(format,...)   BW_LOG(format,##__VA_ARGS__)

#else
  #define BW_DEBUG_LOG(format,...)

#endif

 #define BW_LOG(format,...)  [ LogViewController addLog:self log:format,##__VA_ARGS__ ]

//#define BW_INFO_LOG   BW_LOG
#define BW_INFO_LOG(format,...)


@interface LogViewController : UIViewController

@property(nonatomic, retain) IBOutlet UITextView * logView;

- (void)logStringWithFormat:(NSString *)log, ...;

-(IBAction)clearLog:(id)sender;
-(IBAction)pauseLog:(id)sender;

+(LogViewController *)getLogView:(UIViewController *)controller;

+(void)addLog:(UIViewController *)controller log:(NSString *)log, ...;

@end
