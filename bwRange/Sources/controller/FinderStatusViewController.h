//
//  FinderStatusViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-21.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BleFinder.h"

@interface FinderStatusViewController : UITableViewController

@property (nonatomic, strong) BleFinder * bleFinder;
@end
