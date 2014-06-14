//
//  SingleSelectViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-14.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "SingleSelectViewController.h"

@interface SingleSelectViewController ()

@property  int oldRow;
@property  int newRow;

@end



@implementation SingleSelectViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        //self.lastIndexPath = [NSIndexPath indexPathWithIndex:-1];

        self.newRow = -1;
        
        
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
    
    if(self.lastIndexPath >=0){
        
        
       // _newRow =  self.lastIndexPath.row;
        
        if(self.newRow >= 0){
            self.lastIndexPath = [NSIndexPath indexPathForRow:_newRow inSection:0];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.newRow inSection:0];
            UITableViewCell *newCell = (UITableViewCell *)[ self.tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryNone;

            
            DLog(@"table count %d",[self.tableView numberOfRowsInSection:0]);
            
          //    [self.tableView selectRowAtIndexPath:self.lastIndexPath  animated:NO scrollPosition:UITableViewScrollPositionNone];

//            UITableViewCell *newCell = (UITableViewCell *)[ self.tableView cellForRowAtIndexPath:_lastIndexPath];
//            //newCell.imgCheck.image = [UIImage imageNamed:@"Checkbox_Checked_New.png"];
//            newCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
    }
}

- (void)initCheck:(int)row{
    
    self.newRow = row;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _newRow = [indexPath row];
    _oldRow = [[self lastIndexPath] row];
    
    //Check Mark Feature
    if (_newRow != _oldRow)
    {
        UITableViewCell *newCell = (UITableViewCell *) [tableView  cellForRowAtIndexPath:indexPath];
        //newCell.imgCheck.image = [UIImage imageNamed:@"Checkbox_Checked_New.png"];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = (UITableViewCell *)[ tableView  cellForRowAtIndexPath:_lastIndexPath];
        // oldCell.imgCheck.image = [UIImage imageNamed:@"Checkbox_Unchecked_New.png"];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        [self setLastIndexPath:indexPath];
    }
    else
    {
        UITableViewCell *newCell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        //newCell.imgCheck.image = [UIImage imageNamed:@"Checkbox_Checked_New.png"];
        newCell.accessoryType = UITableViewCellAccessoryNone;
        
        [self setLastIndexPath:indexPath];
    }
}


#pragma mark - Table view data source



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
