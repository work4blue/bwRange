//
//  BleFinder.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-14.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleFinder : NSObject

@property (nonatomic) int finderType ; //wallet ,bag ...

- (NSString  *)getName;
- (UIImage  *)getImage;


+ (UIImage *)imageWithFinderType:(int)type;

+ (NSString  *)stringWithFinderType:(int)type;

+ (NSString  *)stringWithFinderDistance:(int)type;
@end
