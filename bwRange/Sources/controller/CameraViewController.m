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
    
   // [self initImageView];
   
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
   // UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
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


- (IBAction)showPhotoLibrary:(id)sender{
    CustomImagePickerController *picker = [[CustomImagePickerController alloc] init];
    
        [picker setIsSingle:YES];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [picker setCustomDelegate:self];
    
    [ AppDelegate sharedInstance ].cameraView = picker;
    [self presentModalViewController:picker animated:YES];
    
    if(self.needTake){
        picker.isAutoTake = YES;
        
    }
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

#pragma mark -UIIMAGE 手势识别

-(void)initImageView{
    [self.imageView setMultipleTouchEnabled:YES];
    [self.imageView setUserInteractionEnabled:YES];
    
    oldFrame = self.imageView.frame;
    
    UIView *contentView;
    
    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
    else
        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
    
    //最大尺寸
    largeFrame = CGRectMake(0 - contentView.bounds.size.width, 0 - contentView.bounds.size.height, 3 * oldFrame.size.width, 3 * oldFrame.size.height);
    
    [self addGestureRecognizerToView:self.imageView];
   
    
    
}

// 添加所有的手势
-(void) addGestureRecognizerToView:(UIView *)view
{
    // 旋转手势
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGestureRecognizer];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [view addGestureRecognizer:pinchGestureRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:panGestureRecognizer];
}

// 处理旋转手势
- (void) rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer
{
    UIView *view = rotationGestureRecognizer.view;
    if (rotationGestureRecognizer.state == UIGestureRecognizerStateBegan || rotationGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformRotate(view.transform, rotationGestureRecognizer.rotation);
        [rotationGestureRecognizer setRotation:0];
    }
}

// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
//    UIView *view = pinchGestureRecognizer.view;
//    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
//        pinchGestureRecognizer.scale = 1;
//    }
    
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        if (self.imageView.frame.size.width < oldFrame.size.width) {
            self.imageView.frame = oldFrame;
            //让图片无法缩得比原图小
        }
        if (self.imageView.frame.size.width > 3 * oldFrame.size.width) {
            self.imageView.frame = largeFrame;
        }
        pinchGestureRecognizer.scale = 1;
    }
}

// 处理拖拉手势
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}


@end
