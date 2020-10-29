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
@property (readonly, assign) NSUInteger MovementScanTime;
@property (readonly, assign) float HighTemperature;
@property (readonly, assign) float LowTemperature;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myCBCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    NSLog(@"AfterCM");
    
    _StoredDevices = [[NSMutableArray alloc] init];
    
    _DevicesInformation = [[NSMutableArray alloc] init];
    
    _MovementScanTime = 15;
    
    _HighTemperature = 27;
    
    _LowTemperature = 25;
}
/*
-(CGSize)
collectionView          :(UICollectionView *) collectionView
layout                  :(UICollectionViewLayout *) collectionViewLayout
sizeForItemAtIndexPath  :(NSIndexPath *) indexPath {
    //NSUInteger myWidth = _myCollectionView.bounds.size.width / 2 - 5;
    //NSUInteger myHeight = _myCollectionView.bounds.size.height / 2 - 5;
    
    NSLog(@"size_width: %f", _myCollectionView.bounds.size.width);
    NSLog(@"size_height: %f", _myCollectionView.bounds.size.height);
    CGSize size;
    size.width = _myCollectionView.bounds.size.width;
    size.height = _myCollectionView.bounds.size.height;
    return size;

}
*/
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
            [CD addObj                  :peripheral
                nowCharacteristic       :nil
                previousCharacteristic  :nil
                nowBabyInformation      :nil
                CurrentCharacteristic   :nil
                storedMovementState     :nil
                deviceName              :nil
                deviceID                :nil
                deviceSex               :nil];
            
            [_StoredDevices addObject:CD];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_StoredDevices count] - 2 inSection:0];
            NSLog(@"indexPath: %@", indexPath);
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            [indexPaths addObject:indexPath];
            
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
                CurrentCharacteristic   :[[_StoredDevices objectAtIndex:i] getCurrentCharacteristic]
                storedMovementState     :[[_StoredDevices objectAtIndex:i] getStoredMovementState]
                deviceName              :[[_StoredDevices objectAtIndex:i] getDeviceName]
                deviceID                :[[_StoredDevices objectAtIndex:i] getDeviceID]
                deviceSex               :[[_StoredDevices objectAtIndex:i] getDeviceSex]];
            
            [_StoredDevices replaceObjectAtIndex:i withObject:CD];
            
            break;
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
                CurrentCharacteristic   :[[_StoredDevices objectAtIndex:i] getCurrentCharacteristic]
                storedMovementState     :[[_StoredDevices objectAtIndex:i] getStoredMovementState]
                deviceName              :[[_StoredDevices objectAtIndex:i] getDeviceName]
                deviceID                :[[_StoredDevices objectAtIndex:i] getDeviceID]
                deviceSex               :[[_StoredDevices objectAtIndex:i] getDeviceSex]];
            
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
    Convert4310Information *convert_Characteristic = [[Convert4310Information alloc] init];
    
    StringProcessFunc *str_Process_Func = [[StringProcessFunc alloc] init];
    
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    cellData *CD = [[cellData alloc] init];
    
    for(int i = 0;i < [_StoredDevices count];i++) {
        NSUUID *stored_Identifier = [[[_StoredDevices objectAtIndex:i] getPheripheral] identifier];
        NSUUID *now_Identifier = [peripheral identifier];
        
        if([stored_Identifier isEqual:now_Identifier]) {
            // 如果是第一次進如則先 write 04 讓 device回傳device內資訊
            // 如果 getNowCharacteristic 還是 nil 的話
            // 或者接收到 0x0555aa (接收到 0x05 時 update 的值 length = 3)
            if(![[_StoredDevices objectAtIndex:i] getNowCharacteristic] ||
               [[characteristic value] length] == 3) {
                [self write04ToKS4310:_StoredDevices
                                index:i];
            }
            
            NSData *characteristic_Value = [characteristic value];
            NSString *characteristic_Str = [CalculateFunc getHEX:characteristic_Value];
            
            NSString *cut_Characteristic_Str = [str_Process_Func getSubString   :characteristic_Str
                                                                 length         :2
                                                                 location       :0];
            
            if([cut_Characteristic_Str isEqual:@"04"]) {
                
                // Device Name
                NSString *Device_Name_Str = [convert_Characteristic getDeviceName:[characteristic value]];
                // Device ID
                NSString *Device_ID_Str = [convert_Characteristic getDeviceID:[characteristic value]];
                // Device Sex
                NSString *Device_Sex_Str = [convert_Characteristic getDeviceSex:[characteristic value]];
                
                // 儲存資料至 _StoradDevices
                [CD addObj                  :peripheral
                    nowCharacteristic       :[[_StoredDevices objectAtIndex:i] getNowCharacteristic]
                    previousCharacteristic  :[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]
                    nowBabyInformation      :[characteristic value]
                    CurrentCharacteristic   :[characteristic value]
                    storedMovementState     :[[_StoredDevices objectAtIndex:i] getStoredMovementState]
                    deviceName              :Device_Name_Str
                    deviceID                :Device_ID_Str
                    deviceSex               :Device_Sex_Str];
                
                [_StoredDevices replaceObjectAtIndex:i withObject:CD];
                
                // reloadItems
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                [indexPaths addObject:indexPath];
                
                [UIView performWithoutAnimation:^{
                    [_myCollectionView reloadItemsAtIndexPaths:indexPaths];
                }];
                
                break;
            }
            else if ([cut_Characteristic_Str isEqual:@"00"]) { 
                NSMutableArray *now_Stored_Movement_State = [[NSMutableArray alloc] init];
                
                NSString *setPassword = [CalculateFunc getHEX:[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]] ;
                if(setPassword.length >= 8) {
                    setPassword = [str_Process_Func getSubString    :   setPassword
                                                    length          :   8
                                                    location        :   0];
                }
                
                if([[_StoredDevices objectAtIndex:i] getPreviousCharacteristic] != nil && [setPassword isEqual:@"0000F8FA"]) {
                    now_Stored_Movement_State = [self getMovementStatus         :   characteristic
                                                      nowStoredMovementState    :   now_Stored_Movement_State
                                                      index                     :   i];
                }

                /**
                 * 儲存至全域 NSMutableArray StoredDevices
                 */
                
                [CD addObj :peripheral
                    nowCharacteristic       :[characteristic value]
                    previousCharacteristic  :[[_StoredDevices objectAtIndex:i] getNowCharacteristic]
                    nowBabyInformation      :[[_StoredDevices objectAtIndex:i] getNowBabyInformation]
                    CurrentCharacteristic   :[characteristic value]
                    storedMovementState     :now_Stored_Movement_State
                    deviceName              :[[_StoredDevices objectAtIndex:i] getDeviceName]
                    deviceID                :[[_StoredDevices objectAtIndex:i] getDeviceID]
                    deviceSex               :[[_StoredDevices objectAtIndex:i] getDeviceSex]];
                
                
                [_StoredDevices replaceObjectAtIndex:i withObject:CD];
                
                /**
                 * 叫 collection view 刷新指定的 index
                 */
                
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
}
/**
    按按鍵寫入04
 */
/*
- (IBAction)
    ReadFirstObjInfor   :(id)           sender
    forEvent            :(UIEvent *)    event {
    CBPeripheral *peri = [[_StoredDevices objectAtIndex:0] getPheripheral];
    CBService *ser = [[peri services] objectAtIndex:2];
    CBCharacteristic *chara = [[ser characteristics] objectAtIndex:2];
    NSLog(@"UUID: %@", [chara UUID]);
    
    //wirte to get information setting in device.
 
    const uint8_t bytes[] = {0x04};
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [peri writeValue:data forCharacteristic:chara type:CBCharacteristicWriteWithResponse];
    //CBCharacteristic *CBChar = [[peri characteristics] objectAtIndex:0];
}
*/

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
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    StringProcessFunc *str_Procecss_Func = [[StringProcessFunc alloc] init];
    
    __kindof UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                     forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    cellData *CD = [[cellData alloc] init];
    
    CD = [_StoredDevices objectAtIndex:[indexPath row]];
    
    NSLog(@"ROWNUMBER:%ld", (long)[indexPath row]);
    
    NSData *characteristic_Data = [CD getCurrentCharacteristic];
    NSString *characteristic_Str = [CalculateFunc getHEX:characteristic_Data];
    
    /**
     *  依據前兩碼為00, 04, 05
     *  判斷寫入的目的
     *  00 : 平時接收 Device 上傳的資訊
     *  04 : 接收 Device 內部記憶體的資訊
     *  05 : 上傳 Device 內部記憶體的資訊
     */
    if([characteristic_Str length] > 2) {
        NSString *cut_Characteristic_Str = [str_Procecss_Func getSubString  :   characteristic_Str
                                                              length        :   2
                                                              location      :   0];
        
        if([cut_Characteristic_Str isEqual:@"00"]) {
            NSLog(@"Clickclick");
            [self setDeviceReturnInformation    : cell
                  IndexPath                     : indexPath];
             
            [self setDeviceInformation  :cell
                  IndexPath             :indexPath];
        }
        
        else if([cut_Characteristic_Str isEqual:@"04"]) {
            
            NSLog(@"Run04");
             
        }
        
        else if([cut_Characteristic_Str isEqual:@"05"]) {
            NSLog(@"Run05");
        }
    }
    
    if([[CD getNowCharacteristic] isEqual:nil]) {
        NSLog(@"It's Nil!");
    }

    
    return cell;
}

/**
 * 當點擊指定item時執行此
 */
-(void)
collectionView          :(UICollectionView *)   collectionView
didSelectItemAtIndexPath:(NSIndexPath *)        indexPath {
    
    NSString *Device_Name = [[_StoredDevices objectAtIndex:[indexPath row]] getDeviceName];
    NSString *Device_ID = [[_StoredDevices objectAtIndex:[indexPath row]] getDeviceID];
    NSString *Device_Sex = [[_StoredDevices objectAtIndex:[indexPath row]] getDeviceSex];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                   message:@"This is an alert."
                                   preferredStyle:UIAlertControllerStyleAlert];
     
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Name";
        textField.text = Device_Name;
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"ID";
        textField.text = Device_ID;
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Sex";
        textField.text = Device_Sex;
    }];
    
    // Cancel按鍵的部分
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        NSLog(@"TestTextFromAlert: %@", [[[alert textFields] objectAtIndex:0] text]);
    }];
    
    // OK按鍵的部分
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        
        NSMutableData *Merged_InformationsAgain = [self getWriteStringThroughAlertView:alert];
        
        NSLog(@"Merged_InformationsAgain : %@", Merged_InformationsAgain);
        
        // write 05 和要賦予的裝置資訊
        CBPeripheral *peri = [[self->_StoredDevices objectAtIndex:[indexPath row]] getPheripheral];
        CBService *ser = [[peri services] objectAtIndex:2];
        CBCharacteristic *chara = [[ser characteristics] objectAtIndex:2];
        
        //wirte to get information setting in device.
        [peri writeValue:Merged_InformationsAgain
       forCharacteristic:chara
                    type:CBCharacteristicWriteWithResponse];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)
setMovementImageView    : (UIImageView *)       imageView
movementStatus          : (BOOL)                Movement_Status {
    UIImage *Ima;
    if(Movement_Status) {
        Ima = [UIImage imageNamed:@"list_level_2.png"];
    }
    else {
        Ima = [UIImage imageNamed:@"list_level_4.png"];
    }
    [imageView setImage:Ima];
}

- (void)
setTempoeratureLabel : (UILabel *) textLabel
temperature : (float) Temperature
temperatureStatus : (NSInteger) Temp_Status {
    NSString *T1_String = [[NSString alloc] initWithFormat:@"%0.1f", Temperature];
    switch (Temp_Status) {
            /**
             * 高於發燒溫度視為發燒 轉為紅字
             */
        case 1:
            textLabel.textColor = [UIColor redColor];
            break;
            /**
             * 高於冷冷溫度和低於發燒溫度視為正常 轉為橘色
             */
        case 2:
            textLabel.textColor = [UIColor brownColor];
            break;
            /**
             * 低於冷冷溫度視為冷冷 轉為藍色
             */
        case 3:
            textLabel.textColor = [UIColor blueColor];
            break;
    }
    
    textLabel.text = T1_String;
    textLabel.adjustsFontSizeToFitWidth = YES;
}

- (BOOL)
    getMovementNormal       : (NSMutableArray *)    Movement_Recode_Array
    ScanTime                : (NSUInteger)          ScanTime {
    /**
     * 檢查時間內如果連續三分之一呼吸不正常則設 Movement Abnormal = true;
     */
    BOOL Continue_Normal = false;
    NSUInteger Total_Continue_Normal_Count = 0;
    
    NSUInteger ContinueScanLength = ScanTime / 3;
    
    if([Movement_Recode_Array count] > ContinueScanLength) {
        for(NSUInteger j = [Movement_Recode_Array count] - 1; j >= [Movement_Recode_Array count] - ContinueScanLength;j--) {
            if([[Movement_Recode_Array objectAtIndex:j] isEqualToNumber:[NSNumber numberWithBool:true]]) {
                Total_Continue_Normal_Count++;
            }
            else {
                Total_Continue_Normal_Count = 0;
                break;
            }
            if(Total_Continue_Normal_Count >= ContinueScanLength) {
                Continue_Normal = true;
            }
        }
    }
    /**
     * 檢查時間內如果有超過三分之二呼吸不正常則設為 Movement Abnormal = true;
     */
    // TODO: 修改為每次進入再增加而不是每次都從零開始重算
    
    BOOL Total_Normal = false;
    NSUInteger Total_Normal_Count = 0;
    
    for(NSUInteger j = 0; j < [Movement_Recode_Array count];j++) {
        if([[Movement_Recode_Array objectAtIndex:j] isEqualToNumber:[NSNumber numberWithBool:true]]) {
            Total_Normal_Count++;
        }
    }
    if(Total_Normal_Count >= ScanTime * 2 / 3) {
        Total_Normal = true;
    }
    
    if(Continue_Normal && Total_Normal) {
        return true;
    }
    
    else {
        return false;
    }
}

- (NSInteger)
temperatureStatus : (float) Temperature
highTemperature   : (float) HighTemperature
lowTemperature    : (float) LowTemperature {
    if (Temperature > _HighTemperature) {
        return 1;
    }
    else if(Temperature >_LowTemperature) {
        return 2;
    }
    else {
        return 3;
    }
}

- (BOOL)
temperatureNormal : (NSInteger) Temperature_Status {
    switch (Temperature_Status) {
        case 2:
            return true;
            break;
        default:
            return false;
    }
}

- (void)
setBatteryImage : (UIImageView *) ImageView
battery_Volume  : (NSUInteger) Battery_Volume{
    UIImage *Ima;
    if (Battery_Volume >= 75) {
        Ima = [UIImage imageNamed:@"Battery-1-Bak.png"];
    }
    else if (Battery_Volume >= 50) {
        Ima = [UIImage imageNamed:@"Battery-2-Bak.png"];
    }
    else if(Battery_Volume >= 25) {
        Ima = [UIImage imageNamed:@"Battery-3-Bak.png"];
    }
    else {
        Ima = [UIImage imageNamed:@"Battery-4-Bak.png"];
    }
    [ImageView setImage:Ima];
}

- (void)
setDeviceReturnInformation   : (__kindof UICollectionViewCell *)    cell
IndexPath                    : (NSIndexPath *)                      Index_Path {
    
    NSLog(@"setDevicereturnInformation");
    Convert4310Information *convert_Characteristic = [[Convert4310Information alloc] init];
    
    if(cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    cellData *CD = [[cellData alloc] init];
    
    CD = [_StoredDevices objectAtIndex:[Index_Path row]];
    
    NSData *characteristic_Data = [CD getCurrentCharacteristic];
    
    NSLog(@"NSDataCharac:%@", characteristic_Data);
    
    BOOL Movement_Normal = false;
    BOOL Temperature_Normal = false;
    
    for(int i = 1;i <= 4;i++) {
        switch (i) {
                /**
                 * Movement 的燈號判斷
                 */
            case 1: {
                UIImageView *Movement_ImageView = [cell viewWithTag:1];
                
                NSMutableArray *MovementRecordArray = [CD getStoredMovementState];
                
                // 取得移動正常或異常
                BOOL Movement_Normal = [self getMovementNormal :   MovementRecordArray
                                             ScanTime          :   _MovementScanTime];
                
                // 設定移動紅燈或綠燈
                [self setMovementImageView  :Movement_ImageView
                      movementStatus        :Movement_Normal];
                
                break;
            }
                /**
                 * 溫度字串顏色和 string 顯示
                 */
            case 2: {
                UILabel *Temperature_Label = [cell viewWithTag:2];
                
                float T1 = [convert_Characteristic getTemperature_1:characteristic_Data];
                
                NSInteger Temperature_Status;
            
                /**
                 * 取得目前溫度狀況
                 * 1 : 過高
                 * 2 : 正常
                 * 3 : 過低
                 */
                
                Temperature_Status = [self temperatureStatus    :   T1
                                           highTemperature      :   _HighTemperature
                                           lowTemperature       :   _LowTemperature];
                
                // 設定溫度 Label 的溫度和顏色
                
                [self setTempoeratureLabel  :   Temperature_Label
                      temperature           :   T1
                      temperatureStatus     :   Temperature_Status];
                
                Temperature_Normal = [self temperatureNormal:Temperature_Status];
                
                break;
            }
                /**
                 * 顯示裝置電池電量 以25%為區間分為四等份
                 */
            case 3: {
                UIImageView *Battery_ImageView = [cell viewWithTag:3];

                NSUInteger Battery_Volume = [convert_Characteristic getBattery_Volume:characteristic_Data];
                
                // 設定電池圖片
                [self setBatteryImage   : Battery_ImageView
                      battery_Volume    : Battery_Volume];
                
                break;
            }
                
            case 4: {
                UIImageView *Warning_ImageView = [cell viewWithTag:4];
                UIImage *Ima = [UIImage imageNamed:@"baby_card_warning.png"];
                [Warning_ImageView setImage:Ima];
                /**
                 * 當呼吸和溫度都為正常時使警告消失
                 */
                if(Movement_Normal && Temperature_Normal) {
                    [Warning_ImageView setHidden:true];
                }
                else {
                    [Warning_ImageView setHidden:false];
                }
                break;
            }
        }
    }
}

- (NSMutableArray *)
getMovementStatus : (CBCharacteristic*) characteristic
nowStoredMovementState : (NSMutableArray *) now_Stored_Movement_State
index : (NSUInteger) index {
    
        Convert4310Information *convert = [[Convert4310Information alloc] init];
        
        NSInteger Location_X = [convert get_Location_X:[characteristic value]];
        NSInteger Location_Y = [convert get_Location_Y:[characteristic value]];
        NSInteger Location_Z = [convert get_Location_Z:[characteristic value]];
        
        NSData *Previous_Characteristic = [[_StoredDevices objectAtIndex:index] getPreviousCharacteristic];
        
        NSInteger Previous_Location_X = [convert get_Location_X:Previous_Characteristic];
        NSInteger Previous_Location_Y = [convert get_Location_Y:Previous_Characteristic];
        NSInteger Previous_Location_Z = [convert get_Location_Z:Previous_Characteristic];
        
        Boolean now_Movement_Status = [convert get_Movement_Status    :Location_X
                                               y                      :Location_Y
                                               z                      :Location_Z
                                               previous_x             :Previous_Location_X
                                               previous_y             :Previous_Location_Y
                                               previous_z             :Previous_Location_Z];
        
        now_Stored_Movement_State = [[_StoredDevices objectAtIndex:index] getStoredMovementState];
        
        /**
         * 建立一個儲存十五秒位置變化是否正常的 array
         */
        if([now_Stored_Movement_State count] < _MovementScanTime) {
            [now_Stored_Movement_State addObject: [NSNumber numberWithBool:now_Movement_Status]];
        }
        else {
            for(NSInteger i = 0;i < [now_Stored_Movement_State count] - 1;i++) {
                [now_Stored_Movement_State replaceObjectAtIndex:i withObject:[now_Stored_Movement_State objectAtIndex:i + 1]];
            }
            [now_Stored_Movement_State replaceObjectAtIndex:[now_Stored_Movement_State count] - 1 withObject:[NSNumber numberWithBool:now_Movement_Status]];
        }
    return now_Stored_Movement_State;
}

- (void)
setDeviceInformation            : (__kindof UICollectionViewCell *)    cell
IndexPath                       : (NSIndexPath *)                      Index_Path {
    if(cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    cellData *CD = [[cellData alloc] init];
    
    CD = [_StoredDevices objectAtIndex:[Index_Path row]];
    
    NSInteger index = [Index_Path row];
    // Device Name
    NSString *Device_Name_Str = [[_StoredDevices objectAtIndex:index] getDeviceName];
    
    UILabel *Device_Name_Label = [cell viewWithTag:5];
    
    [Device_Name_Label setText : Device_Name_Str];
    
    // Device ID
    NSString *Device_ID_Str = [[_StoredDevices objectAtIndex:index] getDeviceID];
    
    UILabel *Device_Id_Label = [cell viewWithTag:6];
    
    [Device_Id_Label setText:Device_ID_Str];
    
    // Device Sex
    NSString *Device_Sex_Str = [[_StoredDevices objectAtIndex:index] getDeviceSex];
    
    // 預設圖片
    UIImage *PhotoBackground_Image = [UIImage imageNamed:@"baby_card_girl_photo_background2.png"];
    UIImage *Information_Bar_Image = [UIImage imageNamed:@"baby_card_girl_information_bar_background.png"];
    
    NSLog(@"Sexis:%@", Device_Sex_Str);
    if([Device_Sex_Str isEqual:@"0"]) {
        PhotoBackground_Image = [UIImage imageNamed:@"baby_card_girl_photo_background2.png"];
        Information_Bar_Image = [UIImage imageNamed:@"baby_card_girl_information_bar_background.png"];
    }
    else {
        PhotoBackground_Image = [UIImage imageNamed:@"baby_card_boy_photo_background2.png"];
        Information_Bar_Image = [UIImage imageNamed:@"baby_card_boy_information_bar_background.png"];
    }
    UIImageView *Device_PhotoBackground_ImageView = [cell viewWithTag:7];
    
    [Device_PhotoBackground_ImageView setImage:PhotoBackground_Image];
    
    UIImageView *Device_Bar_ImageView;
    
    for(int i = 8; i <= 10; i++) {
        Device_Bar_ImageView = [cell viewWithTag:i];
        [Device_Bar_ImageView setImage:Information_Bar_Image];
    }
}

- (void)
write04ToKS4310     : (NSMutableArray *)    mutable_Array
index               : (NSUInteger)          Index {
    
    CBPeripheral *peri = [[mutable_Array objectAtIndex:Index] getPheripheral];
    CBService *ser = [[peri services] objectAtIndex:2];
    CBCharacteristic *chara = [[ser characteristics] objectAtIndex:2];
    
    //wirte to get information setting in device.
 
    const uint8_t bytes[] = {0x04};
    
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [peri writeValue:data forCharacteristic:chara type:CBCharacteristicWriteWithResponse];
}

- (NSString *)
getWriteStringByAlertView : (UIAlertController *) alert {
    StringProcessFunc *Str_Process_Func = [[StringProcessFunc alloc] init];
    
    NSString *New_Device_Name = [[[alert textFields] objectAtIndex:0] text];
    NSString *New_Device_ID = [[[alert textFields] objectAtIndex:1] text];
    NSString *New_Device_Sex = [[[alert textFields] objectAtIndex:2] text];
    
    NSString *Merged_Information = @"";
    
    if(     !([New_Device_Name length] > 8)        &&
            !([New_Device_ID length] > 2)          &&
            ([New_Device_Sex isEqual:@"0"]      ||
            [New_Device_Sex isEqual:@"1"])      ) {
        
        NSUInteger Length_Of_Information = 17 * 2;
        NSUInteger Length_Of_Head_String = 1 * 2;
        NSUInteger Length_Of_Device_Name = 8 * 2;
        NSUInteger Length_Of_Device_ID = 2 * 2;
        NSUInteger Length_Of_Device_Sex = 1 * 2;
        
        NSString *Head_String = @"05";
        Merged_Information = [Str_Process_Func MergeTwoString    :  Merged_Information
                                               SecondStr         :  Head_String ];
        NSString *string = @"A";
        NSInteger asc = [string characterAtIndex:0];
        NSString *ascHex = [[NSString alloc] initWithFormat:@"%lx", (long) asc];
        NSLog(@"StringToASCiiHex:%@", ascHex);
        
        for(int i = 0; i < [New_Device_Name length]; i++) {
            NSInteger Split_Str_Int = [New_Device_Name characterAtIndex:i];
            NSString *Split_Str = [[NSString alloc] initWithFormat:@"%lx", (long) Split_Str_Int];
            Merged_Information = [Str_Process_Func MergeTwoString   :   Merged_Information
                                                   SecondStr        :   Split_Str];
        }
        
        while([Merged_Information length] < Length_Of_Head_String + Length_Of_Device_Name) {
            Merged_Information = [Str_Process_Func MergeTwoString   :   Merged_Information
                                                   SecondStr        :   @"00"];
        }
        
        for(int i = 0; i < [New_Device_ID length]; i++) {
            NSInteger Split_Str_Int = [New_Device_ID characterAtIndex:i];
            NSString *Split_Str = [[NSString alloc] initWithFormat:@"%lx", (long) Split_Str_Int];
            Merged_Information = [Str_Process_Func MergeTwoString   :   Merged_Information
                                                   SecondStr        :   Split_Str];
        }
        
        while([Merged_Information length] < Length_Of_Head_String + Length_Of_Device_Name + Length_Of_Device_ID) {
            Merged_Information = [Str_Process_Func MergeTwoString   :   Merged_Information
                                                   SecondStr        :   @"00"];
        }
        
        for(int i = 0; i < [New_Device_Sex length]; i++) {
            NSInteger Split_Str_Int = [New_Device_Sex characterAtIndex:i];
            NSString *Split_Str = [[NSString alloc] initWithFormat:@"%lx", (long) Split_Str_Int];
            Merged_Information = [Str_Process_Func MergeTwoString   :   Merged_Information
                                                   SecondStr        :   Split_Str];
        }
        
        while([Merged_Information length] < Length_Of_Information) {
            Merged_Information = [Str_Process_Func MergeTwoString   :   Merged_Information
                                                   SecondStr        :   @"00"];
        }
        
        NSLog(@"Merged_Information:%@", Merged_Information);
        
    }
    return Merged_Information;
}

- (NSMutableData *)
getWriteStringThroughAlertView : (UIAlertController *) alert {
    NSMutableData *Merged_Information_MutableData = [[NSMutableData alloc] initWithCapacity:0];
    
    NSString *New_Device_Name = [[[alert textFields] objectAtIndex:0] text];
    NSString *New_Device_ID = [[[alert textFields] objectAtIndex:1] text];
    NSString *New_Device_Sex = [[[alert textFields] objectAtIndex:2] text];
    
    if(     !([New_Device_Name length] > 8)        &&
            !([New_Device_ID length] > 2)          &&
            ([New_Device_Sex isEqual:@"0"]      ||
            [New_Device_Sex isEqual:@"1"])      ) {
        //
        NSUInteger Length_Of_Information = 17;
        NSUInteger Length_Of_Head_Bytes = 1;
        NSUInteger Length_Of_Device_Name = 8;
        NSUInteger Length_Of_Device_ID = 2;
        //NSUInteger Length_Of_Device_Sex = 1 * 2;
        
        //
        
        const uint8_t Head_Bytes[] = {0x05};
        NSMutableData *Head_Bytes_Mutable_Data = [NSMutableData dataWithBytes:Head_Bytes
                                                               length:sizeof(Head_Bytes)];
        const uint8_t Zero_Bytes[] = {0x00};
        NSMutableData *Zero_Bytes_Mutable_Data = [NSMutableData dataWithBytes:Zero_Bytes
                                                               length:sizeof(Zero_Bytes)];
        
        NSData *Device_Name_Data = [New_Device_Name dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *Device_Name_Mutable_Data = [Device_Name_Data mutableCopy];
        
        NSData *Device_ID_Data = [New_Device_ID dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *Device_ID_Mutable_Data = [Device_ID_Data mutableCopy];
        
        NSData *Device_Sex_Data = [New_Device_Sex dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableData *Device_Sex_Mutable_Data = [Device_Sex_Data mutableCopy];
        
        [Merged_Information_MutableData appendData:Head_Bytes_Mutable_Data];
        [Merged_Information_MutableData appendData:Device_Name_Mutable_Data];
        
        while([Merged_Information_MutableData length] < Length_Of_Head_Bytes + Length_Of_Device_Name) {
            [Merged_Information_MutableData appendData:Zero_Bytes_Mutable_Data];
        }
        [Merged_Information_MutableData appendData:Device_ID_Mutable_Data];
        while(Merged_Information_MutableData.length < Length_Of_Head_Bytes + Length_Of_Device_Name + Length_Of_Device_ID) {
            [Merged_Information_MutableData appendData:Zero_Bytes_Mutable_Data];
        }
        [Merged_Information_MutableData appendData:Device_Sex_Mutable_Data];
        while(Merged_Information_MutableData.length < Length_Of_Information) {
            [Merged_Information_MutableData appendData:Zero_Bytes_Mutable_Data];
        }
        
        NSLog(@"Merged_Information_MutableData:%@", Merged_Information_MutableData);
         
    }
    return Merged_Information_MutableData;
}

@end
