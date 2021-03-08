//
//  BLEFor4310.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/23.
//

#import "BLEFor4310.h"

@interface BLEFor4310 ()
{
    CBCentralManager *My_CB_Central_Manager;
    StoredDevicesCell *storedDevicesCell;
    CalFunc *CalculateFunc;
    KS4310Setting *ks4310Setting;
    Convert4310Information *convert4310Information;
    NSTimer *BLEConnectServerTimer;

}
@end

@implementation BLEFor4310
{
//------------ 執行緒 -------------

dispatch_queue_t BLEQueue;
dispatch_queue_t MainQueue;
}
- (instancetype) init {
    CalculateFunc = [CalFunc alloc];
    ks4310Setting = [KS4310Setting alloc];
    [ks4310Setting InitKS4310Setting];
    convert4310Information = [Convert4310Information alloc];
    
    // ---------------------- 初始化 self.Stored_Data -------------------
    self.Stored_Data = [[NSMutableArray alloc] init];
    // ---------------------- 初始 cell ----------------------
    storedDevicesCell = [[StoredDevicesCell alloc] init];
    
//    BLEQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    MainQueue = dispatch_get_main_queue();
    
    NSLog(@"Delegate = %@", self);
    // ---------------------- 初始化 CB Central Manager ----------------------
//    _CM = [[CBCentralManager alloc] initWithDelegate:self queue:BLEQueue];
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    //Return_HTML_String = [NSString stringWithFormat:@"%@", result];
    NSMutableArray *Testttt;
    
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"NotificationName" //Notification以一個字串(Name)下去辨別
        object:self
        userInfo:Testttt];
    
    // ---------------------- Device Connect Server Timer ----------------------
    BLEConnectServerTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(detectDevicesConnect:)
                                   userInfo:nil
                                    repeats:YES];
    
    return self;
}

#pragma mark - Core Bluetooth Delegate

//---------------------- Core Bluetooth Delegate - CB Central Manager 狀態變更時的 Delegate ------------------
- (void)
centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"DidUpdateState");
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
            // ---------------------- 開始搜尋附近的藍芽裝置 ----------------------
            [central scanForPeripheralsWithServices:nil
                                            options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES}];
            break;
    }
}

//---------------------- Core Bluetooth Delegate - 搜尋到附近的 Peripheral 時的 Delegate ------------------
- (void)
        centralManager          :(CBCentralManager *)               central
        didDiscoverPeripheral   :(CBPeripheral *)                   peripheral
        advertisementData       :(NSDictionary<NSString *,id> *)    advertisementData
        RSSI                    :(NSNumber *)                       RSSI {
    // ---------------------- 篩選出 Device name 為 KS-4310 的裝置 ----------------------
    if([peripheral.name isEqual: @"KS-4310"]) {
//        // ---------------------- 判斷新搜尋到的 Device 有沒有在已搜尋到的裝置中 ----------------------
//        Boolean Device_Contain = [self searchSDDeviceContain:peripheral stored_Peripheral:[self getStoredDataPeripheralArray:self.Stored_Data]];
//        // ---------------------- 如果已搜尋到的 Stored_Devices 中不包含新搜尋到的 Device ----------------------
//        if(Device_Contain == NO) {
//            NSLog(@"Device not contain = %@", peripheral);
//            // ---------------------- 新增至 Stored_Devices ----------------------
//            [self addNewDeviceToStored:self.Stored_Data peripheral:peripheral];
//            [self.delegate addNewDevice:peripheral];
//            // ---------------------- 連接 Peripheral ----------------------
//            [central connectPeripheral:peripheral options:nil];
//        }
        BOOL Device_Contain = NO;
        for(int i = 0; i < [self.Stored_Data count]; i++) {
            if([[peripheral identifier] isEqual:[[[self.Stored_Data objectAtIndex:i] Peripheral]identifier]]) {
                NSLog(@"Device_Contain = %@", [peripheral identifier]);
                Device_Contain = YES;
                break;
            }
        }
        if(Device_Contain == NO) {
            StoredDevicesCell *storedDeviceCell = [[StoredDevicesCell alloc] init];
            [storedDeviceCell cell:peripheral
                    characteristic:nil
                 deviceInformation:nil
                   babyInformation:nil
               storedMovementState:nil
                        deviceName:nil
                          deviceID:nil
                         deviceSex:nil
                       deviceModel:nil
                       deviceEPROM:nil
                        deviceUUID:nil
                      deviceStatus:nil];
            [self.Stored_Data addObject:storedDeviceCell];
            NSLog(@"ADdobject_peripheral = %@", peripheral);
            [central connectPeripheral:peripheral options:nil];
        }
    }
}

//---------------------- Core Bluetooth Delegate - 當連接到 Peripheral 時的 Delegate ------------------
- (void) centralManager          :(CBCentralManager *) central
         didConnectPeripheral    :(CBPeripheral *)     peripheral {
    NSLog(@"didConnectPeripheral.peripheral = %@", peripheral);
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

//---------------------- Core Bluetooth Delegate - 發現到 Services 時的 Delegate ------------------
- (void)     peripheral              :(CBPeripheral *)   peripheral
             didDiscoverServices     :(NSError *)        error {
    NSLog(@"didDiscoverServices.services = %@", [peripheral services]);
    /**
     0 為 Device Information
     1 不確定
     2 為 FFF0 所在的位置 也就是放 Bluetooth 資訊的位置
     */
    [peripheral discoverCharacteristics:nil
                             forService:[[peripheral services] objectAtIndex:2]];
}

//---------------------- Core Bluetooth Delegate - 發現到 Characteristics 時的 Delegate ------------------
- (void) peripheral                              : (CBPeripheral *)   peripheral
         didDiscoverCharacteristicsForService    : (CBService *)      service
         error                                   : (NSError *)        error {
    NSLog(@"didDiscoverCharacteristicsForService.Characteristic = %@", [service characteristics]);
    /**
     notify 剛進來的 characteristic.
     因為 Device 回傳的資訊來自於FFF1 而 FFF1 在 service 中的 index 為 0
     因此設為 0
     */
    CBCharacteristic *CBChar = [[service characteristics] objectAtIndex:0];
    // ---------------------- 設置 Characteristics 改變時的 Delegate ----------------------
    [peripheral setNotifyValue:true forCharacteristic:CBChar];
}

//---------------------- Core Bluetooth Delegate - Characteristics 改變時的 Delegate ------------------
- (void)    peripheral                          :(CBPeripheral *)       peripheral
            didUpdateValueForCharacteristic     :(CBCharacteristic *)   characteristic
            error                               :(NSError *)            error {
    NSLog(@"didUpdateValueForCharacteristic");
    NSLog(@"characteristic = %@", [characteristic value]);
    NSLog(@"BLE.Delegate = %@", self.delegate);
    if(self.delegate.class == Sensor4310MainBarViewController.class) {
        NSLog(@"TestClass = %@", self.delegate.class);
        NSLog(@"TestClass2 = %@", Sensor4310MainBarViewController.class);
        //[self.delegate addNewDevice:peripheral];
        [self.delegate updateCharacteristic:peripheral characteristic:characteristic];
    }
    // TestForBusy
    [self.delegate updateForBusy:self.Stored_Data];
    // ---------------------- Stored Devices 在這次的 index ----------------------
    int8_t Index_Of_Stored_Devices = [self getIndexOfStoredDevices:peripheral storedData:self.Stored_Data];
    NSLog(@"Index_Of_Stored_Devices = %hhd", Index_Of_Stored_Devices);
    NSLog(@"characteristic.value = %@", [characteristic value]);

    // ---------------------- KS-4310 ----------------------
    if([[peripheral name] isEqual:@"KS-4310"]) {
        NSLog(@"it'sKS-4310");
        // ---------------------- 上的 Cell ----------------------
        StoredDevicesCell *Previous_Stored_Deivce_Cell = [[StoredDevicesCell alloc] init];
        NSLog(@"Index_Of_Stored_Devices = %hhd", Index_Of_Stored_Devices);
        Previous_Stored_Deivce_Cell = [self.Stored_Data objectAtIndex:Index_Of_Stored_Devices];
        
        /**
         * 在首次進入時會 write 04 並且會獲得記憶體回傳的 04........ update value
         * 一般情況下會持續收到 00....... update value
         * write 05 後會收到0555AA後再 write 04 並會因此收到記憶體回傳的 04....... update value
         */
        // ---------------------- 如果是首次進入 ----------------------
        if(!Previous_Stored_Deivce_Cell.Characteristic) {
            NSLog(@"首次進入喔");
            /* Write 04 to get device memory */
            [self write04ToKS4310:peripheral];
        }
        // ---------------------- 判別這次手機發出的模式 ----------------------
        NSData *Mode_Identifier = [[characteristic value] subdataWithRange:NSMakeRange(0, 1)];
        // ---------------------- Mode_Identifier == @"00" ----------------------
        if([Mode_Identifier isEqual:ks4310Setting.Sense_Identifier]) {
            // ---------------------- Movement ----------------------
            // 如果上次的 Device Information 已經被給值
            // 也就是說已經上傳過資訊至 Stored_Data
            if([Previous_Stored_Deivce_Cell Device_Information]) {
                NSLog(@"Previous_Stored_Deivce_Cell = %@", Previous_Stored_Deivce_Cell);
                // ---------------------- 更新 Movement state array ----------------------
                NSMutableArray *Movement_State_Array = [convert4310Information movementStateRefresh : [characteristic value]
                                                                               storedDeviceCell     : Previous_Stored_Deivce_Cell
                                                                               movementScanTime     : ks4310Setting.Movement_Scan_Time];
                NSLog(@"Movement_State_Array = %@", Movement_State_Array);

                // 取得 Breath status
                BOOL Breath_Status = [convert4310Information getMovementNormal:Movement_State_Array ScanTime:ks4310Setting.Movement_Scan_Time];
                // ---------------------- 更新裝置感測資訊至 Storeed_Data ----------------------
                StoredDevicesCell *storedDevicesCell = [StoredDevicesCell alloc];
                storedDevicesCell = [BLE.Stored_Data objectAtIndex:Index_Of_Stored_Devices];
                NSLog(@"Test_Duplicate_Before_Peripheral1 = %@", [storedDevicesCell Peripheral]);
                [storedDevicesCell setPeripheral:peripheral];
                [storedDevicesCell setCharacteristic:[characteristic value]];
                [storedDevicesCell setDevice_Information:[characteristic value]];
                [storedDevicesCell setStored_Movement_State:Movement_State_Array];
                NSLog(@"Test_Duplicate_After_Peripheral1 = %@", [storedDevicesCell Peripheral]);
                [self.Stored_Data replaceObjectAtIndex:Index_Of_Stored_Devices withObject:storedDevicesCell];
                
                // ---------------------- Publish 至 ouhub ---------------------
                // 假如已取得 OTP 則利用 MQTT Publish 至 Server
                if(MqttMain.Client_ID) {
                    NSLog(@"Publish -- MqttMain.Client_ID = %@", MqttMain.Client_ID);
                    NSLog(@"storedDevicesCell.Device_EPROM = %@", storedDevicesCell.Device_EPROM);
                    NSLog(@"storedDevicesCell.Device_UUID = %@", storedDevicesCell.Device_UUID);
                    if(storedDevicesCell.Device_EPROM && storedDevicesCell.Device_UUID) {
                        NSLog(@"TestForModelInPublishTest = %@", storedDevicesCell.Device_Model);
                        NSLog(@"PublishTestStart");
                        [MqttMain publishTest:storedDevicesCell.Device_Model
                                 deviceSerial:storedDevicesCell.Device_EPROM
                                   deviceUUID:storedDevicesCell.Device_UUID
                                           t1:[convert4310Information getTemperature_1:[characteristic value]]
                                           t2:[convert4310Information getTemperature_2:[characteristic value]]
                                           t3:[convert4310Information getTemperature_3:[characteristic value]]
                                      battery:(int) [convert4310Information getBattery_Volume:[characteristic value]]
                                       breath:Breath_Status
                                      motionX:10
                                      motionY:20
                                      motionZ:30];
                    }
                }
            }
            else {
                // ---------------------- 首次更新裝置感測資訊至 Storeed_Data ----------------------
                // ---------------------- 與上差別在於無更新呼吸起伏 ----------------------
                [self firstTimeRefreshSensorInformationToStored:self.Stored_Data
                                                          index:Index_Of_Stored_Devices
                                                     peripheral:peripheral
                                                     storedCell:Previous_Stored_Deivce_Cell
                                    incomingCharacteristicValue:[characteristic value]];
            }
        }
        // ---------------------- Mode_Identifier == @"04" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Baby_Information_Identifier]) {
            [self refreshBabyInformationToStored:self.Stored_Data
                                           index:Index_Of_Stored_Devices
                                      peripheral:peripheral
                                      storedCell:Previous_Stored_Deivce_Cell
                     incomingCharacteristicValue:[characteristic value]];
            // 向伺服器查證該裝置是否已註冊
            NSData *EPROM = [NSData alloc];
            EPROM = [[characteristic value] subdataWithRange:NSMakeRange(1, 11)];
            NSLog(@"Device eprom = %@", EPROM);
            
            NSString *newStr = [[NSString alloc] initWithData:EPROM encoding:NSASCIIStringEncoding];
            NSLog(@"newStrForEPROM = %@", newStr);
            
            NSString *EPROM_String = [self stringToHex:newStr];
            NSLog(@"NewNewHexString = %@", EPROM_String);
            
            StoredDevicesCell *testStoredDeivicesCell = [self.Stored_Data objectAtIndex:Index_Of_Stored_Devices];
            if(testStoredDeivicesCell.Device_EPROM) {
                NSLog(@"EPROM Live");
            } else {
                NSLog(@"EPROM Not Live");
            }
            
            // 在取得裝置 EPROM 後更新 Stored_Data
            NSLog(@"***** Set KS-4310 EPROM To Stored_Data Serial *****");
            testStoredDeivicesCell.Device_EPROM = EPROM_String;
            [self.Stored_Data replaceObjectAtIndex:Index_Of_Stored_Devices
                                        withObject:testStoredDeivicesCell];
            
            NSLog(@"EPROM = %@", EPROM);
            NSLog(@"OAuth.Access_Token = %@", OAuth.Access_Token);
            if(EPROM && OAuth.Access_Token) {
                NSLog(@"EPROM and OTP LIVE");
                // 像伺服器求 Device UUID
                [OAuth connectDeviceToServer:EPROM];
            }
        }
        // ---------------------- Mode_Identifier == @"05" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Write_Identifier]) {
            // ---------------------- Write 04 ----------------------
            [self write04ToKS4310:peripheral];
        }
    }
}

//---------------------- Core Bluetooth Delegate - Device 斷線------------------
-(void)     centralManager : (CBCentralManager *) central
   didDisconnectPeripheral : (CBPeripheral *) peripheral
                     error : (NSError *) error {
    uint8_t Index_Of_Disconnected_Device = [self getIndexOfStoredDevices:peripheral
                                                              storedData:self.Stored_Data];
    [self.Stored_Data removeObjectAtIndex:Index_Of_Disconnected_Device];
    [self.delegate deleteStoredDataCell];
}

#pragma mark - Methods
// ---------------------- 新增裝置至 Stored_Data ----------------------
- (void) addNewDeviceToStored : (NSMutableArray *)  stored_Devices
         peripheral :           (CBPeripheral *)    peripheral {
    [storedDevicesCell  cell                        : peripheral
                        characteristic              : nil
                        deviceInformation           : nil
                        babyInformation             : nil
                        storedMovementState         : [[NSMutableArray alloc] init]
                        deviceName                  : nil
                        deviceID                    : nil
                        deviceSex                   : nil
                        deviceModel                 : nil
                        deviceEPROM                 : nil
                        deviceUUID                  : nil
                        deviceStatus                : nil];
    
    [stored_Devices addObject:storedDevicesCell];
    NSLog(@"self.delegate in addNewDevice = %@", self.delegate);
}

// ---------------------- 更新裝置感測資訊至 Storeed_Data ----------------------
- (void)  refreshSensorInformationToStored : (NSMutableArray *) stored_Data
                                     index : (u_int8_t) index
                                peripheral : (CBPeripheral *) peripheral
                                storedCell : (StoredDevicesCell *) stored_Cell
               incomingCharacteristicValue : (NSData *) incoming_Characteristic_Value
                        movementStateArray : (NSMutableArray *) movement_State_Array {
    NSLog(@"***** 更新裝置感測資訊(Characteristic)至 Stored_Data *****");
    stored_Cell.Peripheral = peripheral;
    stored_Cell.Characteristic = incoming_Characteristic_Value;
    stored_Cell.Device_Information = incoming_Characteristic_Value;
    stored_Cell.Stored_Movement_State = movement_State_Array;
    [stored_Data replaceObjectAtIndex:index withObject:stored_Cell];
}

// ---------------------- 更新 Baby Information 資訊至 Storeed_Data ----------------------
- (void)  refreshBabyInformationToStored : (NSMutableArray *) stored_Data
                                     index : (u_int8_t) index
                                peripheral : (CBPeripheral *) peripheral
                                storedCell : (StoredDevicesCell *) stored_Cell
               incomingCharacteristicValue : (NSData *) incoming_Characteristic_Value {
    NSLog(@"***** 更新 Baby Information 資訊至 Storeed_Data *****");
    stored_Cell.Peripheral = peripheral;
    stored_Cell.Characteristic = incoming_Characteristic_Value;
    stored_Cell.Baby_Information = incoming_Characteristic_Value;
    [stored_Data replaceObjectAtIndex:index withObject:stored_Cell];
}

// ---------------------- 首次更新裝置感測資訊至 Storeed_Data ----------------------
// ---------------------- 與上差別在於無更新呼吸起伏 ----------------------
- (void)  firstTimeRefreshSensorInformationToStored : (NSMutableArray *) stored_Data
                                              index : (u_int8_t) index
                                         peripheral : (CBPeripheral *) peripheral
                                         storedCell : (StoredDevicesCell *) stored_Cell
                        incomingCharacteristicValue : (NSData *) incoming_Characteristic_Value {
    NSLog(@"***** 首次更新裝置感測資訊至 Storeed_Data *****");
    stored_Cell.Peripheral = peripheral;
    stored_Cell.Characteristic = incoming_Characteristic_Value;
    stored_Cell.Device_Information = incoming_Characteristic_Value;
    [stored_Data replaceObjectAtIndex:index withObject:stored_Cell];
}

// ---------------------- 判斷新搜尋到的 Device 有沒有在已搜尋到的裝置中 ----------------------
- (BOOL) searchSDDeviceContain : (CBPeripheral *)   peripheral
             stored_Peripheral : (NSMutableArray *) stored_Peripheral {
    BOOL Device_Contain = NO;
    NSLog(@"stored_Peripheral = %@", stored_Peripheral);
    for(NSUInteger i = 0;i < [stored_Peripheral count]; i++) {
        NSLog(@"Duplicate_Test_stored_Peripheral_Index = %lu", (unsigned long)i);
        NSLog(@"Duplicate_Test_stored_Peripheral = %@", [[stored_Peripheral objectAtIndex:i] identifier]);
        NSLog(@"Duplicate_Test_stored_Peripheral_Test = %@", [peripheral identifier]);
        NSString *device_Identifier = [[stored_Peripheral objectAtIndex:i] identifier];
        if([device_Identifier isEqual:[peripheral identifier]]) {
            Device_Contain = YES;
            break;
        }
    }
    NSLog(@"Device_ContainTest = %@", [NSNumber numberWithBool:Device_Contain]);
    return Device_Contain;
}
// ---------------------- 將 Stored_Devices 裡面的 Peripheral 另外取出為 NSMutableArray -----------------
- (NSMutableArray *) getStoredDataPeripheralArray : (NSMutableArray *) Stored_Data {
    NSMutableArray *Stored_Devices_Peripheral = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < [self.Stored_Data count]; i++) {
        [Stored_Devices_Peripheral addObject:[[Stored_Data objectAtIndex:i] Peripheral]];
    }
    return Stored_Devices_Peripheral;
}

// ---------------------- 找出 Stored_Devices 在這次的 index -----------------
- (int8_t) getIndexOfStoredDevices : (CBPeripheral *) Peripheral
                        storedData : (NSMutableArray *) Stored_Data {
    for(uint8_t i = 0; i < [Stored_Data count]; i++) {
        NSLog(@"Test_Stored_data = %@", [[[Stored_Data objectAtIndex:i] Peripheral] identifier]);
    }
    for(uint8_t i = 0; i < [Stored_Data count]; i++)
    {
        NSLog(@"TestIndexGet -- [Stored_data count] = %lu", (unsigned long)[Stored_Data count]);
        NSLog(@"TestIndexGet -- StoredPeripheral = %@", [[[Stored_Data objectAtIndex:i] Peripheral] identifier]);
        NSLog(@"TestIndexGet -- peripheral = %@", [Peripheral identifier]);
        if([[[[Stored_Data objectAtIndex:i] Peripheral] identifier] isEqual: [Peripheral identifier]])
        {
            return i;
            break;
        }
    }
    return -1;
}

// ---------------------- 將 String 轉換為 NSData -----------------
- (NSData *) stringToNSData : (NSString *) data_String {
    NSString *command = data_String;

    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    NSLog(@"commandToSend = %@", commandToSend);
    return commandToSend;
}

// ---------------------- Write 04 -----------------
- (void)
write04ToKS4310     : (CBPeripheral *) Peripheral
{
    CBPeripheral *peripheral = Peripheral;
    CBService *service = [[peripheral services] objectAtIndex:2];
    CBCharacteristic *characteristic = [[service characteristics] objectAtIndex:2];
    
    //wirte to get information setting in device.
 
    const uint8_t bytes[] = {0x04};
    
    NSData *data = [NSData dataWithBytes:bytes
                                  length:sizeof(bytes)];
    [peripheral writeValue : data
         forCharacteristic : characteristic
                      type : CBCharacteristicWriteWithResponse];
}

// ---------------------- Timer Write 04 -----------------
- (void)
timerWrite04ToKS4310 : (CBPeripheral *) peripheral
{
    CBService *service = [[peripheral services] objectAtIndex:2];
    CBCharacteristic *characteristic = [[service characteristics] objectAtIndex:2];
    
    //wirte to get information setting in device.
 
    const uint8_t bytes[] = {0x04};
    
    NSData *data = [NSData dataWithBytes:bytes
                                  length:sizeof(bytes)];
    [peripheral writeValue : data
         forCharacteristic : characteristic
                      type : CBCharacteristicWriteWithResponse];
}

// ---------------------- Write 05 -----------------
- (void)
write05ToKS4310     : (CBPeripheral *) Peripheral
{
    CBPeripheral *peripheral = Peripheral;
    CBService *service = [[peripheral services] objectAtIndex:2];
    CBCharacteristic *characteristic = [[service characteristics] objectAtIndex:2];
    
    //wirte to get information setting in device.
 
    const uint8_t bytes[] = {0x05, 0x00};
    
    NSData *data = [NSData dataWithBytes:bytes
                                  length:sizeof(bytes)];
    [peripheral writeValue : data
         forCharacteristic : characteristic
                      type : CBCharacteristicWriteWithResponse];
}
// ---------------------- Write 05 to EPROM -----------------
- (void)
write05ToKS4310EPROM     : (CBPeripheral *) Peripheral
data                     : (NSData *)       Data
{
    CBPeripheral *peripheral = Peripheral;
    CBService *service = [[peripheral services] objectAtIndex:2];
    CBCharacteristic *characteristic = [[service characteristics] objectAtIndex:2];
    
    [peripheral writeValue : Data
         forCharacteristic : characteristic
                      type : CBCharacteristicWriteWithResponse];
}

#pragma mark METHODS
// String to HEX
- (NSString *) stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];

    NSMutableString *hexString = [[NSMutableString alloc] init];

    for(NSUInteger i = 0; i < len; i++ )
    {
        // [hexString [NSString stringWithFormat:@"%02x", chars[i]]]; /*previous input*/
        [hexString appendFormat:@"%02x", chars[i]]; /*EDITED PER COMMENT BELOW*/
    }

    return hexString;
}
// hexStringToData
- (NSData *) hexStringToData : (NSString *) Hex_String {
    NSString *command = Hex_String;

    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    NSLog(@"%@", commandToSend);
    return commandToSend;
}

// ------------- 連接裝置以用來知道是否註冊 如未註冊則註冊 -------------
- (void) detectDevicesConnect :(NSTimer*)sender {
    NSLog(@"Detect Devices Connect = %@", OAuth.Access_Token);
    
    if(OAuth.Access_Token) {
        for(int i = 0; i < BLE.Stored_Data.count; i++) {
            StoredDevicesCell *storedDevicesCell = [StoredDevicesCell alloc];
            storedDevicesCell = [BLE.Stored_Data objectAtIndex:i];
            NSString *EPROM_String = storedDevicesCell.Device_EPROM;
            NSString *UUID_String = storedDevicesCell.Device_UUID;
            NSLog(@"Test for register -- 4310 EPROM = %@", EPROM_String);
            NSLog(@"Test for register -- 4310 UUID String = %@", UUID_String);
            if(!UUID_String) {
                NSData* EPROM = [self hexStringToData:EPROM_String];
                NSLog(@"EPROM in timer = %@", EPROM);
                [OAuth connectDeviceToServer:EPROM];
            }
        }
    }
}
- (void) disable {
    if(BLEConnectServerTimer) {
        [BLEConnectServerTimer invalidate];
    }
}
@end
