//
//  NewDeviceViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-11.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BleFinder.h"

@interface FinderDetailViewController : UITableViewController

@property (nonatomic, strong) NSDictionary * bleDevice;
@property (nonatomic, strong) BleFinder * bleFinder;


@property (strong, nonatomic) NSArray * typeOptions;
@property (strong, nonatomic) NSArray * distanceOptions;



- (void)newFinder:(int)finderType atRange:(int)range;
@end
