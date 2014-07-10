//
//  DataManager.h
//  数据管理器
//
//  Created by  Andrew Huang on 14-6-19.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleFinder.h"

@interface DataManager : NSObject

@property (strong,nonatomic) NSMutableArray *nBleFinders;
@property (strong,nonatomic) NSMutableArray *nRingtones;
@property (strong,nonatomic) NSMutableArray *nFinderTypes;


@property (nonatomic) int scanCount; //扫描设备总数



-(id) init;

-(int)loadFinders;

-(int)loadFinderTypes;
-(int)loadRingtones;

-(NSDictionary * )getRingtone:(NSString *)toneId;

- (int) addFinder:(BleFinder *)finder;

//更新finder,不存在就新建
-(int)replaceFinder:(BleFinder *)finder;

- (BOOL) removeFinder:(BleFinder *)finder;

- (void) saveFinder;


-(void) resetFinders;

-(BOOL)isDemoMode;

-(void)load;

-(BOOL) scanedDevice:(CBPeripheral *)peripheral;
-(BOOL) isAllScaned;

//根据设备名反查Finder对象
-(BleFinder *)getFinder:(CBPeripheral *)peripheral;

-(BleFinder *)queryFinder:(NSString *)UUIDString;

-(int)queryFinderIndex:(NSString *)UUIDString;

-(BOOL) isNeedRescan;

-(BOOL)setFinderMute:(int)row mute:(BOOL)mute;
    

-(void)setDelegate:(id<FinderStateNotifyDelegate>)delegate;

@end
