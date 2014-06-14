//
//  NewDeviceViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-11.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewDeviceViewController : UITableViewController

@property (nonatomic, strong) NSDictionary * bleDevice;


@property (strong, nonatomic) NSArray * typeOptions;
@property (strong, nonatomic) NSArray * distanceOptions;

@end
