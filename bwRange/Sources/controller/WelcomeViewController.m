//
//  WelcomeViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-3.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "WelcomeViewController.h"
#import "Utils.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

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
   
    
    //如果用户创建一个设备，则直接进入Finder列表
   // if(![AppDelegate getManager].isDemoMode){
   //     [self performSegueWithIdentifier:@"FinderList" sender:self];
        
    //}
    
    
    
    [[AppDelegate getSystemAudioPlayer ] initRingtoneList:[AppDelegate getManager].nRingtones];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated{
    // [super viewDidAppear:(BOOL)animated];
    [super viewWillAppear:NO];
    
    [ Utils hideNavBar:self];
    
    if(![AppDelegate getManager].isDemoMode)
    {
        [self performSegueWithIdentifier:@"FinderList" sender:self];
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:NO];
    
    [ Utils hideNavBar:self];
    
    
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



- (void)viewDidAppear:(BOOL)animated{
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
