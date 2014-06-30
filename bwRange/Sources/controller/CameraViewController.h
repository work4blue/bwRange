//
//  CameraViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-30.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomImagePickerController.h"
#import "ImageFilterProcessViewController.h"

@interface CameraViewController : UIViewController<CustomImagePickerControllerDelegate,ImageFitlerProcessDelegate>

@property(nonatomic, retain) IBOutlet UIImageView * imageView;
@property(nonatomic, retain) IBOutlet UILabel * label;

- (IBAction)showPicker:(id)sender;


@end
