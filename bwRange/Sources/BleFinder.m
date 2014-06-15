//
//  BleFinder.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-14.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "BleFinder.h"

@implementation BleFinder

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

- (NSString  *)getName{
    return [ BleFinder stringWithFinderType:_finderType ];
    
}
- (UIImage  *)getImage{
     return [ BleFinder imageWithFinderType:_finderType ];
}



@end


