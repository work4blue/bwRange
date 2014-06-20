//
//  DataManager.h
//  数据管理器
//
//  Created by  Andrew Huang on 14-6-19.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (strong,nonatomic) NSMutableArray *nBleDevices;
@property (strong,nonatomic) NSMutableArray *nRingtones;
@property (strong,nonatomic) NSMutableArray *nFinderTypes;



-(id) init;

-(int)loadFinders;

-(int)loadFinderTypes;
-(int)loadRingtones;

-(NSDictionary * )getRingtone:(NSString *)toneId;

-(BOOL)isDemoMode;

-(void)load;

@end
