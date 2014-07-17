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

@interface CameraViewController : UIViewController<CustomImagePickerControllerDelegate,ImageFitlerProcessDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    CGFloat lastScale;
    CGRect oldFrame;    //保存图片原来的大小
    CGRect largeFrame;  //确定图片放大最大的程度
}

@property(nonatomic, retain) IBOutlet UIImageView * imageView;
@property(nonatomic, retain) IBOutlet UILabel * label;

@property(nonatomic) BOOL needTake ;

- (IBAction)showPicker:(id)sender;
- (IBAction)showPhotoLibrary:(id)sender;

-(void)showCameraView;


@end
