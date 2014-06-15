//
//  FinderListViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-12.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "FinderListViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UIView+Toast.h"
#import "Utils.h"


@interface FinderListViewController ()




@end

@implementation FinderListViewController

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
    
    
    self.bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    self.nFinders = [NSMutableArray arrayWithCapacity:16];
    
    [ self initFinderData ];
}



- (void)initFinderData
{
    
    NSDictionary *finder1;
    
    finder1 = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSString stringWithFormat:@"%d", 1],@"id",
               @"笔记本电脑", @"name",
               @"icon_laptop", @"image",
               @"status_far", @"state",
               @"OFF", @"power",
               @"a:b:c:d:e:f", @"addr",
               nil];
    
    [ self.nFinders addObject:finder1 ];
    
    NSDictionary *finder2;
    
    finder2 = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSString stringWithFormat:@"%d", 2],@"id",
               @"钱包", @"name",
               @"icon_bag", @"image",
               @"status_near", @"state",
                @"OFF", @"power",
               @"a:b:c:d:e:f", @"addr",
               nil];
    
     [ self.nFinders addObject:finder2 ];
    
    
     NSDictionary *finder3;
    finder3 = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSString stringWithFormat:@"%d", 3],@"id",
               @"钥匙", @"name",
               @"icon_keys", @"image",
               @"status_linkloss", @"state",
                @"OFF", @"power",
               @"a:b:c:d:e:f", @"addr",
               nil];
    
    [ self.nFinders addObject:finder3 ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [ self.nFinders count ];
}

//联接切换开关，目前只把当成一个开关
-(IBAction)connectSwitchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    UITableViewCell* cell= [Utils getCellBySender:sender ];
    NSIndexPath* indexPath= [self.tableView indexPathForCell:cell];
    
    self.currentLine = indexPath.row; //取得当前行
    
    
//    if(isButtonOn)
//        [self.bleManager cancelPeripheralConnection:peripheral];
//    else
//        [self.bleManager connectPeripheral:peripheral options:nil];
    
    

}


-(IBAction) buttonClicked:(id)sender {
    
//    UIView* v=[sender superview];//UITableViewCellContentView
//    UIView* v2=[v superview]; //UITableViewCellScrollView
//    UITableViewCell* cell=(UITableViewCell*)[v2 superview];//UITableViewCell
   
    UITableViewCell* cell= [Utils getCellBySender:sender ];
    NSIndexPath* indexPath= [self.tableView indexPathForCell:cell];
    
    
    DLog(@"click row %d",indexPath.row);
    
     NSDictionary *finder = [ self.nFinders objectAtIndex:indexPath.row];
    
    
    
     NSString * name = [ finder objectForKey:@"name"];
    
    NSString * title = [ NSString stringWithFormat:@"%@%@%@", @"bwRange 标签 ",name ,@"发出哔的声音."];
    
    
    [ self.view makeToast:title
                duration:3.0
                position:@"bottom"
                   image:[UIImage imageNamed:@"leash_default_icon_bg"]];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Finder";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *finder = [ self.nFinders objectAtIndex:indexPath.row];
    //CBPeripheral *p = [device objectForKey:@"peripheral"];
    

    
//    for (UIView * view in cell.contentView.subviews) {
//        
//          DLog(@"cell view tag %d，class %@",view.tag,view.class);
//        
//    }
    
    
    
    UIImageView * ImageView = (UIImageView *)[cell viewWithTag:101];
    
    NSString * imageName = [ finder objectForKey:@"image"];
    ImageView.image = [UIImage imageNamed:imageName];
    
    UILabel *label = (UILabel *)[cell viewWithTag:102];
     NSString * name = [ finder objectForKey:@"name"];
    [ label setText:name];
    
    UISwitch * power = (UISwitch *)[cell viewWithTag:103];
    NSString * isOn = [ finder objectForKey:@"power"];
    
    if( [isOn isEqual:@"ON" ]){
        [ power setOn:YES ];
    }
    else {
        [ power setOn:NO ];
    }
    
    
    UIImageView * ImageState = (UIImageView *)[cell viewWithTag:104];
    NSString * stateName = [ finder objectForKey:@"state"];
    ImageState.image = [UIImage imageNamed:stateName];
    
    
    UIButton * button = (UIButton *)[cell viewWithTag:105];
    
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UISwitch * connectSwitch = (UISwitch *)[cell viewWithTag:103];
     [connectSwitch addTarget:self action:@selector(connectSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    
    return cell;
}


//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    DLog(@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.UUID);
    
    self.blePeripheral = peripheral;
    
    [self.blePeripheral setDelegate:self];
    [self.blePeripheral discoverServices:nil];
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}







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
