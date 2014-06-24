//
//  FinderTypeViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-20.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "SingleSelectViewController.h"
#import "BleDevice.h"

@interface FinderTypeViewController : SingleSelectViewController

@property (nonatomic, strong) BleDevice * bleDevice;
@end
