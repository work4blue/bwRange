//
//  FinderListViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-12.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "BleFinder.h"

#import "W4bAudioPlayer.h"

//,UINavigationControllerDelegate

#define NotificationFinderStateChanged  @"Notification_FinderStateChanged"

@interface FinderListViewController : UITableViewController<UINavigationControllerDelegate,FinderStateNotifyDelegate,
UIAlertViewDelegate>

@property (strong,nonatomic) NSMutableArray *nFinders;
@property (nonatomic) int currentLine ;

@property (nonatomic, strong) CBCentralManager *bleManager;






-(IBAction) AlarmClicked:(id)sender;

-(IBAction) refreshClicked:(id)sender;
-(IBAction) disconnectClicked:(id)sender;

-(void)scanBleFinder;
-(void)stopScan;

@end
