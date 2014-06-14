//
//  FinderListViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-12.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinderListViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *nFinders;
@property (nonatomic) int currentLine ;
@end
