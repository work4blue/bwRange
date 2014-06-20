//
//  NewDeviceViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-11.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "FinderDetailViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "SingleSelectViewController.h"
#import "LeveyPopListView.h"
#import "BleFinder.h"



@interface FinderDetailViewController ()
@property (nonatomic) BOOL isNewDevice;

@end

@implementation FinderDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.isNewDevice = NO;
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
    
    
    CBPeripheral * device =  [ self.bleDevice objectForKey:@"peripheral" ];
    
    self.navigationItem.title  = [ device name];
    
    
    
    [self initTypeList];
    
    [self initDistanceList];
    
    
    //[self setFindType:self.bleFinder.finderType];
    
    
    
    
    //UITableViewCell * cell = [self tableView:table cellForRowAtIndexPath:indexPath ];
    
    
   DLog(@"tableView count %d,", [ self tableView:self.tableView numberOfRowsInSection:0]);
   DLog(@"tableView scount %d,", [ self numberOfSectionsInTableView:self.tableView ]);
}


- (void)newFinder:(int)finderType atRange:(int)range{
     self.isNewDevice = YES;
      self.bleFinder = [[ BleFinder alloc] init];
    
    self.bleFinder.finderType = finderType;
    self.bleFinder.range =range;
    
}

- (void)setFinder:(BleFinder *)finder{
    self.isNewDevice = NO;
    self.bleFinder = finder;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //if ([segue.identifier isEqualToString:@"newDevice"])
    {
        
        
        SingleSelectViewController *destViewController = segue.destinationViewController;
        
        
        [ destViewController initCheck:0];
    }
}

-(void)initDistanceList{
    
    self.distanceOptions = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"远",@"text", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"近",@"text", nil],
                       
                        nil];
    
    
}

//处理选择列表

- (void)showDistanceListView {
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"选择报警距离" options:_distanceOptions handler:^(NSInteger anIndex) {
        //_infoLabel.text = [NSString stringWithFormat:@"You have selected %@", _options[anIndex]];
        
      
        
        UILabel *nameView = (UILabel *)  [ self.tableView viewWithTag:302];
        nameView.text =[ BleFinder stringWithFinderDistance:anIndex ];
    }];
    lplv.delegate = self;
    
    [lplv showInView:self.tableView animated:YES];
}

-(void)initTypeList{
    
    self.typeOptions = [NSArray arrayWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon_bag"],@"img",@"公文包",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon_keys"],@"img",@"钥匙",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon_laptop"],@"img",@"笔记本",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon_wallet"],@"img",@"钱包",@"text", nil],
                nil];
    
    
}

-(void)setFindType:(int)type atView:(UIView *)view{
    UIImageView *imageView = (UIImageView *)  [ view viewWithTag:201];
    
    imageView.image = [ BleFinder imageWithFinderType:type ];
    
    UILabel *nameView = (UILabel *)  [ view viewWithTag:202];
    nameView.text =[ BleFinder stringWithFinderType:type ];
}

//处理选择列表

- (void)showTypeListView {
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"选择一个类型" options:_typeOptions handler:^(NSInteger anIndex) {
        //_infoLabel.text = [NSString stringWithFormat:@"You have selected %@", _options[anIndex]];
        
        [ self setFindType:anIndex atView:self.tableView];
        
      
    }];
    
    lplv.delegate = self;
    
    [lplv showInView:self.tableView animated:YES];
}

- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex {
   // _infoLabel.text = [NSString stringWithFormat:@"You have selected %@",_options[anIndex]];
   
    
    
}
- (void)leveyPopListViewDidCancel {
   // _infoLabel.text = @"You have cancelled";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *newCell = (UITableViewCell *) [tableView  cellForRowAtIndexPath:indexPath];
    DLog(@"cell tag %d",newCell.tag);
    switch(newCell.tag)
    {
        case 200:
            [ self showTypeListView ];
            break;
        case 300:
            [ self showDistanceListView ];
            break;
    }
}

//表格显示前操作
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        
        case 0:
            if(indexPath.row == 0)
            {
                [self setFindType:self.bleFinder.finderType atView:cell ];
            }
            break;
        }
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

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
