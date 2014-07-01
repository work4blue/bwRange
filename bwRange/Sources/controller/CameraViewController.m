//
//  CameraViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-30.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "CameraViewController.h"
#import "CustomImagePickerController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DLog(@"Camera Page  Load....");
    // Do any additional setup after loading the view.
    [ self showPicker:self ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPicker:(id)sender
{
    CustomImagePickerController *picker = [[CustomImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [picker setIsSingle:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [picker setCustomDelegate:self];
    [self presentModalViewController:picker animated:YES];
   
}

- (void)cameraPhoto:(UIImage *)image  //选择完图片
{
   //取消滤镜
//    ImageFilterProcessViewController *fitler = [[ImageFilterProcessViewController alloc] init];
//    [fitler setDelegate:self];
//    fitler.currentImage = image;
//    [self presentModalViewController:fitler animated:YES];
    
    [self imageFitlerProcessDone:image ];
    
}

- (void)imageFitlerProcessDone:(UIImage *)image //图片处理完
{
    [self.label setHidden:YES];
    [self.imageView setHidden:NO] ;
    [self.imageView setImage:image];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
