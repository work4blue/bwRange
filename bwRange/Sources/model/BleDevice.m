//
//  BleDevice.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-15.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "BleDevice.h"

@interface BleDevice()
@property (nonatomic, strong) CBPeripheral *blePeripheral;
@end

@implementation BleDevice

-(id) init{
    
    if (self=[super init]) {
        self.blePeripheral = nil;
        
        self.nServices = [NSMutableArray arrayWithCapacity:4];
        self.nCharacteristics = [NSMutableArray arrayWithCapacity:4];
        
    }
    
    return self;
    
}

//-(NSString *)getUUID{
//    return [ self.peripheral.identifier UUIDString];
//}
//
//-(NSString *)getName{
//    NSString * p = self.peripheral.name;
//    if(p == nil)
//        return @"(null)";
//    else
//        return p;
//}

-(void) setPeripheral:(CBPeripheral *)peripheral{
    
    [ self.nServices removeAllObjects];
    [ self.nCharacteristics removeAllObjects];
    
    if(peripheral == nil){
        //self.UUID = nil;
        self.DevName  = nil;
        self.blePeripheral = nil;
        
       
        
        return ;
    }
    self.UUID = [ peripheral.identifier UUIDString];
    self.DevName = peripheral.name;
    if(self.DevName == nil){
        self.DevName = @"(null)";
    }
    
    
    
    self.blePeripheral = peripheral.copy;
    
    
    
   
    
}
-(CBPeripheral *)getPeripheral{
    return self.blePeripheral;
}



//根据rssi判断距离，单位是米
-(int) detectDistance:(int)rssi{
    CGFloat ci = (rssi - 49) / (10 * 4.);
    
    DLog(@"距离:%.1fm",pow(10,ci));
    
    return pow(10,ci);
   // NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_peripheral,pow(10,ci)];
    
   // return pow(10,ci);
}



-(void)updateStatus:(int)rssi{
    
}

-(int)showSerivces{
    DLog(@"device %@ all services （%d)",self.blePeripheral.name,self.blePeripheral.services.count);
    int count = 0;
    
    for(CBService * service in self.blePeripheral.services){
        DLog(@"service %@,%@",[ service.UUID UUIDString],service);
        count++;
    }
    
    return count;
}







@end
