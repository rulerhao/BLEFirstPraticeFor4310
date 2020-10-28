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
                storedMovementState     :nil];
            
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
                storedMovementState     :[[_StoredDevices objectAtIndex:i] getStoredMovementState]];
            
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
                storedMovementState     :[[_StoredDevices objectAtIndex:i] getStoredMovementState]];
            
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
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
    cellData *CD = [[cellData alloc] init];
    
    for(int i = 0;i < [_StoredDevices count];i++) {
        NSUUID *stored_Identifier = [[[_StoredDevices objectAtIndex:i] getPheripheral] identifier];
        NSUUID *now_Identifier = [peripheral identifier];
        
        if([stored_Identifier isEqual:now_Identifier]) {
            
            NSData *characteristic_Value = [characteristic value];
            NSString *characteristic_Str = [CalculateFunc getHEX:characteristic_Value];
            NSString *cut_Characteristic_Str = [CalculateFunc getSubString:characteristic_Str length:2 location:0];
            
            if([cut_Characteristic_Str isEqual:@"04"]) {
                
                NSLog(@"Somethingis04");
                [CD addObj                  :peripheral
                    nowCharacteristic       :[[_StoredDevices objectAtIndex:i] getNowCharacteristic]
                    previousCharacteristic  :[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]
                    nowBabyInformation      :[characteristic value]
                    CurrentCharacteristic   :[characteristic value]
                    storedMovementState     :[[_StoredDevices objectAtIndex:i] getStoredMovementState]];
                
                [_StoredDevices replaceObjectAtIndex:i withObject:CD];
                
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
            else if ([cut_Characteristic_Str isEqual:@"00"]) { 
                NSMutableArray *now_Stored_Movement_State = [[NSMutableArray alloc] init];
                
                NSString *setPassword = [CalculateFunc getHEX:[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]] ;
                if(setPassword.length >= 8) {
                    setPassword = [CalculateFunc getSubString:setPassword length:8 location:0];
                }
                
                if([[_StoredDevices objectAtIndex:i] getPreviousCharacteristic] != nil && [setPassword isEqual:@"0000F8FA"]) {
                    now_Stored_Movement_State = [self getMovementStatus         :   characteristic
                                                      nowStoredMovementState    :   now_Stored_Movement_State
                                                      index                     :   i];
                }

                /**
                 * 儲存至全域 NSMutableArray StoredDevices
                 */
                [CD addObj                  :peripheral
                    nowCharacteristic       :[characteristic value]
                    previousCharacteristic  :[[_StoredDevices objectAtIndex:i] getNowCharacteristic]
                    nowBabyInformation      :[[_StoredDevices objectAtIndex:i] getNowBabyInformation]
                    CurrentCharacteristic   :[characteristic value]
                    storedMovementState     :now_Stored_Movement_State];
                
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
    Convert4310Information *convert_Characteristic = [[Convert4310Information alloc] init];
    
    CalFunc *CalculateFunc = [[CalFunc alloc] init];
    
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
        NSString *cut_Characteristic_Str = [CalculateFunc getSubString:characteristic_Str length:2 location:0];
        
        if([cut_Characteristic_Str isEqual:@"00"]) {
            NSLog(@"Clickclick");
            [self setDeviceReturnInformation    : cell
                  IndexPath                     : indexPath];
             
        }
        
        else if([cut_Characteristic_Str isEqual:@"04"]) {
            
            NSLog(@"Run04");
            
            // Device Name
            NSString *Device_Name_Str = [convert_Characteristic getDeviceName:characteristic_Data];
            
            UILabel *Device_Name_Label = [cell viewWithTag:5];
            Device_Name_Label.text = Device_Name_Str;
            
            // Device ID
            NSString *Device_ID_Str = [convert_Characteristic getDeviceID:characteristic_Data];
            
            UILabel *Device_Id_Label = [cell viewWithTag:6];
            
            [Device_Id_Label setText:Device_ID_Str];
             
        }
        
        else if([cut_Characteristic_Str isEqual:@"05"]) {
            
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
    
    NSLog(@"YouClickThe:%ld", (long)[indexPath item]);
    
    NSUInteger indexOfClickedItem = [indexPath row];
    NSLog(@"indexOfClickedItem: %lu", (unsigned long)indexOfClickedItem);
    
    CBPeripheral *peri = [[_StoredDevices objectAtIndex:indexOfClickedItem] getPheripheral];
    CBService *ser = [[peri services] objectAtIndex:2];
    CBCharacteristic *chara = [[ser characteristics] objectAtIndex:2];
    NSLog(@"UUID: %@", [chara UUID]);
    
    //wirte to get information setting in device.
 
    const uint8_t bytes[] = {0x04};
    
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    [peri writeValue:data forCharacteristic:chara type:CBCharacteristicWriteWithResponse];
    
    /*
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                   message:@"This is an alert."
                                   preferredStyle:UIAlertControllerStyleAlert];
     
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Name";
        textField.text = @"nice";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"ID";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Sex";
    }];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
        NSLog(@"TestTextFromAlert: %@", [[[alert textFields] objectAtIndex:1] text]);
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    */
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
@end
