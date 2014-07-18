//
//  FinderStatusViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-21.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "FinderStatusViewController.h"
#import "FinderDetailViewController.h"

#import "LogViewController.h"

@interface FinderStatusViewController ()

@end

@implementation FinderStatusViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = [ self.bleFinder getName ];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FinderDetail"]) {
       // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // NSDictionary *device = [ self.nDevices objectAtIndex:indexPath.row];
        
        //BleFinder * finder = [[ AppDelegate getManager].nBleFinders objectAtIndex:indexPath.row ];
        
        FinderDetailViewController *destViewController = segue.destinationViewController;
        
        
        [ destViewController setFinder:self.bleFinder ];
    }
}

-(IBAction)alarmClick:(id)sender{
    
    BW_INFO_LOG(@"报警 %@,%@",[ self.bleFinder getName ],[self.bleFinder UUID ]);
    UIButton * checkbox = (UIButton *)sender;
    if(checkbox.tag == 0){
        //[checkbox setSelected:YES];
        checkbox.tag = 1;
        [ self.bleFinder trigeFinderAlert:YES ];
    }
    else {
        //[checkbox setSelected:NO];
        checkbox.tag = 0;
        [ self.bleFinder trigeFinderAlert:NO ];
    }
    
}
-(IBAction)rangeClick:(id)sender{
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isFar = [switchButton isOn];
    
    if(isFar)
        self.bleFinder.range = FINDER_RANGE_FAR;
    else
        self.bleFinder.range = FINDER_RANGE_NEAR;
    
    
    
}

//静音
-(IBAction)muteClick:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isVoice = [switchButton isOn];
    
    if(isVoice)
        self.bleFinder.mute = NO;
    else
        self.bleFinder.mute = YES;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    static NSString *mapId = @"map";
//    
//    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(NSString *)mapId];
//    
//   
//    
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
