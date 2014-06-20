//
//  DistanceViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-20.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "DistanceViewController.h"
#import "FinderDetailViewController.h"

@interface DistanceViewController ()

@end

@implementation DistanceViewController

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
    //    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        //  NSDictionary *device = [ self.nDevices objectAtIndex:indexPath.row];
        
        FinderDetailViewController *destViewController = segue.destinationViewController;
        
        
        destViewController.bleDevice = self.bleDevice;
        int row  =self.lastIndexPath.row;
        [ destViewController  newFinder:self.finderType atRange:row ];
       // destViewController.finderType = self.lastIndexPath.row;
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
