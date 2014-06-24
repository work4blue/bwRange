//
//  SingleSelectViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-14.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleSelectViewController : UITableViewController

@property(nonatomic, retain) NSIndexPath *lastIndexPath;




- (void)initCheck:(int)row;

@end
