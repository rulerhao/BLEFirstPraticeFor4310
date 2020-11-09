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
@property (strong, nonatomic) IBOutlet UIButton *Bool_Order_Button;
@property (readonly, assign) NSUInteger MovementScanTime;
@property (readonly, assign) float HighTemperature;
@property (readonly, assign) float LowTemperature;
@property (readwrite, assign) BOOL EnabledOrder;
@property (readwrite, assign) NSIndexPath *NowClickIndexPath;
@end

@implementation ViewController

BOOL EnabledOrder;
// 按下啟動/關閉排序按鈕
// Touch button to turn on/off order function
- (IBAction)Touch_Bool_Order:(id)sender {
    // 切換 EnabledOrder 狀態
    if(EnabledOrder == true) {
        NSLog(@"EnabledOrder:Off");
        EnabledOrder = false;
    }
    else {
        NSLog(@"EnabledOrder:On");
        EnabledOrder = true;
    }
    UIImage *image;
    if(EnabledOrder == true) {
        image = [UIImage imageNamed:@"Exchanging.png"];
    }
    else {
        image = [UIImage imageNamed:@"Change_Icon.png"];
        // 清除 Order_Items_Index
        [_Order_Items_Index removeAllObjects];
    }
    [_Bool_Order_Button setImage:image forState:normal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myCBCentralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
    NSLog(@"AfterCM");
    
    _StoredDevices = [[NSMutableArray alloc] init];
    
    _DevicesInformation = [[NSMutableArray alloc] init];
    
    _MovementScanTime = 15;
    
    _HighTemperature = 27;
    
    _LowTemperature = 25;
    
    _myCollectionView.dragInteractionEnabled = YES;
    _myCollectionView.dragDelegate = self;
    _myCollectionView.dropDelegate = self;
    
    EnabledOrder = false;
    if(EnabledOrder == false) {
        NSLog(@"EnabledOrder:nice");
    }
    else {
        NSLog(@"EnabledOrder:NotNIce");
    }
    
    _Order_Items_Index = [[NSMutableArray alloc] init];
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
   }
}

// 搜尋附近裝置所得到的所有藍牙裝置
- (void)
        centralManager          :(CBCentralManager *)               central
        didDiscoverPeripheral   :(CBPeripheral *)                   peripheral
        advertisementData       :(NSDictionary<NSString *,id> *)    advertisementData
        RSSI                    :(NSNumber *)                       RSSI {
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
    }
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
                NSLog(@"RunInto04");
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
                
                //NSLog(@"RunTimes:%d", i);
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
                //NSLog(@"RunTimes2:%d", i);
                NSMutableArray *now_Stored_Movement_State = [[NSMutableArray alloc] init];
                
                NSString *setPassword = [CalculateFunc getHEX:[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]] ;
                if(setPassword.length >= 8) {
                    setPassword = [str_Process_Func getSubString    :   setPassword
                                                    length          :   8
                                                    location        :   0];
                }
                
                if([[_StoredDevices objectAtIndex:i] getPreviousCharacteristic] != nil && [setPassword isEqual:@"0000F8FA"]) {
                    Convert4310Information *convert = [[Convert4310Information alloc] init];
                    now_Stored_Movement_State = [convert getMovementStatus         :   characteristic
                                                         nowStoredMovementState    :   now_Stored_Movement_State
                                                         storedDevices             :   _StoredDevices
                                                         movementScanTime          :   _MovementScanTime
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
                
                //NSLog(@"IndexOfIP:%d", i);
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                [indexPaths addObject:indexPath];
                
                [UIView performWithoutAnimation:^{
                    [_myCollectionView reloadItemsAtIndexPaths:indexPaths];
                }];
                break;
            }
            else if ([cut_Characteristic_Str isEqual:@"05"]) {
                NSLog(@"05Chara:%@", characteristic_Str);
                NSLog(@"GotA05");
                
                // 儲存資料至 _StoradDevices
                [CD addObj                  :peripheral
                    nowCharacteristic       :[[_StoredDevices objectAtIndex:i] getNowCharacteristic]
                    previousCharacteristic  :[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]
                    nowBabyInformation      :[[_StoredDevices objectAtIndex:i] getNowBabyInformation]
                    CurrentCharacteristic   :[characteristic value]
                    storedMovementState     :[[_StoredDevices objectAtIndex:i] getStoredMovementState]
                    deviceName              :[[_StoredDevices objectAtIndex:i] getDeviceName]
                    deviceID                :[[_StoredDevices objectAtIndex:i] getDeviceID]
                    deviceSex               :[[_StoredDevices objectAtIndex:i] getDeviceSex]];
                
                [_StoredDevices replaceObjectAtIndex:i withObject:CD];
                
                // reload 05
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                [indexPaths addObject:indexPath];
                
                [UIView performWithoutAnimation:^{
                    [_myCollectionView reloadItemsAtIndexPaths:indexPaths];
                }];
            }
            break;
        }
    }
}

// 裝置斷線時
-(void)     centralManager          :(CBCentralManager *)       central
            didDisconnectPeripheral :(CBPeripheral *)           peripheral
            error                   :(NSError *)                error {
    NSLog(@"DisConnected");
    for(int i = 0; i < [_StoredDevices count];i++) {
        NSUUID *Stored_UUID = [[[_StoredDevices objectAtIndex:i] getPheripheral] identifier];
        
        if([Stored_UUID isEqual:[peripheral identifier]]) {
            [_StoredDevices removeObjectAtIndex:i];
            [_Order_Items_Index removeAllObjects];
            break;
        }
    }
}


- (NSInteger)
collectionView          :(UICollectionView *)   collectionView
numberOfItemsInSection  :(NSInteger)            section {
    return [_StoredDevices count];
}

// 在 load 和 reload 指定的 cell 會執行此
// 在此要注意 cell 如果不被設定則會使用他人的 cell view 會很怪異
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
    NSLog(@"ItemChar:%@ index:%ld",characteristic_Str,(long)[indexPath row]);
    /**
     *  依據前兩碼為00, 04, 05
     *  判斷寫入的目的
     *  00 : 平時接收 Device 上傳的資訊
     *  04 : 接收 Device 內部記憶體的資訊
     *  05 : 上傳 Device 內部記憶體的資訊
     */
    SketchView *sketchView = [[SketchView alloc] init];
    
    if([characteristic_Str length] > 2) {
        NSString *cut_Characteristic_Str = [str_Procecss_Func getSubString  :   characteristic_Str
                                                              length        :   2
                                                              location      :   0];
        
        if([cut_Characteristic_Str isEqual:@"00"]) {
            NSLog(@"Clickclick");
            // 每秒 4310 所回傳的資訊
            // 確認名字非 nil
            NSLog(@"ItemCharDeviceName:%@", [CD getDeviceName]);
            if([[CD getDeviceName] length] != 0) {
                //NSLog(@"ItemCharDeviceName:%@", [CD getDeviceName]);
                [sketchView setNotLoadingView:cell];
                
                BOOL cellShouldBeTransparent = false;
                for( NSUInteger i = 0; i < [_Order_Items_Index count]; i++) {
                    if([[_Order_Items_Index objectAtIndex:i] row] == [indexPath row]) {
                        cellShouldBeTransparent = true;
                    }
                }
                if(cellShouldBeTransparent) {
                    [sketchView setTrasparentView:cell];
                }
                else {
                    [sketchView setNotTrasparentView:cell];
                }
                
                [sketchView setDeviceReturnInformation:cell
                                         storedDevices:_StoredDevices
                                      movementScanTime:_MovementScanTime
                                       highTemperature:_HighTemperature
                                        lowTemperature:_LowTemperature
                                             IndexPath:indexPath];
                // 4310 受 write 0x04 或 0x05 後的資訊
                [sketchView setDeviceInformation:cell
                                   storedDevices:_StoredDevices
                                       indexPath: indexPath];
            }
            else {
                [sketchView setNotTrasparentView:cell];
                [sketchView setLoadingView:cell];
            }
        }
        // 0x04 0x05
        else {
            [sketchView setNotTrasparentView:cell];
            [sketchView setLoadingView:cell];
        }
    }
    
    else {
        [sketchView setNotTrasparentView:cell];
        [sketchView setLoadingView:cell];
    }
    
    return cell;
}

/**
 * 當點擊指定item時執行此
 */
-(void)
collectionView          :(UICollectionView *)   collectionView
didSelectItemAtIndexPath:(NSIndexPath *)        indexPath {
    /*
    id object = [_StoredDevices objectAtIndex:0];
    [_StoredDevices removeObjectAtIndex:0];
    [_StoredDevices insertObject:object atIndex:1];
     */
    
    __kindof UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                     forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    if(EnabledOrder == true) {
        NSLog(@"[Order_Items_Index]:%lu", (unsigned long)[_Order_Items_Index count]);
        switch ([_Order_Items_Index count]) {
            case 0:
                [_Order_Items_Index addObject:indexPath];
                break;
            case 1:
                [_Order_Items_Index addObject:indexPath];
                
                // 交換兩個
                NSInteger First_Index = [[_Order_Items_Index objectAtIndex:0] row];
                NSInteger Second_Index = [[_Order_Items_Index objectAtIndex:1] row];
                id First_Object = [_StoredDevices objectAtIndex:First_Index];
                id Second_Object = [_StoredDevices objectAtIndex:Second_Index];
                [_StoredDevices removeObjectAtIndex:First_Index];
                [_StoredDevices insertObject:Second_Object atIndex:First_Index];
                [_StoredDevices removeObjectAtIndex:Second_Index];
                [_StoredDevices insertObject:First_Object atIndex:Second_Index];
                 
                [_Order_Items_Index removeAllObjects];
                
                break;
        }
        [UIView performWithoutAnimation:^{
            [_myCollectionView reloadData];
        }];
    }
    else {
        _NowClickIndexPath = indexPath;
        StringProcessFunc *StrProcessFunc = [[StringProcessFunc alloc] init];
        
        NSString *Device_Name = [[_StoredDevices objectAtIndex:[indexPath row]] getDeviceName];
        
        NSString *Device_ID = [[_StoredDevices objectAtIndex:[indexPath row]] getDeviceID];
        NSString *First_ID_Str = [StrProcessFunc getSubString:Device_ID
                                                       length:1
                                                     location:0];
        NSString *Second_ID_Str = [StrProcessFunc getSubString:Device_ID
                                                        length:1
                                                      location:1];
        if([First_ID_Str isEqual:@"0"]) {
            NSLog(@"FirstEqual");
            Device_ID = Second_ID_Str;
        }
        
        NSString *Device_Sex = [[_StoredDevices objectAtIndex:[indexPath row]] getDeviceSex];
        if([Device_Sex isEqual:@"0"]) {
            Device_Sex = @"G";
        }
        else if ([Device_Sex isEqual:@"1"]) {
            Device_Sex = @"B";
        }
        else {
            Device_Sex = @"G";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Modify Information"
                                       message:nil
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
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {
        }];
        
        // 拍照按鍵部份
        
        UIAlertAction* CameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                               style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {
            [self initCamera : indexPath];
        }];
        
        // OK按鍵的部分
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {
            // 按了 OK 之後
            [self clickOKButton : alert
                       IndexPath:indexPath];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:CameraAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
         
        NSLog(@"finish");
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

- (void ) clickOKButton : (UIAlertController *) alert
              IndexPath : (NSIndexPath *) indexPath {
    NSLog(@"Write05");
    
    // 由 alert view 中取得輸入資訊
    ChangeBetweenWriteStringViewController *ChangeWriteReadString = [[ChangeBetweenWriteStringViewController alloc] init];
    
    NSMutableData *Merged_InformationsAgain = [ChangeWriteReadString getWriteStringThroughAlertView:alert];
    
    InformationRunAvailable *InformationRunnable = [[InformationRunAvailable alloc ]init];
    if([InformationRunnable InformationRunnable:alert])
    {
        NSLog(@"Merged_InformationsAgain : %@", Merged_InformationsAgain);
        
        // write 05 和要賦予的裝置資訊
        CBPeripheral *peri = [[_StoredDevices objectAtIndex:[indexPath row]] getPheripheral];
        CBService *ser = [[peri services] objectAtIndex:2];
        CBCharacteristic *chara = [[ser characteristics] objectAtIndex:2];

        //wirte to get information setting in device.
        [peri writeValue:Merged_InformationsAgain
       forCharacteristic:chara
                    type:CBCharacteristicWriteWithResponse];
        
        NSString *Now_Device_name = [[[alert textFields] objectAtIndex:0] text];
        
        NSString *Previous_Device_Name = [[self->_StoredDevices objectAtIndex:[self->_NowClickIndexPath row]] getDeviceName];
        [self SaveChangedNameImage:Now_Device_name
                Delete_Device_Name:Previous_Device_Name];
    }
    else
    {
        if(![InformationRunnable NameRunnable:alert])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Name Input Formate Error!"
                                           message:nil
                                           preferredStyle:UIAlertControllerStyleAlert];
            // Cancel按鍵的部分
            UIAlertAction* CloseAction = [UIAlertAction actionWithTitle:@"Close"
                                                                   style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {
            }];
            
            [alertController addAction:CloseAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        if(![InformationRunnable IDRunnable:alert])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ID Input Formate Error!"
                                           message:nil
                                           preferredStyle:UIAlertControllerStyleAlert];
            // Cancel按鍵的部分
            UIAlertAction* CloseAction = [UIAlertAction actionWithTitle:@"Close"
                                                                   style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {
            }];
            
            [alertController addAction:CloseAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        if(![InformationRunnable SexRunnable:alert])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sex Input Formate Error!"
                                           message:nil
                                           preferredStyle:UIAlertControllerStyleAlert];
            // Cancel按鍵的部分
            UIAlertAction* CloseAction = [UIAlertAction actionWithTitle:@"Close"
                                                                   style:UIAlertActionStyleDefault
               handler:^(UIAlertAction * action) {
            }];
            
            [alertController addAction:CloseAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void) initCamera : (NSIndexPath *)        indexPath {
    
    NSLog(@"initCamera");
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        //檢查是否支援此Source Type(相機)
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"Access Camera Device");
            
            //設定影像來源為相機
            imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            
            // 顯示UIImagePickerController
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else {
            //提示使用者，目前設備不支援相機
            NSLog(@"No Camera Device");
        }

    });
    
}

//使用者按下確定時

- (void)
imagePickerController           :   (UIImagePickerController *) picker
didFinishPickingMediaWithInfo   :   (NSDictionary *)            info {
    //取得剛拍攝的相片(或是由相簿中所選擇的相片)
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    NSLog(@"NicePicture");
    
    // Create path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *Now_Device_Name = [[_StoredDevices objectAtIndex:[_NowClickIndexPath row]] getDeviceName];
    
    StringProcessFunc *Str_Process_Func = [[StringProcessFunc alloc] init];
    NSString *Now_Device_Name_With_Extension = [Str_Process_Func MergeTwoString:Now_Device_Name SecondStr:@".png"];
    
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:Now_Device_Name_With_Extension];
 
    NSLog(@"Picture_Directory:%lu", (unsigned long)NSDocumentDirectory);
    NSLog(@"Picture_Mask:%lu", (unsigned long)NSUserDomainMask);
    NSLog(@"Picture_Path:%@", filePath);
    
    // Save image.
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}



//使用者按下取消時
- (void)
imagePickerControllerDidCancel  :   (UIImagePickerController *) picker {
    //一般情況下沒有什麼特別要做的事情
    
    [picker dismissViewControllerAnimated:YES completion:^{}];

}

- (void) SaveChangedNameImage : (NSString *) now_Device_Name
           Delete_Device_Name : (NSString *) delete_Device_Name
{
    StringProcessFunc *Str_Process_Func = [[StringProcessFunc alloc] init];
    
    // 開始儲存檔名
    
    // 照片更名功能
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // NSString *Previous_Device_Name = [[self->_StoredDevices objectAtIndex:[self->_NowClickIndexPath row]] getDeviceName];
    NSString *Previous_Device_Name = delete_Device_Name;
    
    NSString *Previous_Device_Name_With_Extension = [Str_Process_Func MergeTwoString:Previous_Device_Name SecondStr:@".png"];
    
    NSString *Previous_filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:Previous_Device_Name_With_Extension];
 
    UIImage *PhotoImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@",Previous_filePath]];
    
    NSString *Now_Device_Name_With_Extension = [Str_Process_Func MergeTwoString:now_Device_Name SecondStr:@".png"];
    
    NSString *Now_filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:Now_Device_Name_With_Extension];
    
    // 儲存現在檔名的圖片
    
    [UIImagePNGRepresentation(PhotoImage) writeToFile:Now_filePath atomically:YES];
    
    if(![Previous_filePath isEqual:Now_filePath]) {
        // 刪除之前檔名的圖片
        [[NSFileManager defaultManager ] removeItemAtPath:Previous_filePath
                                                    error:nil];
    }
}
@end
