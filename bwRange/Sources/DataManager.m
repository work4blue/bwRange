//
//  DataManager.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-19.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "DataManager.h"
#import "BleFinder.h"
#import "Utils.h"

#define FINDER_PLIST_NAME @"Finders.plist"

@interface DataManager ()

@property  BOOL isDemoData; //演示数据

@end

@implementation DataManager



-(id) init{
    
    if (self=[super init]) {
       
        self.nBleFinders = [NSMutableArray arrayWithCapacity:0];
        
        
        [self load];
        
    }
    
    return self;
    
}

-(BOOL) isFinderPlistExists{
   return [Utils isSandboxFileExists:FINDER_PLIST_NAME];
}

-(NSString * )getFindersPlistPath{
    
    return [Utils getSandboxFilePath:FINDER_PLIST_NAME];
    //可以在沙盒中，
//    NSArray * appPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [appPaths objectAtIndex:0];
//    
//    return [documentsDirectory stringByAppendingString:@"/Finders.plist"];
    
    //也能在bundle中
   // return[[NSBundle mainBundle] pathForResource:@"Finders" ofType:@"plist"];
}
-(int)loadFinders{
    
    [ self.nBleFinders removeAllObjects];
    self.isDemoData = NO;
    
    NSMutableArray * temp = [Utils readFromSandboxFile:FINDER_PLIST_NAME];
    if((temp == nil) || (temp.count <=0) ){
        self.isDemoData = YES;
        
        NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"DemoFinders" ofType:@"plist"];
        
        temp = [NSMutableArray arrayWithContentsOfFile:plistPath ];
    }
    
    DLog(@"finder plist %d :\n%@",temp.count,temp);
    
    for (NSDictionary *dic in temp){
        BleFinder * finder = [[ BleFinder alloc] init];
        
        [finder initWithDictionary:dic];
        
        finder.ringtone = [self getRingtone:[dic objectForKey:@"RINGTONE"]];
        
        
        [ self.nBleFinders addObject:finder];
        
        
    }
    
    return temp.count;
    
}

-(int)loadFindersOld{
    
    [ self.nBleFinders removeAllObjects];
    
   //在应用中有一个空文件Finders.plist
    
    NSString *plistPath = [ self getFindersPlistPath ];
    if(plistPath == nil)
        return -1;
    
    self.isDemoData = NO;
    
    NSMutableArray * temp = [NSMutableArray arrayWithContentsOfFile:plistPath ];
    
    DLog(@"finder count %d,plist:%@",temp.count,temp);
    
    //if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    if(temp.count <=0)
    {
        //不存在，进入演示模式
        self.isDemoData = YES;
        
        plistPath = [[NSBundle mainBundle] pathForResource:@"DemoFinders" ofType:@"plist"];
        
        temp = [NSMutableArray arrayWithContentsOfFile:plistPath ];
        
    }
    
   
   
    
    for (NSDictionary *dic in temp){
        BleFinder * finder = [[ BleFinder alloc] init];
        
        [finder initWithDictionary:dic];
        
        finder.ringtone = [self getRingtone:[dic objectForKey:@"RINGTONE"]];
        
        
        [ self.nBleFinders addObject:finder];
        
        
    }
    
//    NSMutableArray *  temp3 = [NSMutableArray arrayWithCapacity:0];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"近",@"text", nil];
//    
//    [ temp3 addObject:dic];
//    
//    [Utils writeToSandboxFile:@"Finders2.plist" withData:temp3];
//    //NSMutableArray *  temp2 = [NSMutableArray arrayWithContentsOfFile:@"Finders2.plist" ];
//    
//    NSMutableArray *  temp2 = [Utils  readFromSandboxFile:@"Finders2.plist"  ];
//    
//    DLog(@"test file %@",temp2);
    
    
    
    
    
    

    
    
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
    //test
    
    
    
     [self   loadFinders     ];
     [self  loadFinderTypes ];
     [self  loadRingtones   ];
    
}

-(BOOL)isDemoMode{
    return  (self.isDemoData);
}

- (int) addFinder:(BleFinder *)finder{
    
    if( [self isDemoMode]){
        
        [self.nBleFinders removeAllObjects];
        
        self.isDemoData = NO;
    }
    
   // BleFinder * newFinder = [ finder copy]; //必须要实现 copyWithZone;
    
    [self.nBleFinders addObject:finder];
    
    
    return self.nBleFinders.count;
}

- (void) saveFinder{
    
    
    if([self isDemoMode] == YES)
        return ;
    
    NSMutableArray * findersArray = [NSMutableArray arrayWithCapacity:4];
    
    for (BleFinder * f in self.nBleFinders){
        
        NSDictionary *dic = [ f newDict ];
        
        [ findersArray addObject:dic];
        
        
    }
    
    [Utils writeToSandboxFile:FINDER_PLIST_NAME withData:findersArray];
    
   // [ self loadFinders ];
    
    
}

@end
