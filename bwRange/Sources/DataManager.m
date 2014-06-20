//
//  DataManager.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-19.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "DataManager.h"
#import "BleFinder.h"

@interface DataManager ()

@property  BOOL isDemoData; //演示数据

@end

@implementation DataManager



-(id) init{
    
    if (self=[super init]) {
       
        self.nBleDevices = [NSMutableArray arrayWithCapacity:0];
        
        
        [self load];
        
    }
    
    return self;
    
}


-(int)loadFinders{
    
    [ self.nBleDevices removeAllObjects];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Finders" ofType:@"plist"];
    self.isDemoData = NO;
    if(plistPath == NULL){
        //不存在，进入演示模式
        self.isDemoData = YES;
        
        plistPath = [[NSBundle mainBundle] pathForResource:@"DemoFinders" ofType:@"plist"];
        
        
    }
    
    if(plistPath == NULL)
        return -1;
    
     NSMutableArray * temp = [NSMutableArray arrayWithContentsOfFile:plistPath ];
    if(!self.isDemoData){
        //如果装入数据为空也进入演示模式
        self.isDemoData = (temp.count <=0);
    }
    
    DLog(@"finder plist:%@",temp);
    
    for (NSDictionary *dic in temp){
        BleFinder * finder = [[ BleFinder alloc] init];
        
        [finder initWithDictionary:dic];
        
        finder.ringtone = [self getRingtone:[dic objectForKey:@"RINGTONE"]];
        
        
        [ self.nBleDevices addObject:finder];
        
        
    }
    
    
//    
//    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *plistPath1 = [paths objectAtIndex:0];
//    
//    NSString *realpath = [myPath stringByAppendingPathComponent:@"Finders.plist"];
    
    
    
    
    
    
    
    return 0;
}

-(int)loadFinderTypes{
     return 0;
}
-(int)loadRingtones{
    
     [ self.nRingtones removeAllObjects];
    
    NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"Ringtones" ofType:@"plist"];
    self.nRingtones = [NSMutableArray arrayWithContentsOfFile:fielPath];
    
//    for (NSMutableDictionary *dic in self.nRingtones){
//        [dic setObject:[UIImage imageNamed:@"icon_bag"] forKey:@"image"];
//        
//    }
    
    //考虑与showList的兼容。可以直接联接
    
    NSLog(@"%@",self.nRingtones);
    
    
    
    
    
    return self.nRingtones.count;
    

}

-(NSDictionary * )getRingtone:(NSString *)toneId
{
    for (NSDictionary *tone in self.nRingtones){
        NSString * tmp = [ tone objectForKey:@"id"];
        if( [toneId isEqualToString:tmp] ){
            return tone;
        }
    }
             
    return nil;
}



-(void)load{
     [self   loadFinders     ];
     [self  loadFinderTypes ];
     [self  loadRingtones   ];
    
}

-(BOOL)isDemoMode{
    return  (self.isDemoData);
}

@end
