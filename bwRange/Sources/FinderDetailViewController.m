//
//  NewDeviceViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-11.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "FinderDetailViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "LeveyPopListView.h"

#import "AppDelegate.h"



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
    
    self.navigationController.delegate=self;
    
    

    
    if(self.isNewDevice == YES){
        self.navigationItem.rightBarButtonItem.title =@"保存";
    }
    
    
    
    [self initTypeList];
    
    [self initDistanceList];
    
     [self initRingtoneList];
    
    
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

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData ];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //if ([segue.identifier isEqualToString:@"newDevice"])
    {
        
        
//        SingleSelectViewController *destViewController = segue.destinationViewController;
//        
//        
//        [ destViewController initCheck:0];
    }
}

#pragma mark - 选择列表


-(void)initRingtoneList{
    
    self.ringtoneOptions = [AppDelegate sharedInstance].dataManager.nRingtones;
    
    
}


-(void)initDistanceList{
    
    self.distanceOptions = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"近",@"text", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"远",@"text", nil],
                       
                       
                        nil];
    
    
}


-(void)initTypeList{
    
    self.typeOptions = [NSArray arrayWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon_bag"],@"img",@"公文包",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon_keys"],@"img",@"钥匙",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon_laptop"],@"img",@"笔记本",@"text", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"icon_wallet"],@"img",@"钱包",@"text", nil],
                nil];
    
    
}


//处理铃声列表

- (void)showRingtoneListView {
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"铃声" options:_ringtoneOptions handler:^(NSInteger anIndex) {
        
        NSString * tone = [ NSString stringWithFormat:@"%d",anIndex];
        
        self.bleFinder.ringtone = [[AppDelegate sharedInstance].dataManager  getRingtone:tone ];      [ self setRingtone:self.tableView];
        
        
    }];
    lplv.delegate = self;
    
    [lplv showInView:self.tableView animated:YES];
}



//处理选择列表

- (void)showDistanceListView {
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"选择报警距离" options:_distanceOptions handler:^(NSInteger anIndex) {
        //_infoLabel.text = [NSString stringWithFormat:@"You have selected %@", _options[anIndex]];
        
        self.bleFinder.range = anIndex;
        [ self setFindRange:anIndex atView:self.tableView];
        
        
    }];
    lplv.delegate = self;
    
    [lplv showInView:self.tableView animated:YES];
}




//处理选择列表

- (void)showTypeListView {
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"选择一个类型" options:_typeOptions handler:^(NSInteger anIndex) {
        //_infoLabel.text = [NSString stringWithFormat:@"You have selected %@", _options[anIndex]];
        
        self.bleFinder.finderType = anIndex;
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


#pragma mark - 操作处理
- (IBAction)finishClick:(id)sender{
    if([self isNewDevice]){
        //保存并跳转
        
        [[AppDelegate sharedInstance].dataManager  addFinder:self.bleFinder ];
         [[AppDelegate sharedInstance].dataManager  saveFinder ];
        
        self.isNewDevice = NO;
        
        //[self dismissViewControllerAnimated:YES completion:nil];
       
        //[self.navigationController popViewControllerAnimated:YES];
        
        [self.navigationController popToRootViewControllerAnimated:NO ];

        
    }
    else{
       [[AppDelegate sharedInstance].dataManager  saveFinder ];
    }
}

#pragma mark - 操作响应
-(void)setFindType:(int)type atView:(UIView *)view{
    UIImageView *imageView = (UIImageView *)  [ view viewWithTag:201];
    
    imageView.image = [ BleFinder imageWithFinderType:type ];
    
    UILabel *nameView = (UILabel *)  [ view viewWithTag:202];
    nameView.text =[ BleFinder stringWithFinderType:type ];
}



-(void)setRingtone:(UIView *)view{
    UILabel *nameView = (UILabel *)  [ view viewWithTag:601];
    nameView.text =[ self.bleFinder.ringtone objectForKey:@"text" ];
    
}

-(void)setFindRange:(int)range atView:(UIView *)view{
    UILabel *nameView = (UILabel *)  [ view viewWithTag:302];
    nameView.text =[ BleFinder stringWithFinderDistance:range ];
}

#pragma mark - 对话框 响应
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [[AppDelegate getManager]
         removeFinder:self.bleFinder ];
    
     [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 表格处理

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
        case 600:
            [ self showRingtoneListView ];
            break;
        case 700:
        {
            if( [[AppDelegate getManager] isDemoMode] == YES)
                return ;
            
            //[self.bleFinder getName]
            NSString * msg = [ NSString stringWithFormat:@"是否删除 %@ ?", [self.bleFinder getName] ] ;
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"删除物品" message:msg delegate:self
                                                cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            alert.alertViewStyle=UIAlertViewStyleDefault;
            
      
            [alert show];
        }
          
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
        case 1:
            if(indexPath.row == 0)
            {
                [self setFindRange:self.bleFinder.range atView:cell ];
            }
            break;
        }
}



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
