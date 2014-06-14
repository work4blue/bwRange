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

//- (void)test{
//    
//    
//    [self.view makeToast:@"bwRange 标签 钥匙 发出哔的声音."
//                duration:3.0
//                position:@"bottom"
//                   image:[UIImage imageNamed:@"leash_default_icon_bg"]];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
 //   [self test ];
    
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
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:NO];
    
    [ Utils hideNavBar:self];
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
