//
//  DistanceViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-20.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "SingleSelectViewController.h"
#import "BleDevice.h"

@interface DistanceViewController : SingleSelectViewController


@property (nonatomic, strong) BleDevice * bleDevice;
@property (nonatomic) int finderType;
@end
