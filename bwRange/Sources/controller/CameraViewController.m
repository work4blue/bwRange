//
//  CameraViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-30.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "CameraViewController.h"
#import "CustomImagePickerController.h"
#import "AppDelegate.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.needTake = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DLog(@"Camera Page  Load....");
    // Do any additional setup after loading the view.
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showCameraView{
    CustomImagePickerController *picker = [[CustomImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }else{
        [picker setIsSingle:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [picker setCustomDelegate:self];
    
    [ AppDelegate sharedInstance ].cameraView = picker;
    [self presentModalViewController:picker animated:YES];
    
    if(self.needTake){
        picker.isAutoTake = YES;
        
    }
}

- (IBAction)showPicker:(id)sender
{
    [self showCameraView ];
   
}

- (void)cameraPhoto:(UIImage *)image  //选择完图片
{
   //取消滤镜
//    ImageFilterProcessViewController *fitler = [[ImageFilterProcessViewController alloc] init];
//    [fitler setDelegate:self];
//    fitler.currentImage = image;
//    [self presentModalViewController:fitler animated:YES];
    
    [self imageFitlerProcessDone:image ];
    self.needTake = NO;
    
}

- (void)cancelCamera{
     [ AppDelegate sharedInstance ].cameraView = nil;
    
    self.needTake = NO;
}


- (void)imageFitlerProcessDone:(UIImage *)image //图片处理完
{
    [self.label setHidden:YES];
    [self.imageView setHidden:NO] ;
    [self.imageView setImage:image];
    
    
     [ AppDelegate sharedInstance ].cameraView = nil;
    
    //保存到相册中
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 相册保存方法回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
	NSString *msg = nil ;
	if(error != NULL){
		msg = [ NSString stringWithFormat:@"保存图片失败 %@",error] ;
	}else{
		//msg = @"保存图片成功" ;
        return;
	}
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
    
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}



- (void)viewWillAppear:(BOOL)animated{
  
    // [ self showCameraView];
    
    [self cancelCamera ];
    
    

}

- (void)viewDidAppear:(BOOL)animated{
    
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
