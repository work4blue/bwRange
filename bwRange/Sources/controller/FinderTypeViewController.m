//
//  FinderTypeViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-20.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "FinderTypeViewController.h"

#import "DistanceViewController.h"

@interface FinderTypeViewController ()

@end

@implementation FinderTypeViewController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newDevice"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
      //  NSDictionary *device = [ self.nDevices objectAtIndex:indexPath.row];
        
        DistanceViewController *destViewController = segue.destinationViewController;
        
        
        destViewController.bleDevice = self.bleDevice;
        destViewController.finderType = self.lastIndexPath.row;
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

@end
