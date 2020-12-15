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
{
    BOOL MQTTSubscribing;
    MQTTSession *Session;
    NSString *Client_ID;
    NSString *User_Name;
    NSString *OTP;
    NSString *OTP_Expired;
    NSTimer *BLEBeDisabledTimer;
    NSTimer *NetworkBeDisabledTimer;
    OAuth2Main *webViewController;
}
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *Bool_Order_Button;
@property (readwrite, assign) BOOL EnabledOrder;
@end

@implementation ViewController

BOOL EnabledOrder;
// 按下啟動/關閉排序按鈕
// Touch button to turn on/off order function
- (IBAction)Touch_Bool_Order:(id)sender {
    // 切換 EnabledOrder 狀態
    UIImage *image;
    if(EnabledOrder) {
        NSLog(@"EnabledOrder:Off");
        EnabledOrder = false;
        image = [UIImage imageNamed:@"Change_Icon.png"];
        // 清除 Order_Items_Index
        [_Order_Items_Index removeAllObjects];
    } else {
        NSLog(@"EnabledOrder:On");
        EnabledOrder = true;
        image = [UIImage imageNamed:@"Exchanging.png"];
    }
    [_Bool_Order_Button setImage:image forState:normal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkNetworkStatusForFixTime];
    NSLog(@"ReachAblility = %ld", (long)[[Reachability reachabilityWithHostName:@"https://healthng.oucare.com/"] currentReachabilityStatus]);
    NSLog(@"ReachAblility = %ld", (long)[[Reachability reachabilityWithHostName:@"https://healthng.oucare.com/ou/7da0f976-f732-11ea-b7aa-0242ac160004/dashboard"] currentReachabilityStatus]);
    // set notificationCenter to get OAuth2 returning informaiton from OAuth2Main
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetOAuthOTPNotification:) //接收到該Notification時要call的function
                                                 name:@"getOAuthOTPNotification"
                                               object:nil];
    
    // Set MQTT subScribe notification that we can know whether mqtt subscribe yet.
    MQTTSubscribing = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetMQTTSubscribeNotification:) //接收到該Notification時要call的function
                                                 name:@"getMQTTSubscribing"
                                               object:nil];
    /**
     * 底下需要修改位置
     */
    _myCBCentralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:nil
                                                             options:nil];
    NSLog(@"AfterCM");
    
    _StoredDevices = [[NSMutableArray alloc] init];
    
    _DevicesInformation = [[NSMutableArray alloc] init];
    
    _myCollectionView.dragInteractionEnabled = YES;
    _myCollectionView.dragDelegate = self;
    _myCollectionView.dropDelegate = self;
    
    EnabledOrder = false;
    if(EnabledOrder == false) {
        NSLog(@"EnabledOrder:nice");
    } else {
        NSLog(@"EnabledOrder:NotNIce");
    }
    
    _Order_Items_Index = [[NSMutableArray alloc] init];
}

- (void)
centralManagerDidUpdateState:(CBCentralManager *)central {
    
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
            [self initApp];
            [self enableBLEDisableTimer];
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"central.state: CBManagerStatePoweredOn.");
            [self disableBLEDisableTimer];
            break;
    }
             
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
       [_myCBCentralManager scanForPeripheralsWithServices:nil
                                                   options:opt];
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
        for(int i = 0;i < [_StoredDevices count]; i++) {
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
            [CD addObj                                  :peripheral
                nowDeviceInformationCharacteristic      :nil
                previousCharacteristic                  :nil
                nowBabyInformationCharacteristic        :nil
                CurrentCharacteristic                   :nil
                storedMovementState                     :nil
                deviceName                              :nil
                deviceID                                :nil
                deviceSex                               :nil];
            
            [_StoredDevices addObject:CD];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[_StoredDevices count] - 1 inSection:0];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            [indexPaths addObject:indexPath];
            [_myCollectionView insertItemsAtIndexPaths:indexPaths];
            [_myCBCentralManager connectPeripheral:peripheral options:nil];
        }
    }
}

- (void)
        centralManager          :(CBCentralManager *)               central
        didConnectPeripheral    :(CBPeripheral *)                   peripheral {
    NSLog(@"peripheral 1st: %@", peripheral);
    
    NSLog(@"didConn");
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

/**
 當發現 service 時會 call 這個 function
 */
- (void)     peripheral              :(CBPeripheral *)   peripheral
             didDiscoverServices     :(NSError *)        error {
    NSLog(@"peripheralSecond: %@", peripheral);
    NSLog(@"Find Service");
    
    NSLog(@"services: %@", [peripheral services]);
    /**
     0 為 Device Information
     1 不確定
     2 為 FFF0 所在的位置 也就是放 Bluetooth 資訊的位置
     */
    [peripheral discoverCharacteristics:nil
                             forService:[[peripheral services] objectAtIndex:2]];
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
    
    KS4310Setting *ks4310Setting = [[KS4310Setting alloc] init];
    [ks4310Setting InitKS4310Setting];
    
    for(int i = 0; i < [_StoredDevices count]; i++) {
        NSUUID *stored_Identifier = [[[_StoredDevices objectAtIndex:i] getPheripheral] identifier];
        NSUUID *now_Identifier = [peripheral identifier];
        
        if([stored_Identifier isEqual:now_Identifier]) {
            // 如果是第一次進如則先 write 04 讓 device回傳嬰兒資訊
            // 如果 getNowCharacteristic 還是 nil 的話
            // 或者接收到 0x0555aa (接收到 0x05 時 update 的值 length = 3)
            if(![[_StoredDevices objectAtIndex:i] getNowDeviceInformationCharacteristic] ||
               [[characteristic value] length] == ks4310Setting.Identifier_From_Write_Characteristic_Full_Bytes_Length) {
                [self write04ToKS4310:_StoredDevices
                                index:i];
            }
            NSData *characteristic_Value = [characteristic value];
            NSString *characteristic_Str = [CalculateFunc getHEX:characteristic_Value];
            NSLog(@"characteristic_Str = %@", characteristic_Str);
            NSString *Characteristic_Head_Bytes_String = [str_Process_Func getSubString   :characteristic_Str
                                                                 length         :ks4310Setting.Identifier_Characteristic_Bytes_String_Head_Length
                                                                 location       :ks4310Setting.Identifier_Characteristic_Bytes_String_Cut_Start_Location];
            
            // 如果這次的 Characterstice 是 04
            // 也就是讀取嬰兒身份
            if([Characteristic_Head_Bytes_String isEqual:ks4310Setting.Identifier_From_Read_Characteristic_Bytes_String]) {
                NSLog(@"RunInto04");
                // Device Name
                NSString *Device_Name_Str = [convert_Characteristic getDeviceName:[characteristic value]];
                // Device ID
                NSString *Device_ID_Str = [convert_Characteristic getDeviceID:[characteristic value]];
                // Device Sex
                NSString *Device_Sex_Str = [convert_Characteristic getDeviceSex:[characteristic value]];
                
                // 儲存資料至 _StoradDevices
                [CD addObj                  :peripheral
                    nowDeviceInformationCharacteristic          :[[_StoredDevices objectAtIndex:i] getNowDeviceInformationCharacteristic]
                    previousCharacteristic                      :[[_StoredDevices objectAtIndex:i] getCurrentCharacteristic]
                    nowBabyInformationCharacteristic            :[characteristic value]
                    CurrentCharacteristic                       :[characteristic value]
                    storedMovementState                         :[[_StoredDevices objectAtIndex:i] getStoredMovementState]
                    deviceName                                  :Device_Name_Str
                    deviceID                                    :Device_ID_Str
                    deviceSex                                   :Device_Sex_Str];
                
                [_StoredDevices replaceObjectAtIndex:i
                                          withObject:CD];
                
                //NSLog(@"RunTimes:%d", i);
                // reloadItems
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i
                                                             inSection:0];
                NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                [indexPaths addObject:indexPath];
                
                [UIView performWithoutAnimation:^{
                    [_myCollectionView reloadItemsAtIndexPaths:indexPaths];
                }];
                
                break;
            }
            // 假如這次收到的 characteristic 開頭為 00
            // 也就是接收裝置資訊時
            else if ([Characteristic_Head_Bytes_String isEqual:ks4310Setting.Identifier_From_Recieve_Characteristic_Bytes_String]) {
                // 如果 stored movement state 為 nil 則 init
                // 如果 stored movement state not nil 則取原本的值
                NSMutableArray *now_Stored_Movement_State;
                if([[_StoredDevices objectAtIndex:i] getStoredMovementState]) {
                    now_Stored_Movement_State = [[_StoredDevices objectAtIndex:i] getStoredMovementState];
                } else {
                    now_Stored_Movement_State = [[NSMutableArray alloc] init];
                }
                
                NSString *Previous_Characteristic = [CalculateFunc getHEX:[[_StoredDevices objectAtIndex:i] getPreviousCharacteristic]] ;
                
                Previous_Characteristic = [str_Process_Func getSubString    :   Previous_Characteristic
                                                            length          :   ks4310Setting.    Identifier_From_Recieve_Characteristic_Full_Bytes_String_Length
                                                            location        :   ks4310Setting.    Identifier_From_Recieve_Characteristic_Bytes_String_Cut_Location];
                
                // 如果前一個 Characteristic isEqual "0000F8FA"
                if(Previous_Characteristic &&
                   [Previous_Characteristic isEqual:ks4310Setting.Identifier_From_Recieve_Characteristic_Full_Bytes_String]) {
                    NSLog(@"characteristic too short = :%@", [characteristic value]);
                    Convert4310Information *convert = [[Convert4310Information alloc] init];
                    now_Stored_Movement_State = [convert refreshMovementState         :   characteristic
                                                         nowStoredMovementState    :   now_Stored_Movement_State
                                                         storedDevices             :   _StoredDevices
                                                         movementScanTime          :   ks4310Setting.Movement_Scan_Time
                                                         index                     :   i];
                }
                /**
                 * 儲存至全域 NSMutableArray StoredDevices
                 */
                [CD addObj                                      :peripheral
                    nowDeviceInformationCharacteristic          :[characteristic value]
                    previousCharacteristic                      :[[_StoredDevices objectAtIndex:i] getNowDeviceInformationCharacteristic]
                    nowBabyInformationCharacteristic            :[[_StoredDevices objectAtIndex:i] getNowBabyInformationCharacteristic]
                    CurrentCharacteristic                       :[characteristic value]
                    storedMovementState                         :now_Stored_Movement_State
                    deviceName                                  :[[_StoredDevices objectAtIndex:i] getDeviceName]
                    deviceID                                    :[[_StoredDevices objectAtIndex:i] getDeviceID]
                    deviceSex                                   :[[_StoredDevices objectAtIndex:i] getDeviceSex]];
                
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
                
                // MQTT Publish 到 OUHealthng
                
                break;
            }
            // 如果前一個是 05
            // 也就是前一次是寫入的動作
            else if ([Characteristic_Head_Bytes_String isEqual:ks4310Setting.Identifier_From_Write_Characteristic_Bytes_String]) {
                NSLog(@"05Chara:%@", characteristic_Str);
                NSLog(@"GotA05");
                
                // 儲存資料至 _StoradDevices
                [CD addObj                              :peripheral
                    nowDeviceInformationCharacteristic  :[[_StoredDevices objectAtIndex:i] getNowDeviceInformationCharacteristic]
                    previousCharacteristic              :[[_StoredDevices objectAtIndex:i] getCurrentCharacteristic]
                    nowBabyInformationCharacteristic    :[[_StoredDevices objectAtIndex:i] getNowBabyInformationCharacteristic]
                    CurrentCharacteristic               :[characteristic value]
                    storedMovementState                 :[[_StoredDevices objectAtIndex:i] getStoredMovementState]
                    deviceName                          :[[_StoredDevices objectAtIndex:i] getDeviceName]
                    deviceID                            :[[_StoredDevices objectAtIndex:i] getDeviceID]
                    deviceSex                           :[[_StoredDevices objectAtIndex:i] getDeviceSex]];
                
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
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i
                                                         inSection:0];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            [indexPaths addObject:indexPath];
            [_myCollectionView deleteItemsAtIndexPaths:indexPaths];
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
    
    KS4310Setting *ks4310Setting = [[KS4310Setting alloc] init];
    [ks4310Setting InitKS4310Setting];
    
    __kindof UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                     forIndexPath:indexPath];
    if(cell == nil)
    {
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
    
    if([characteristic_Str length] > ks4310Setting.Identifier_Characteristic_Bytes_String_Head_Length) {
        NSString *Characteristic_Head_String = [str_Procecss_Func getSubString  :   characteristic_Str
                                                              length        :   ks4310Setting.Identifier_Characteristic_Bytes_String_Head_Length
                                                              location      :   ks4310Setting.Identifier_Characteristic_Bytes_String_Cut_Start_Location];
        // "00"
        if([Characteristic_Head_String isEqual:ks4310Setting.Identifier_From_Recieve_Characteristic_Bytes_String]) {
            // 每秒 4310 所回傳的資訊
            // 如果 DeviceName DeviceID DeviceSex 不是NIL
            if([CD getDeviceName] &&
               [CD getDeviceID] &&
               [CD getDeviceSex])
            {
                NSLog(@"deviceName = %@", [CD getDeviceName]);
                NSLog(@"deviceID = %@", [CD getDeviceID]);
                NSLog(@"deviceSex = %@", [CD getDeviceSex]);

                [sketchView setNotLoadingView:cell];
                
                // 如果這次的 index 相同則變透明
                // 用於交換裝置卡片用
                BOOL cellShouldBeTransparent = false;
                
                for( NSUInteger i = 0; i < [_Order_Items_Index count]; i++)
                    if([[_Order_Items_Index objectAtIndex:i] row] == [indexPath row])
                        cellShouldBeTransparent = true;
                
                if(cellShouldBeTransparent)
                    [sketchView setTrasparentView:cell];
                else
                    [sketchView setNotTrasparentView:cell];
                
                // 4310 接收 0x00 資訊
                [sketchView setDeviceReturnInformation:cell
                                         storedDevices:_StoredDevices
                                      movementScanTime:ks4310Setting.Movement_Scan_Time
                                       highTemperature:ks4310Setting.HighTemperatureword
                                        lowTemperature:ks4310Setting.LowTemperature
                                             IndexPath:indexPath];
                
                // 4310 受 write 0x04 或 0x05 後的資訊
                [sketchView setDeviceInformation:cell
                                   storedDevices:_StoredDevices
                                       indexPath: indexPath];
                
                // MQTT publish 至 Ouhealthng
                NSLog(@"getStoredMovementState = %@", [CD getStoredMovementState]);
                
                BOOL MovementNormal = [sketchView getMovementNormal:[CD getStoredMovementState]
                                                           ScanTime:ks4310Setting.Movement_Scan_Time];
                [self mqttPublish : [CD getDeviceName]
                 characteristic:characteristic_Data
                 movementState:MovementNormal];
                return cell;
            }
        }
    }
    [sketchView setNotTrasparentView:cell];
    [sketchView setLoadingView:cell];
    
    return cell;
}

/**
 * 當點擊指定item時執行此
 */
-(void)
collectionView          :(UICollectionView *)   collectionView
didSelectItemAtIndexPath:(NSIndexPath *)        indexPath {
    
    __kindof UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                     forIndexPath:indexPath];
    if(cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    // 如果目前是切換狀態
    if(EnabledOrder) {
        SwitchDevices *switchDevices = [[SwitchDevices alloc] init];
        [switchDevices switchDevices:_myCollectionView
                     orderItemsIndex:_Order_Items_Index
                       storedDevices:_StoredDevices
                           indexPath:indexPath];
    }
    else {
        StringProcessFunc *StrProcessFunc = [[StringProcessFunc alloc] init];
        
        NSString *Device_Name = [[_StoredDevices objectAtIndex:[indexPath row]] getDeviceName];
        
        NSString *Device_ID = [[_StoredDevices objectAtIndex:[indexPath row]] getDeviceID];
        // ID 的字串處理
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
        } else if ([Device_Sex isEqual:@"1"]) {
            Device_Sex = @"B";
        } else {
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
        // 在此因為先進入 CameraController 再到 Camera 內
        // 所以退出時也需要先退出 Camera 再退出 CameraController
        UIAlertAction* CameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                               style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {
            CameraController *cameraController = [[CameraController alloc] init];
            ViewController *viewController = self;
            
            // 將卡片形式設定為全畫面
            cameraController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            cameraController.NowClickIndexPath = indexPath;
            cameraController.StoredDevices = self->_StoredDevices;
            [viewController presentViewController:cameraController
                                         animated:true
                                       completion:nil];
        }];
        
        // OK按鍵的部分
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {
            SaveInformationFunc *saveInformationFunc = [[SaveInformationFunc alloc] init];
            NSString *ErrorMessage = [saveInformationFunc saveInformation: alert
                                                            storedDevices: self->_StoredDevices
                                                                indexPath: indexPath];
            [self ShowAlertMessage:ErrorMessage];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:CameraAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
         
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
    
    NSData *data = [NSData dataWithBytes:bytes
                                  length:sizeof(bytes)];
    [peri writeValue:data
   forCharacteristic:chara
                type:CBCharacteristicWriteWithResponse];
}

- (void) ShowAlertMessage : (NSString *) ErrorMessage
{
    if([ErrorMessage length] > 0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ErrorMessage
                                       message:nil
                                       preferredStyle:UIAlertControllerStyleAlert];
        // Cancel按鍵的部分
        UIAlertAction* CloseAction = [UIAlertAction actionWithTitle:@"Close"
                                                               style:UIAlertActionStyleDefault
           handler:^(UIAlertAction * action) {
        }];
        
        [alertController addAction:CloseAction];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
    }
}

- (void) mqttPublish : (NSString *) Baby_Name
      characteristic : (NSData *) Characteristic
       movementState : (BOOL) MovementState {
    PublishDataFor4320 *publishDataFor4320 = [[PublishDataFor4320 alloc] init];
    Convert4310Information *convert4310Information = [Convert4310Information alloc];
    
    NSString *Baby_UUID;
    NSString *Device_Type = @"KS-4310";
    if([Baby_Name isEqual:@"S10"]) {
        Baby_UUID = @"92ee96a5-ff9a-11ea-8fd3-0242ac160004";
    }
    else if([Baby_Name isEqual:@"S15"]) {
        Baby_UUID = @"92ee96a6-ff9a-11ea-8fd3-0242ac160004";
    }
    else {
        Baby_UUID = @"92ee96a6-ff9a-11ea-8fd3-0242ac160004";
    }
    
    NSData *PublishData = [publishDataFor4320 getPublishData:Device_Type
                                               Device_Serial:Baby_Name
                                                 Device_UUID:Baby_UUID
                                                   client_ID:Client_ID
                                                Temperature1:[convert4310Information getTemperature_1:Characteristic]
                                                Temperature2:[convert4310Information getTemperature_2:Characteristic]
                                                Temperature3:[convert4310Information getTemperature_3:Characteristic]
                                                     Battery:(int) [convert4310Information getBattery_Volume:Characteristic]
                                                      Breath:MovementState
                                                    Motion_X:123.1
                                                    Motion_Y:252.6
                                                    Motion_Z:929.1];
    
    TypesConversion *typesConversion = [[TypesConversion alloc] init];
    NSLog(@"ADADAADD:%@", [typesConversion getHEX:PublishData]);

    long ReachAbility = [[Reachability reachabilityWithHostName:@"https://healthng.oucare.com/"] currentReachabilityStatus];
    NSLog(@"ReachAbilityBeforePublish = %ld", ReachAbility);
    NSLog(@"Session = %@", Session);
    if([self webViewExist] && Session) {
        if(ReachAbility == 1) {
            NSLog(@"EnterHere");
            [Session publishData:PublishData
                         onTopic:@"/ouhub/requests"
                          retain:NO
                             qos:MQTTQosLevelAtMostOnce
                  publishHandler:^(NSError *error) {
                NSLog(@"subviewInPublish = %@",  self.view.subviews);
                if (error) {
                    NSLog(@"失去MQTT Subscribe");
                    [self->webViewController removeFromSuperview];
                    self->Session = nil;
                    [self oAuth2AndMQTTStart];
                    // 重新讀取
                    NSLog(@"PulbishForSameTimeerror - %@",error);
                } else {
                    NSLog(@"send ok");
                }
            }];
        } else if(ReachAbility == 0) {
            
        }
    }
}
// 得到 OTP 走這
- (void)
didGetOAuthOTPNotification:(NSNotification *)notification {
    NSLog(@"getOAuthOTPSusscess");
    
    // Read OTP information dictionary
    NSDictionary * userInfo = [notification userInfo]; //讀取userInfo
    NSArray *userInfo_Array = [[userInfo allValues] objectAtIndex:0];
    Client_ID = [userInfo_Array objectAtIndex:0];
    User_Name = [userInfo_Array objectAtIndex:1];
    OTP = [userInfo_Array objectAtIndex:2];
    OTP_Expired = [userInfo_Array objectAtIndex:3];
    // MQTT Subscribe
    MQTTMain *mqttMain = [MQTTMain alloc];
    [mqttMain mqttStart:[userInfo allValues] viewController : self];
    
}

// 得到 MQTT subscribe susscess 走這
- (void)
didGetMQTTSubscribeNotification:(NSNotification *)notification {
    NSLog(@"getMQTTSubscribeSusscess");
    NSDictionary *userInfo = [notification userInfo]; //讀取userInfo
    Session = [[userInfo allValues] objectAtIndex:0];
    NSLog(@"Session123 = %@", Session);
    MQTTSubscribing = YES;
}

- (void) initApp {
    [_StoredDevices removeAllObjects];
    [_myCollectionView reloadData];
    [_Order_Items_Index removeAllObjects];
}

/**
 * BLE TIMER
 */
// 當BLE被使用者關掉時
- (void) bleBeDisabledByUserEnd {
    [self initApp];
    [self showBLEBeDiabledByUserEndAlertView];
}

// 顯示無BLE時的Alert View
- (void) showBLEBeDiabledByUserEndAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BlueTooth Be Disabled By User End"
                                                                   message:@"Please Enable Your Bluetooth"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    // OK按鍵的部分
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

// 顯示Timer到期時無BLE時的Alert View
- (void) showBLEBeDisabledByUserEndAlertViewInSameTime :(NSTimer*)sender {
    [self showBLEBeDiabledByUserEndAlertView];
}

// 打開無BLE時的Timer
- (void) enableBLEDisableTimer {
    BLEBeDisabledTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(showBLEBeDisabledByUserEndAlertViewInSameTime:)
                                   userInfo:nil
                                    repeats:YES];
}
// 關閉無BLE時的Timer
- (void) disableBLEDisableTimer {
    [BLEBeDisabledTimer invalidate];
    BLEBeDisabledTimer = nil;
}

/**
 * Network 有無的 timer
 */
// 顯示無BLE時的Alert View
- (void) showNetworkAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"網路沒有連線"
                                                                   message:@"請打開你的網路並確認連線"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    // OK按鍵的部分
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
       handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}
- (void) checkNetworkStatusForFixTime {
    NetworkBeDisabledTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                              target:self
                                                            selector:@selector(checkNetworkStatus:)
                                                            userInfo:nil
                                                             repeats:YES];
}

- (void) checkNetworkStatus : (NSTimer*) sender {
    NSUInteger Reach_Ablility_Status = [[Reachability reachabilityWithHostName:@"https://healthng.oucare.com/"] currentReachabilityStatus];
    if(Reach_Ablility_Status == 0) {
        // 顯示網路alert View
        [self showNetworkAlertView];
    } else if (Reach_Ablility_Status == 1) {
        NSLog(@"WebViewContain = %@", self.view.subviews);
        if(![self webViewExist]) {
            NSLog(@"webViewExist");
            // 開始做MQTT以及OAuth2
            [self oAuth2AndMQTTStart];
        }
    }
}
- (BOOL) webViewExist {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [OAuth2Main class]];
    NSArray *filteredViews = [self.view.subviews filteredArrayUsingPredicate:predicate];
    if([filteredViews count] > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void) oAuth2AndMQTTStart {
    webViewController = [OAuth2Main new];
    [self.view addSubview:webViewController];
    NSLog(@"self.view.TestExist = %@", self.view.subviews);
    [webViewController InitEnter : self];
}
@end
