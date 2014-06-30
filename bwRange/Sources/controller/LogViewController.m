//
//  LogViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-30.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "LogViewController.h"
#import "Utils.h"

@interface LogViewController ()

@end

@implementation LogViewController

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
    
    [ self.logView setText:@"finder server running..."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logStringWithFormat:(NSString *)formatString, ...
{
    va_list args;
    va_start(args, formatString);
    NSString *output = [[NSString alloc] initWithFormat:formatString arguments:args];
    va_end(args);
    
    
   // _logView.text = [NSString stringWithFormat:@"%lu: %@\n%@", (unsigned long)lineCounter, output, outputLabel.text];
    
    static unsigned int liner_count = 0;
    [_logView setText:[NSString stringWithFormat:@"[ %d ]  %@\r\n%@",liner_count,output,_logView.text]];
    
   // NSLog(@"%@",s);
    liner_count++;
   [self.view setNeedsLayout];
    
   // lineCounter++;
}

-(IBAction)clearLog:(id)sender{
    [ _logView setText:@"" ];
}

+(LogViewController *)getLogView:(UIViewController *)currentpage{
    
    static int logPageIndex = -1;
    
    if(logPageIndex < 0){
        for(int i = 0; i < currentpage.tabBarController.view.subviews.count ; i++){
           UIViewController * viewController =  [currentpage.tabBarController.view.subviews objectAtIndex:i];
            
            if([ viewController isKindOfClass:[LogViewController class] ]){
                logPageIndex = i;
                break;
            }
        }
    }
    
    if(logPageIndex < 0 )
        return nil;
    
    return [Utils getOtherPageController:currentpage index:logPageIndex] ;
}

+(void)addLog:(UIViewController *)currentpage log:(NSString *)log, ...{
    LogViewController * ctrl = [LogViewController  getLogView:currentpage];
    
     //[ ctrl logStringWithFormat:log,...];
    
    va_list args;
    va_start(args, log);
    NSString *output = [[NSString alloc] initWithFormat:log arguments:args];
    va_end(args);
    
    [ ctrl logStringWithFormat:output];
    
#ifdef DEBUG
    NSLog(output);
#endif

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
