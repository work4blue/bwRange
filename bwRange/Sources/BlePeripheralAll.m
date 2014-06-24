//
//  BlePeripheral.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-21.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "BlePeripheralAll.h"

//#import "bleTransmitMoudelAppDelegate.h"

//================== TransmitMoudel =====================
// TransmitMoudel Receive Data Service UUID
NSString *kReceiveDataServiceUUID                       =@"FFE0";
// TransmitMoudel characteristics UUID
NSString *kReceive05BytesDataCharateristicUUID          =@"FFE1";
NSString *kReceive10BytesDataCharateristicUUID          =@"FFE2";
NSString *kReceive15BytesDataCharateristicUUID          =@"FFE3";
NSString *kReceive20BytesDataCharateristicUUID          =@"FFE4";

// TransmitMoudel Send Data Service UUID
NSString *kSendDataServiceUUID                          =@"FFE5";
// TransmitMoudel characteristics UUID
NSString *kSend05BytesDataCharateristicUUID             =@"FFE6";
NSString *kSend10BytesDataCharateristicUUID             =@"FFE7";
NSString *kSend15BytesDataCharateristicUUID             =@"FFE8";
NSString *kSend20BytesDataCharateristicUUID             =@"FFE9";

@implementation BlePeripheral{
    NSTimer         *autoSendDataTimer;
    UInt16          testSendCount;
}


#pragma mark -
#pragma mark Init
/******************************************************/
//          类初始化                                   //
/******************************************************/
// 初始化蓝牙
-(id)init{
    self = [super init];
    if (self) {
        [self initPeripheralWithSeviceAndCharacteristic];
        [self initPropert];
    }
    return self;
}

-(void)setActivePeripheral:(CBPeripheral *)AP{
    _activePeripheral = AP;
    // 把外设的名字（CBPERIPHECAL 的对象）取出来
    NSString *aname = [[NSString alloc]initWithFormat:@"%@",_activePeripheral.name];
    NSLog(@"aname:%@",aname);
    if (![aname isEqualToString:@"(null)"]) {
        //如果名字不为空，再把它赋值给 blePeriphecal对象的名字。
        _nameString = aname;
    }
    else{
        _nameString =@"Error Name";
    }
    NSString *auuid = [[NSString alloc]initWithFormat:@"%@",_activePeripheral.UUID];
    if (auuid.length >=36) {
        _uuidString = [auuid substringWithRange:NSMakeRange(auuid.length-36,36)];
        NSLog(@"uuidString:%@",_uuidString);
    }
}


-(void)initPeripheralWithSeviceAndCharacteristic{
    // CBPeripheral
//    [_activePeripheral setDelegate:nil];
//    _activePeripheral =nil;
//    // CBService and CBCharacteristic
//    _ReceiveDataService =nil;
//    _Receive05BytesDataCharateristic =nil;
//    _Receive10BytesDataCharateristic =nil;
//    _Receive15BytesDataCharateristic =nil;
//    _Receive20BytesDataCharateristic =nil;
//    _SendDataService =nil;
//    _Send05BytesDataCharateristic =nil;
//    _Send10BytesDataCharateristic =nil;
//    _Send15BytesDataCharateristic =nil;
//    _Send20BytesDataCharateristic =nil;
}

-(void)initPropert{
    // Property
    _staticString =@"Init";
    _currentPeripheralState =blePeripheralDelegateStateInit;
    nPeripheralStateChange
    _connectedFinish =kDisconnected;
    _receiveData =0;
    _sendData = 0;
    _txCounter = 0;
    _rxCounter = 0;
    _ShowStringBuffer = [[NSString alloc]init];
    _AutoSendData =NO;
    
    [autoSendDataTimerinvalidate];
    autoSendDataTimer =nil;
    testSendCount =0;
}

#pragma mark -
#pragma mark Scanning
/****************************************************************************/
/*   Scanning                                    */
/****************************************************************************/
// 按UUID进行扫描
-(void)startPeripheral:(CBPeripheral *)peripheral DiscoverServices:(NSArray *)services{
    if ([peripheral isEqual:_activePeripheral] && [peripheralisConnected]){
        _activePeripheral = peripheral;
        [_activePeripheralsetDelegate:(id<CBPeripheralDelegate>)self];
        [_activePeripheraldiscoverServices:services];
    }
}

-(void)disconnectPeripheral:(CBPeripheral *)peripheral{
    if ([peripheral isEqual:_activePeripheral]){
        // 内存释放
        [selfinitPeripheralWithSeviceAndCharacteristic];
        [selfinitPropert];
    }
}

#pragma mark -
#pragma mark CBPeripheral
/****************************************************************************/
/*                              CBPeripheral  */
/****************************************************************************/
// 扫描服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (!error)
    {
        if ([peripheral isEqual:_activePeripheral]){
            // 新建服务数组
            NSArray *services = [peripheral services];
            if (!services || ![services count])
            {
                NSLog(@"发现错误的服务 %@\r\n", peripheral.services);
            }
            else
            {
                // 开始扫描服务
                _staticString = @"Discover services";
                _currentPeripheralState =blePeripheralDelegateStateDiscoverServices;
                nPeripheralStateChange
                for (CBService *servicesin peripheral.services)
                {
                    NSLog(@"发现服务UUID: %@\r\n", services.UUID);
                    //================== TransmitMoudel =====================// FFE0
                    if ([[services UUID]isEqual:[CBUUIDUUIDWithString:kReceiveDataServiceUUID]])
                    {  //如果该服务的uuid号 是 FFE0， 表示这个服务是用来接收数据的。再把该服务赋给私有变量。
                        
                        // 扫描接收数据服务特征值
                        _ReceiveDataService = services;
                        [peripheraldiscoverCharacteristics:nilforService:_ReceiveDataService];
                    }
                    //================== TransmitMoudel =====================// FFE5
                    else if ([[servicesUUID] isEqual:[CBUUIDUUIDWithString:kSendDataServiceUUID]])
                    {
                        // 扫描发送数据服务特征值
                        _SendDataService = services;
                        [peripheraldiscoverCharacteristics:nilforService:_SendDataService];
                    }
                    //======================== END =========================
                }
            }
        }
    }
}

// 从服务中扫描特征值
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (!error) {
        if ([peripheral isEqual:_activePeripheral]){
            // 开始扫描特征值
            _staticString =@"Discover characteristics";
            //前面一个是发现服务， 这一个是发现特征。。
            _currentPeripheralState =blePeripheralDelegateStateDiscoverCharacteristics;
            nPeripheralStateChange
            // 新建特征值数组
            NSArray *characteristics = [service characteristics];
            CBCharacteristic *characteristic;
            //================== TransmitMoudel =====================// FFE1 FFE2 FFE3 FFE4
            if ([[service UUID]isEqual:[CBUUIDUUIDWithString:kReceiveDataServiceUUID]])
            { //先根据服务的uuid 来判断这个服务是“发送还是接收”服务。再通过for循环判断每个这个服务中的每个特征是什么特征。
                for (characteristic in characteristics)
                {
                    NSLog(@"发现特值UUID: %@\n", [characteristic UUID]);
                    if ([[characteristic UUID] isEqual:[CBUUIDUUIDWithString:kReceive05BytesDataCharateristicUUID]])
                    {
                        _Receive05BytesDataCharateristic = characteristic;
                        // 在这个外设中， 打开 05bytes 这个特征值 的通知功能。
                        [peripheralsetNotifyValue:YESforCharacteristic:characteristic];
                    }
                    else if ([[characteristicUUID] isEqual:[CBUUIDUUIDWithString:kReceive10BytesDataCharateristicUUID]])
                    {
                        _Receive10BytesDataCharateristic = characteristic;
                        [peripheralsetNotifyValue:YESforCharacteristic:characteristic];
                    }
                    else if ([[characteristicUUID] isEqual:[CBUUIDUUIDWithString:kReceive15BytesDataCharateristicUUID]])
                    {
                        _Receive15BytesDataCharateristic = characteristic;
                        [peripheralsetNotifyValue:YESforCharacteristic:characteristic];
                    }
                    else if ([[characteristicUUID] isEqual:[CBUUIDUUIDWithString:kReceive20BytesDataCharateristicUUID]])
                    {
                        _Receive20BytesDataCharateristic = characteristic;
                        [peripheralsetNotifyValue:YESforCharacteristic:characteristic];
                    }
                }
            }
            //================== TransmitMoudel =====================// FFE6 FFE7 FFE8 FFE9
            else if ([[serviceUUID] isEqual:[CBUUIDUUIDWithString:kSendDataServiceUUID]])
            {
                for (characteristic in characteristics)
                {
                    NSLog(@"发现特值UUID: %@\n", [characteristic UUID]);
                    if ([[characteristic UUID] isEqual:[CBUUIDUUIDWithString:kSend05BytesDataCharateristicUUID]])
                    {
                        _Send05BytesDataCharateristic = characteristic;
                    }
                    else if ([[characteristicUUID] isEqual:[CBUUIDUUIDWithString:kSend10BytesDataCharateristicUUID]])
                    {
                        _Send10BytesDataCharateristic = characteristic;
                    }
                    else if ([[characteristicUUID] isEqual:[CBUUIDUUIDWithString:kSend15BytesDataCharateristicUUID]])
                    {
                        _Send15BytesDataCharateristic = characteristic;
                    }
                    else if ([[characteristicUUID] isEqual:[CBUUIDUUIDWithString:kSend20BytesDataCharateristicUUID]])
                    {
                        _Send20BytesDataCharateristic = characteristic;
                        
                        // 完成连接
                        [selfFinishConnected];
                        //如果是“发送”特征，没有调用  [peripheral setNotifyValue:YES forCharacteristic:characteristic]; 这个函数，到了 20BYTES 这个特征的时候， 调用   [self FinishConnected];表示连接完成。。
                    }
                }
            }
            //======================== END =========================
        }
    }
}

// 更新特征值  第三个是更新特征。。。
// 先判断有没有 报错， 再判断传进来的外设跟私有变量中的外设是否一致，是的话，再判断 传进来的这个特征值是否为”四种接收类型中的一种“，如果是， 把这个特征的值赋值给NSDATA REVICEDATE (私有变量)，再调用[self receiveData:_receiveData]，接收数据 的函数。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if ([error code] ==0) {
        if ([peripheral isEqual:_activePeripheral]){
            //===================== AntiLost ========================FE21、FE22、FE23、FE24、FE25
            if ([characteristic isEqual:_Receive05BytesDataCharateristic])
            {
                //if (characteristic.value.length == TRANSMIT_05BYTES_DATA_LENGHT) {
                _receiveData = characteristic.value;
                [selfreceiveData:_receiveData];
                //}
            }
            // 接收温湿度数据
            else if ([characteristicisEqual:_Receive10BytesDataCharateristic])
            {
                //if (characteristic.value.length == TRANSMIT_10BYTES_DATA_LENGHT) {
                _receiveData = characteristic.value;
                [selfreceiveData:_receiveData];
                //}
            }
            // 读取名字
            else if ([characteristicisEqual:_Receive15BytesDataCharateristic])
            {
                //if (characteristic.value.length == TRANSMIT_15BYTES_DATA_LENGHT) {
                _receiveData = characteristic.value;
                [selfreceiveData:_receiveData];
                //}
            }
            
            else if ([characteristicisEqual:_Receive20BytesDataCharateristic])
            {
                //if (characteristic.value.length == TRANSMIT_20BYTES_DATA_LENGHT) {
                _receiveData = characteristic.value;
                [selfreceiveData:_receiveData];
                //}
            }
            //======================== END =========================
        }
    }
    else{
        NSLog(@"参数更新出错: %d",[error code]);
    }
}

#pragma mark -
#pragma mark read/write/notification
/******************************************************/
//          读写通知等基础函数                           //
/******************************************************/
// 写数据到特征值
-(void) writeValue:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic data:(NSData *)data{
    if ([peripheral isEqual:_activePeripheral] && [peripheralisConnected])
    {
        if (characteristic != nil) {
            NSLog(@"成功写数据到特征值: %@数据:%@\n", characteristic.UUID, data);
            [peripheral writeValue:dataforCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

// 从特征值读取数据
-(void) readValue:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic{
    if ([peripheral isEqual:_activePeripheral] && [peripheralisConnected])
    {
        if (characteristic != nil) {
            NSLog(@"成功从特征值:%@读数据\n", characteristic);
            [peripheralreadValueForCharacteristic:characteristic];
        }
    }
}

// 发通知到特征值
-(void) notification:(CBPeripheral *)peripheral characteristicUUID:(CBCharacteristic *)characteristic state:(BOOL)state{
    if ([peripheral isEqual:_activePeripheral] && [peripheralisConnected])
    {
        if (characteristic != nil) {
            NSLog(@"成功发通知到特征值: %@\n", characteristic);
            [peripheralsetNotifyValue:state forCharacteristic:characteristic];
            //- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error 跟这个函数中的方法一样，如果 是”接收“特征，则设为YES, 不过这里的STATE 根据传进来的值来赋值。 通知这个外设的某个特征的 状态是”开“还是”关“。
        }
    }
}

#pragma mark -
#pragma mark Set property
/******************************************************/
//              BLE属性操作函数                          //
/******************************************************/
-(void)FinishConnected{
    // 更新标志
    _connectedFinish =YES;
    _staticString =@"Connected finish";
    _currentPeripheralState =blePeripheralDelegateStateKeepActive;
    nPeripheralStateChange
    NSLog(@"连接完成\n");
}

-(void)receiveData:(NSData *)data{
    Byte dataLength = data.length;
    // 接收计数加1
    _rxCounter++;
    
    Byte data2Byte[dataLength];
    //把传进来的数据放到这个字节类型的变量中。再把这个字节类型变量中的数据转成字符串。再把这个字符串添加到显示缓存中
    [datagetBytes:&data2Byte length:dataLength];
    NSString *dataASCII = [[NSStringalloc]initWithBytes:data2Bytelength:dataLength encoding:NSASCIIStringEncoding];
    [selfaddReceiveASCIIStringToShowStringBuffer:dataASCII];
    _staticString = [[NSStringalloc]initWithFormat:@"Receive:%@",dataASCII];
    nUpdataShowStringBuffer
}

-(void)addReceiveASCIIStringToShowStringBuffer:(NSString *)aString{
    //在接到的数据前面叠加"PC:"后面加入换行后添加到显示缓存
    NSString *rxASCII = [[NSStringalloc]initWithFormat:@"        PC:"];
    rxASCII = [rxASCIIstringByAppendingString:aString];
    rxASCII = [rxASCIIstringByAppendingString:@"\n"];
    _ShowStringBuffer = [_ShowStringBufferstringByAppendingString:rxASCII];
}

-(void)setSendData:(NSData *)data{
    Byte dataLength = data.length;
    
    if ((dataLength ==TRANSMIT_05BYTES_DATA_LENGHT) || (dataLength ==TRANSMIT_10BYTES_DATA_LENGHT) || (dataLength ==TRANSMIT_15BYTES_DATA_LENGHT) || (dataLength ==TRANSMIT_20BYTES_DATA_LENGHT)) {
        // 发送计数加1
        _txCounter++;
        
        Byte data2Byte[dataLength];
        [datagetBytes:&data2Byte length:dataLength];
        NSString *dataASCII = [[NSStringalloc]initWithBytes:data2Bytelength:dataLength encoding:NSASCIIStringEncoding];
        if (dataLength ==TRANSMIT_05BYTES_DATA_LENGHT)
        { //把数据写到特征值中
            [selfwriteValue:_activePeripheralcharacteristic:_Send05BytesDataCharateristicdata:data];
        }
        elseif (dataLength ==TRANSMIT_10BYTES_DATA_LENGHT)
        {
            [selfwriteValue:_activePeripheralcharacteristic:_Send10BytesDataCharateristicdata:data];
        }
        elseif (dataLength ==TRANSMIT_15BYTES_DATA_LENGHT)
        {
            [selfwriteValue:_activePeripheralcharacteristic:_Send15BytesDataCharateristicdata:data];
        }
        elseif (dataLength ==TRANSMIT_20BYTES_DATA_LENGHT)
        {
            [selfwriteValue:_activePeripheralcharacteristic:_Send20BytesDataCharateristicdata:data];
        }
        [selfaddSendASCIIStringToShowStringBuffer:dataASCII];
        _staticString = [[NSStringalloc]initWithFormat:@"Send:%@",dataASCII];
        nUpdataShowStringBuffer
    }
}

-(void)addSendASCIIStringToShowStringBuffer:(NSString *)aString{
    //在发送的数据前面叠加"IP:"后面加入换行后添加到显示缓存
    NSString *txASCII = [[NSStringalloc]initWithFormat:@"IP:"];
    txASCII = [txASCIIstringByAppendingString:aString];
    txASCII = [txASCIIstringByAppendingString:@"\n"];
    _ShowStringBuffer = [_ShowStringBufferstringByAppendingString:txASCII];
}

-(void)setAutoSendData:(BOOL)AutoSendData{
    if (AutoSendData == YES) {
        // 自动发送测试数据s
        if (autoSendDataTimer !=nil) {
            [autoSendDataTimerinvalidate];
        }
        autoSendDataTimer = [NSTimerscheduledTimerWithTimeInterval:kAutoSendTestDataTimertarget:selfselector:@selector(AutoSendDataEvent)userInfo:nilrepeats:YES];
    }
    else{
        [autoSendDataTimerinvalidate];
        autoSendDataTimer =nil;
        testSendCount =0;
    }
}

-(void)AutoSendDataEvent{
    // 发送数据自动加1
    if (_activePeripheral.isConnected ==YES) {
        testSendCount++;
        NSString *txAccString = [[NSStringalloc]initWithFormat:@"%05d",testSendCount];
        NSString *test20ByteASCII = [[NSStringalloc]initWithFormat:@"ABCDEFGHIJKLMNO"];
        test20ByteASCII = [test20ByteASCIIstringByAppendingString:txAccString];
        [selfsetSendData:[test20ByteASCIIdataUsingEncoding:NSASCIIStringEncoding]];
    }
    else{
        [autoSendDataTimerinvalidate];
        autoSendDataTimer =nil;
        testSendCount =0;
        
        _connectedFinish =kDisconnected;
        _AutoSendData =NO;
        
        _staticString =@"Disconnect";
        _currentPeripheralState =blePeripheralDelegateStateInit;
        nPeripheralStateChange
    }
}

@end
