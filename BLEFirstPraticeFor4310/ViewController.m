//
//  ViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/9/25.
//

#import "ViewController.h"
#import "Convert4310Information.h"
#import "cellData.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myCBCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    NSLog(@"AfterCM");
    
    _StoredDevices = [[NSMutableArray alloc] init];
    
    _DevicesInformation = [[NSMutableArray alloc] init];
}

-(CGSize)
collectionView          :(UICollectionView *) collectionView
layout                  :(UICollectionViewLayout *) collectionViewLayout
sizeForItemAtIndexPath  :(NSIndexPath *) indexPath {
    CGSize size;
    size.width = 200;
    size.height = 200;
    return size;

}
- (void)
centralManagerDidUpdateState:(CBCentralManager *)central {
    /*
    switch(central.state) {
        case CBManagerStateUnknown:
            NSLog(@"central.state: CBManagerStateUnknown.");
            break;
        case CBManagerStateResetting:
            NSLog(@"central.state: CBManagerStateResetting.");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"central.state: CBManagerStateUnsupported.");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"central.state: CBManagerStateUnauthorized.");
            break;
        case CBManagerStatePoweredOff:
            NSLog(@"central.state: CBManagerStatePoweredOff.");
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"central.state: CBManagerStatePoweredOn.");
            break;
    }
             */
   if(central.state == CBManagerStatePoweredOn) {
       NSLog(@"Power on");
       /**
        opt:nil -> 不會搜尋到已搜尋過的 Devices 這可能導致 Devices 斷線重連時不被搜尋到而無法重連
        opt:CBCentralManagerScanOptionAllowDuplicatesKey -> 會重複搜尋已搜尋過 Device 可以透過這樣讓裝置重連時會被搜尋到
        */
       NSDictionary *opt = [[NSDictionary alloc] init];
       opt = @{
           CBCentralManagerScanOptionAllowDuplicatesKey : @YES
       };
       [_myCBCentralManager scanForPeripheralsWithServices:nil options:opt];
       //[myCBCentralManager connectPeripheral:myCBPeripheral options:nil];
   }
}

// 搜尋附近裝置所得到的所有藍牙裝置
- (void)
        centralManager          :(CBCentralManager *)               central
        didDiscoverPeripheral   :(CBPeripheral *)                   peripheral
        advertisementData       :(NSDictionary<NSString *,id> *)    advertisementData
        RSSI                    :(NSNumber *)                       RSSI {
    //NSLog(@"Discovered %@", peripheral.name);
    
    /**
     篩選出 Device name 為 KS-4310 的裝置
     */
    if([peripheral.name  isEqual: @"KS-4310"]) {
        Boolean Device_Contain = false;
        /**
         判斷新搜尋到的 Device 有沒有在已搜尋到的裝置中
         */
        for(int i = 0;i < [_StoredDevices count];i++) {
            //NSLog(@"getIntoFor");
            NSUUID *device_Identifier = [[[_StoredDevices objectAtIndex:i] getPheripheral] identifier];
            if([device_Identifier isEqual:[peripheral identifier]]) {
                NSLog(@"device_Identifier: %@", device_Identifier);
                Device_Contain = true;
                break;
            }
        }
        /**
         如果 StoredDevices 中不包含新搜尋到的 Device
         也就是說是正常狀況
         */
        // 如果 StoredDevices 中不包含新搜尋到的 Device
        if(Device_Contain == false) {
            NSLog(@"device_Identifier2: %@", [peripheral identifier]);
            cellData *CD = [[cellData alloc] init];
            [CD addObj:peripheral nowCharacteristic:nil previousCharacteristic:nil nowBabyInformation:nil previousBabyInformation:nil];
            [_StoredDevices addObject:CD];
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_StoredDevices count] - 2 inSection:0];
            NSLog(@"indexPath: %@", indexPath);
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            [indexPaths addObject:indexPath];
            
            //[_myCollectionView reloadItemsAtIndexPaths:indexPaths];
             
            /*
            [UIView performWithoutAnimation:^{
                [_myCollectionView reloadItemsAtIndexPaths:indexPaths];
            }];
             */
            [UIView performWithoutAnimation:^{
                [_myCollectionView reloadItemsAtIndexPaths:indexPaths];
            }];
            
            NSLog(@"size of StoredDevice: %lu", [_StoredDevices count]);
            [_myCBCentralManager connectPeripheral:peripheral options:nil];
        }
        /*
        NSLog(@"Wow. It's %@", peripheral.name);
        
        self.myCBPeripheral = peripheral;

        [self.DevicesInfor addObject:self.myCBPeripheral];
        
        NSLog(@"name: %@", [peripheral name]);
        NSLog(@"identifier: %@", [peripheral identifier]);
        
        ScannedData *SD = [[ScannedData alloc] init];
        [SD setCellValue:[peripheral name]
        deviceIdentifier:[peripheral identifier]];
        [_StoredDevices addObject:SD];
        
        NSLog(@"SizeOfSD: %lu", [_StoredDevices count]);
        
        
        //[MA addObject:[self.myCBPeripheral services]];
                
        //self.myCBPeripheral = peripheral;
        [_myCBCentralManager connectPeripheral:peripheral options:nil];
        */
    }
    //NSLog(@"Services: %@",peripheral.services);
    //NSUInteger ServiceCount = peripheral.services.count;
    /*
    for(NSUInteger i = 0;i < ServiceCount;i++) {
        [peripheral.services indexOfObject:0];
        NSLog(@"Service Strint: %@", ServiceStr);
    }
     */
}

- (void)
        centralManager          :(CBCentralManager *)               central
        didConnectPeripheral    :(CBPeripheral *)                   peripheral {
    
    cellData *CD = [[cellData alloc] init];
    NSLog(@"peripheral 1st: %@", peripheral);
    for(int i = 0;i < [_StoredDevices count];i++) {
        NSUUID *stored_Identifier = [[[_StoredDevices objectAtIndex:i] getPheripheral] identifier];
        NSUUID *now_Identifier = [peripheral identifier];
        if([stored_Identifier isEqual:now_Identifier]) {
            NSLog(@"DUPLICATED");
            
            [CD addObj                  :peripheral
                nowCharacteristic       :[[_StoredDevices objectAtIndex:i] getNowCharacteristic]
                previousCharacteristic  :[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]
                nowBabyInformation      :[[_StoredDevices objectAtIndex:i] getNowBabyInformation]
                previousBabyInformation :[[_StoredDevices objectAtIndex:i] getPreviousBabyInformation]];
            
            [_StoredDevices replaceObjectAtIndex:i withObject:CD];
        }
    }
    
    NSLog(@"didConn");
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
    
    /*
    //[_StoredDevices addObject:peripheral];
    NSLog(@"name: %@", peripheral.name);
    NSLog(@"identifier: %@", peripheral.identifier);
    NSLog(@"Peripheral: %@", peripheral);
    _services = [peripheral services];
    NSLog(@"_services: %@", _services);
    NSLog(@"Service size: %lu", (unsigned long)[[peripheral services] count]);
    for(int i = 0;i < [_services count]; i++) {
        CBService* service = [_services objectAtIndex:i];
        NSLog(@"UUID: %@", [service UUID]);
    }
     */
}

/**
 當發現 service 時會 call 這個 function
 */
- (void)     peripheral              :(CBPeripheral *)   peripheral
             didDiscoverServices     :(NSError *)        error {
    NSLog(@"peripheralSecond: %@", peripheral);
    NSLog(@"Find Service");
    for(int i = 0;i < [_StoredDevices count];i++) {
        if([[[[_StoredDevices objectAtIndex:i] getPheripheral]identifier] isEqual:[peripheral identifier]]) {
            cellData *CD = [[cellData alloc] init];
            [CD addObj                  :peripheral
                nowCharacteristic       :[[_StoredDevices objectAtIndex:i] getNowCharacteristic]
                previousCharacteristic  :[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]
                nowBabyInformation      :[[_StoredDevices objectAtIndex:i] getNowBabyInformation]
                previousBabyInformation :[[_StoredDevices objectAtIndex:i] getPreviousBabyInformation]];
            
            [_StoredDevices replaceObjectAtIndex:i withObject:CD];
            
            break;
        }
    }
    
    NSLog(@"services: %@", [peripheral services]);
    /**
     0 為 Device Information
     1 不確定
     2 為 FFF0 所在的位置 也就是放 Bluetooth 資訊的位置
     */
    [peripheral discoverCharacteristics:nil forService:[[peripheral services] objectAtIndex:2]];
}

/**
當發現 characteristic 時會 call 這個 function
 */
- (void)        peripheral                              :(CBPeripheral *)   peripheral
                didDiscoverCharacteristicsForService    :(CBService *)      service
                error                                   :(NSError *)        error {
    NSLog(@"getCharacteristic");
    
    NSLog(@"Characteristic:  %@", [service characteristics]);
    //[[[service characteristics] objectAtIndex:0] set];
    /**
     notify 剛進來的 characteristic.
     因為 Device 回傳的資訊來自於FFF1 而 FFF1 在 service 中的 index 為 0
     因此設為 0
     */
    CBCharacteristic *CBChar = [[service characteristics] objectAtIndex:0];
    [peripheral setNotifyValue:true forCharacteristic:CBChar];
}

/**
 每次 characteristic 上傳時都會 call 這個 function
 也就是說每次 Device 回傳資訊時都會跑一次這個 function
 */
- (void)    peripheral                          :(CBPeripheral *)       peripheral
            didUpdateValueForCharacteristic     :(CBCharacteristic *)   characteristic
            error                               :(NSError *)            error {
    //NSLog(@"updateValue");
    
    for(int i = 0;i < [_StoredDevices count];i++) {
        NSUUID *stored_Identifier = [[[_StoredDevices objectAtIndex:i] getPheripheral] identifier];
        NSUUID *now_Identifier = [peripheral identifier];
        if([stored_Identifier isEqual:now_Identifier]) {
            cellData *CD = [[cellData alloc] init];
            NSData *characteristic_Value = [characteristic value];
            NSString *characteristic_Str = [self getHEX:characteristic_Value];
            NSString *cut_Characteristic_Str = [self getSubString:characteristic_Str length:2 location:0];
            
            if([cut_Characteristic_Str isEqual:@"04"]) {
                [CD addObj                  :peripheral
                    nowCharacteristic       :[[_StoredDevices objectAtIndex:i] getNowCharacteristic]
                    previousCharacteristic  :[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]
                    nowBabyInformation      :characteristic
                    previousBabyInformation :[[_StoredDevices objectAtIndex:i] getNowBabyInformation]];
                [_StoredDevices replaceObjectAtIndex:i withObject:CD];
                
                NSLog(@"sizeOfSD: %lu", (unsigned long)[_StoredDevices count]);
                NSLog(@"char_nice:%@", [characteristic value]);
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                [indexPaths addObject:indexPath];
                
                
                [UIView performWithoutAnimation:^{
                    [_myCollectionView reloadItemsAtIndexPaths:indexPaths];
                }];
                 
                break;
            }
            else if ([cut_Characteristic_Str isEqual:@"05"]) {
                break;
            }
            else {

                
                [CD addObj                  :peripheral
                    nowCharacteristic       :characteristic
                    previousCharacteristic  :[[_StoredDevices objectAtIndex:i] getNowCharacteristic]
                    nowBabyInformation      :[[_StoredDevices objectAtIndex:i] getNowBabyInformation]
                    previousBabyInformation :[[_StoredDevices objectAtIndex:i] getPreviousBabyInformation]];
                [_StoredDevices replaceObjectAtIndex:i withObject:CD];
                
                NSLog(@"sizeOfSD: %lu", (unsigned long)[_StoredDevices count]);
                NSLog(@"char_nice:%@", [characteristic value]);
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                [indexPaths addObject:indexPath];
                
                [UIView performWithoutAnimation:^{
                    [_myCollectionView reloadItemsAtIndexPaths:indexPaths];
                }];
                
                break;
            }
            break;
        }
    }
    NSLog(@"char2: %@",[[[[[peripheral services] objectAtIndex:2] characteristics] objectAtIndex:0] value]);
    
    NSLog(@"char: %@", [characteristic value] );
    NSData *Data = [characteristic value];
    
    Convert4310Information *convert4310Infor = [[Convert4310Information alloc] init];
    NSLog(@"Battery: %lu", (unsigned long)[convert4310Infor getBattery_Volume:Data]);
    
}
- (IBAction)
    ReadFirstObjInfor   :(id)           sender
    forEvent            :(UIEvent *)    event {
    CBPeripheral *peri = [[_StoredDevices objectAtIndex:0] getPheripheral];
    CBService *ser = [[peri services] objectAtIndex:2];
    CBCharacteristic *chara = [[ser characteristics] objectAtIndex:2];
    NSLog(@"UUID: %@", [chara UUID]);
    
    /**
     wirte to get information setting in device.
     */
    const uint8_t bytes[] = {0x04};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [peri writeValue:data forCharacteristic:chara type:CBCharacteristicWriteWithResponse];
    //CBCharacteristic *CBChar = [[peri characteristics] objectAtIndex:0];
}

-(void)     centralManager          :(CBCentralManager *)       central
            didDisconnectPeripheral :(CBPeripheral *)           peripheral
            error                   :(NSError *)                error {
    NSLog(@"DisConnected");
    for(int i = 0; i < [_StoredDevices count];i++) {
        NSUUID *Stored_UUID = [[[_StoredDevices objectAtIndex:i] getPheripheral] identifier];
        
        if([Stored_UUID isEqual:[peripheral identifier]]) {
            [_StoredDevices removeObjectAtIndex:i];
            break;
        }
    }
}


- (NSInteger)
collectionView          :(UICollectionView *)   collectionView
numberOfItemsInSection  :(NSInteger)            section {
    return [_StoredDevices count];
}

- (__kindof UICollectionViewCell *)
collectionView          :(UICollectionView *)   collectionView
cellForItemAtIndexPath  :(NSIndexPath *)        indexPath {
    
    __kindof UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                     forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    cellData *CD = [[cellData alloc] init];
    NSLog(@"indexPathItem:%ld", (long)[indexPath item]);
    CD = [_StoredDevices objectAtIndex:[indexPath item]];
    NSData *characteristic_Data = [[CD getNowCharacteristic] value];
    NSString *characteristic_Str = [self getHEX:[[CD getNowCharacteristic] value]];
    NSLog(@"characteristic_Str_Length: %lu", (unsigned long)[characteristic_Str length]);
    NSLog(@"characteristic_Str: %@", characteristic_Str);
    NSLog(@"characteristic_Str_Not_Hex: %@", characteristic_Data);
    if([characteristic_Str length] > 2) {
        NSLog(@"LargerThan2");
        NSString *cut_Characteristic_Str = [self getSubString:characteristic_Str length:2 location:0];
        if([cut_Characteristic_Str isEqual:@"00"]) {
            for(int i = 0;i < 3;i++) {
                UILabel *lable = [cell viewWithTag:i + 1];
                switch (i + 1) {
                    case 1: {
                        UILabel *lable = [cell viewWithTag:i + 1];
                        lable.textColor = [UIColor redColor];
                        Convert4310Information *convert_Characteristic = [[Convert4310Information alloc] init];
                        float T1 = [convert_Characteristic getTemperature_1:characteristic_Data];
                        NSString* T1_String = [[NSString alloc] initWithFormat:@"%0.1f", T1];
                        NSLog(@"T1_String: %@", T1_String);
                        
                        lable.text = T1_String;
                        lable.adjustsFontSizeToFitWidth = YES;
                        break;
                        
                    }
                    case 2: {
                        UILabel *lable = [cell viewWithTag:i + 1];
                        lable.textColor = [UIColor blueColor];
                        Convert4310Information *convert_Characteristic = [[Convert4310Information alloc] init];

                        NSUInteger Bat = [convert_Characteristic getBattery_Volume:characteristic_Data];
                        NSString* Bat_String = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)Bat];
                        
                        lable.text = Bat_String;
                        break;
                    }
                    case 3: {
                        UILabel *lable = [cell viewWithTag:i + 1];
                        lable.textColor = [UIColor brownColor];
                        
                        //lable.text = [CD getThirdParameter];
                        break;
                    }
                    case 4: {
                        UITextField *name = [cell viewWithTag:i+1];
                        name.adjustsFontSizeToFitWidth = YES;
                        name.minimumFontSize = 0;
                    }
                }
            }
        }
        else if([cut_Characteristic_Str isEqual:@"04"]) {
            
        }
        else if([cut_Characteristic_Str isEqual:@"05"]) {
            
        }
    }
    
    if([[CD getNowCharacteristic] isEqual:nil]) {
        NSLog(@"It's Nil!");
    }

    
    return cell;
}


/*!
 * @param data : 要被轉換的 NSData
 *  @discussion
 *      將 NSData 轉換為 NSString
 *
 */
- (NSString *)
getHEX:(NSData *)data
{
    const unsigned char *dataBytes = [data bytes];
    NSMutableString *ret = [NSMutableString stringWithCapacity:[data length] * 2];
    for (int i=0; i < [data length]; ++i)
    [ret appendFormat:@"%02lX", (unsigned long)dataBytes[i]];
    return ret;
}

/*!
 * @param Ori_String : 原本要被切的 String
 * @param Length : 要切的長度
 * @param Location : 要從哪裡開始切
 *  @discussion
 *      切指定長度和位置字串
 *
 */
- (NSString *)
getSubString    : (NSString *) Ori_String
length          : (NSUInteger) Length
location        : (NSUInteger) Location {
    NSRange search_Range;
        search_Range.length = Length;
        search_Range.location = Location;
        NSString *new_String = [Ori_String substringWithRange:search_Range];
    return new_String;
}
@end
