//
//  AppDelegate.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-1.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"
#import "BleFinderService.h"
#import "W4bAudioPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DataManager *dataManager;

@property (nonatomic, strong) W4bAudioPlayer *audioPlayer;


@property (nonatomic) id  cameraView;

//@property (strong, nonatomic) BleFinderService *finderService;

//AppDelegate *delegate=(AppDelegate*)[[UIApplicationsharedApplication]delegate];
//delegate.dataManager;

+(AppDelegate*)sharedInstance;
+(DataManager*)getManager;

+(W4bAudioPlayer*)getAudioPlayer;
//+(BleFinderService*)getFinderService;





#define APP_DATA_MANAGER [AppDelegate sharedInstance].dataManager]

@end
