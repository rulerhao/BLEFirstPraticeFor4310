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
    
    BLEQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    MainQueue = dispatch_get_main_queue();
    
    NSLog(@"Delegate = %@", self);
    // ---------------------- 初始化 CB Central Manager ----------------------
    _CM = [[CBCentralManager alloc] initWithDelegate:self queue:BLEQueue];
    
    //Return_HTML_String = [NSString stringWithFormat:@"%@", result];
    NSMutableArray *Testttt;
    
    [[NSNotificationCenter defaultCenter]
        postNotificationName:@"NotificationName" //Notification以一個字串(Name)下去辨別
        object:self
        userInfo:Testttt];
    
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
        // ---------------------- 判斷新搜尋到的 Device 有沒有在已搜尋到的裝置中 ----------------------
        Boolean Device_Contain = [self searchSDDeviceContain:peripheral stored_Peripheral:[self getStoredDataPeripheralArray:self.Stored_Data]];
        // ---------------------- 如果已搜尋到的 Stored_Devices 中不包含新搜尋到的 Device ----------------------
        if(Device_Contain == false) {
            // ---------------------- 新增至 Stored_Devices ----------------------
            [self addNewDeviceToStored:self.Stored_Data peripheral:peripheral];
            [self.delegate addNewDevice:peripheral];
            // ---------------------- 連接 Peripheral ----------------------
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
    int8_t Index_Of_Stored_Devices = [self getIndexOfStoredDevices:peripheral];
    NSLog(@"characteristic.value = %@", [characteristic value]);
    /**
     * 在首次進入時會 write 04 並且會獲得記憶體回傳的 04........ update value
     * 一般情況下會持續收到 00....... update value
     * write 05 後會收到0555AA後再 write 04 並會因此收到記憶體回傳的 04....... update value
     */
    // ---------------------- KS-4310 ----------------------
    if([[peripheral name] isEqual:@"KS-4310"]) {
        NSLog(@"it'sKS-4310");
        // ---------------------- 該次的 Cell ----------------------
        StoredDevicesCell *Previous_Stored_Deivce_Cell = [[StoredDevicesCell alloc] init];
        Previous_Stored_Deivce_Cell = [self.Stored_Data objectAtIndex:Index_Of_Stored_Devices];


        // ---------------------- 判別這次手機發出的模式 ----------------------
        NSData *Mode_Identifier = [[characteristic value] subdataWithRange:NSMakeRange(0, 1)];
        
        // ---------------------- 如果是首次進入 ----------------------
        if(!Previous_Stored_Deivce_Cell.Characteristic) {
            NSLog(@"首次進入喔");
            /* Write 04 to get device memory */
            [self write04ToKS4310:peripheral];
        }
        // ---------------------- Mode_Identifier == @"00" ----------------------
        if([Mode_Identifier isEqual:ks4310Setting.Sense_Identifier]) {
            // ---------------------- Movement ----------------------
            // ---------------------- 如果上次的 Device Information 已經被給值 ----------------------
            if([Previous_Stored_Deivce_Cell Device_Information]) {
                NSLog(@"Previous_Stored_Deivce_Cell = %@", Previous_Stored_Deivce_Cell);
                // ---------------------- 更新 Movement state array ----------------------
                NSMutableArray *Movement_State_Array = [convert4310Information movementStateRefresh : [characteristic value]
                                                                               storedDeviceCell     : Previous_Stored_Deivce_Cell
                                                                               movementScanTime     : ks4310Setting.Movement_Scan_Time];
                NSLog(@"Movement_State_Array = %@", Movement_State_Array);

                // ---------------------- 更新裝置感測資訊至 Storeed_Data ----------------------
                [self refreshSensorInformationToStored:self.Stored_Data index:Index_Of_Stored_Devices peripheral:peripheral storedCell:Previous_Stored_Deivce_Cell incomingCharacteristicValue:[characteristic value] movementStateArray:Movement_State_Array];
            }
            else {
                // ---------------------- 首次更新裝置感測資訊至 Storeed_Data ----------------------
                // ---------------------- 與上差別在於無更新呼吸起伏 ----------------------
                [self firstTimeRefreshSensorInformationToStored:self.Stored_Data index:Index_Of_Stored_Devices peripheral:peripheral storedCell:Previous_Stored_Deivce_Cell incomingCharacteristicValue:[characteristic value]];
            }
        }
        // ---------------------- Mode_Identifier == @"04" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Baby_Information_Identifier]) {
            [self refreshBabyInformationToStored:self.Stored_Data index:Index_Of_Stored_Devices peripheral:peripheral storedCell:Previous_Stored_Deivce_Cell incomingCharacteristicValue:[characteristic value]];
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
    uint8_t Index_Of_Disconnected_Device = [self getIndexOfStoredDevices:peripheral];
    [self.Stored_Data removeObjectAtIndex:Index_Of_Disconnected_Device];
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
                        deviceSex                   : nil];
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
    [stored_Cell  cell                        : peripheral
                  characteristic              : incoming_Characteristic_Value
                  deviceInformation           : incoming_Characteristic_Value
                  babyInformation             : stored_Cell.Baby_Information
                  storedMovementState         : movement_State_Array
                  deviceName                  : stored_Cell.Device_Name
                  deviceID                    : stored_Cell.Device_ID
                  deviceSex                   : stored_Cell.Device_Sex];
    [stored_Data replaceObjectAtIndex:index withObject:stored_Cell];
}

// ---------------------- 更新 Baby Information 資訊至 Storeed_Data ----------------------
- (void)  refreshBabyInformationToStored : (NSMutableArray *) stored_Data
                                     index : (u_int8_t) index
                                peripheral : (CBPeripheral *) peripheral
                                storedCell : (StoredDevicesCell *) stored_Cell
               incomingCharacteristicValue : (NSData *) incoming_Characteristic_Value {
    [stored_Cell  cell                        : peripheral
                  characteristic              : incoming_Characteristic_Value
                  deviceInformation           : stored_Cell.Device_Information
                  babyInformation             : incoming_Characteristic_Value
                  storedMovementState         : stored_Cell.Stored_Movement_State
                  deviceName                  : stored_Cell.Device_Name
                  deviceID                    : stored_Cell.Device_ID
                  deviceSex                   : stored_Cell.Device_Sex];
    [stored_Data replaceObjectAtIndex:index withObject:stored_Cell];
}

// ---------------------- 首次更新裝置感測資訊至 Storeed_Data ----------------------
// ---------------------- 與上差別在於無更新呼吸起伏 ----------------------
- (void)  firstTimeRefreshSensorInformationToStored : (NSMutableArray *) stored_Data
                                              index : (u_int8_t) index
                                         peripheral : (CBPeripheral *) peripheral
                                         storedCell : (StoredDevicesCell *) stored_Cell
                        incomingCharacteristicValue : (NSData *) incoming_Characteristic_Value {
    [stored_Cell  cell                        : peripheral
                  characteristic              : incoming_Characteristic_Value
                  deviceInformation           : incoming_Characteristic_Value
                  babyInformation             : stored_Cell.Baby_Information
                  storedMovementState         : stored_Cell.Stored_Movement_State
                  deviceName                  : stored_Cell.Device_Name
                  deviceID                    : stored_Cell.Device_ID
                  deviceSex                   : stored_Cell.Device_Sex];
    [stored_Data replaceObjectAtIndex:index withObject:stored_Cell];
}
// ---------------------- 判斷新搜尋到的 Device 有沒有在已搜尋到的裝置中 ----------------------
- (BOOL) searchSDDeviceContain : (CBPeripheral *)   peripheral
             stored_Peripheral : (NSMutableArray *) stored_Peripheral {
    BOOL Device_Contain = NO;
    for(NSUInteger i = 0;i < [stored_Peripheral count]; i++) {
        NSString *device_Identifier = [[stored_Peripheral objectAtIndex:i] identifier];
        if([device_Identifier isEqual:[peripheral identifier]]) {
            Device_Contain = YES;
            break;
        }
    }
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
- (int8_t) getIndexOfStoredDevices : (CBPeripheral *) peripheral {
    for(uint8_t i = 0; i < [self.Stored_Data count]; i++)
        if([[self.Stored_Data objectAtIndex:i] Peripheral] == peripheral)
            return i;
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

@end
