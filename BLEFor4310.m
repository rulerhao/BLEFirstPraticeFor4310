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
}
@end

@implementation BLEFor4310
{
//------------ 執行緒 -------------

dispatch_queue_t BLEQueue;
dispatch_queue_t MainQueue;
}
-(instancetype)init {
    CalculateFunc = [CalFunc alloc];
    ks4310Setting = [KS4310Setting alloc];
    [ks4310Setting InitKS4310Setting];
    
    // ---------------------- 初始化 Stored_Data -------------------
    Stored_Data = [[NSMutableArray alloc] init];
    // ---------------------- 初始 cell ----------------------
    storedDevicesCell = [[StoredDevicesCell alloc] init];
    
    BLEQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    MainQueue = dispatch_get_main_queue();
    
    NSLog(@"Delegate = %@", self);
    // ---------------------- 初始化 CB Central Manager ----------------------
    _CM = [[CBCentralManager alloc] initWithDelegate:self queue:BLEQueue];
    
    return self;
}

#pragma mark - Core Bluetooth Delegate

#pragma mark - Core Bluetooth Delegate - CB Central Manager 狀態變更時的 Delegate
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
#pragma mark - Core Bluetooth Delegate - 搜尋到附近的 Peripheral 時的 Delegate
- (void)
        centralManager          :(CBCentralManager *)               central
        didDiscoverPeripheral   :(CBPeripheral *)                   peripheral
        advertisementData       :(NSDictionary<NSString *,id> *)    advertisementData
        RSSI                    :(NSNumber *)                       RSSI {
    // ---------------------- 篩選出 Device name 為 KS-4310 的裝置 ----------------------
    if([peripheral.name isEqual: @"KS-4310"]) {
        // ---------------------- 判斷新搜尋到的 Device 有沒有在已搜尋到的裝置中 ----------------------
        Boolean Device_Contain = [self searchSDDeviceContain:peripheral stored_Peripheral:[self getStoredDataPeripheralArray:Stored_Data]];
        // ---------------------- 如果已搜尋到的 Stored_Devices 中不包含新搜尋到的 Device ----------------------
        if(Device_Contain == false) {
            // ---------------------- 新增至 Stored_Devices ----------------------
            [self addNewDeviceToStored:Stored_Data peripheral:peripheral];
            // ---------------------- 連接 Peripheral ----------------------
            [central connectPeripheral:peripheral options:nil];
        }
    }
}

#pragma mark - Core Bluetooth Delegate - 當連接到 Peripheral 時的 Delegate
- (void) centralManager          :(CBCentralManager *) central
         didConnectPeripheral    :(CBPeripheral *)     peripheral {
    NSLog(@"didConnectPeripheral.peripheral = %@", peripheral);
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

#pragma mark - Core Bluetooth Delegate - 發現到 Services 時的 Delegate
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

#pragma mark - Core Bluetooth Delegate - 發現到 Characteristics 時的 Delegate
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

#pragma mark - Core Bluetooth Delegate - Characteristics 改變時的 Delegate
- (void)    peripheral                          :(CBPeripheral *)       peripheral
            didUpdateValueForCharacteristic     :(CBCharacteristic *)   characteristic
            error                               :(NSError *)            error {
    // ---------------------- Stored Devices 在這次的 index ----------------------
    int8_t Index_Of_Stored_Devices = [self getIndexOfStoredDevices:peripheral];
    
    /**
     * 在首次進入時會 write 04 並且會獲得記憶體回傳的 04........ update value
     * 一般情況下會持續收到 00....... update value
     * write 05 後會收到0555AA後再 write 04 並會因此收到記憶體回傳的 04....... update value
     */
    // ---------------------- KS-4310 ----------------------
    if([[peripheral name] isEqual:@"KS-4310"]) {
        // ---------------------- 判別這次手機發出的模式 ----------------------
        NSData *Mode_Identifier = [[characteristic value] subdataWithRange:NSMakeRange(0, 1)];
        
        // ---------------------- Mode_Identifier == @"00" ----------------------
        if([Mode_Identifier isEqual:ks4310Setting.Sense_Identifier]) {
            NSLog(@"Characteristic = %@", characteristic);
            NSMutableArray *now_Stored_Movement_State = [[Stored_Data objectAtIndex:Index_Of_Stored_Devices] Stored_Movement_State];
            NSString *Previous_Characteristic = [CalculateFunc getHEX:[[[Stored_Data objectAtIndex:Index_Of_Stored_Devices] Previous_Device_Information] value]];
//            if() {
//
//            }
            [storedDevicesCell  cell                        : peripheral
                                nowDeviceInformation        : characteristic
                                previousDeviceInformation   : [[Stored_Data objectAtIndex:Index_Of_Stored_Devices] Now_Device_Information]
                                babyInformation             : [[Stored_Data objectAtIndex:Index_Of_Stored_Devices] Baby_Information]
                                storedMovementState         : nil
                                deviceName                  : [[Stored_Data objectAtIndex:Index_Of_Stored_Devices] Device_Name]
                                deviceID                    : [[Stored_Data objectAtIndex:Index_Of_Stored_Devices] Device_ID]
                                deviceSex                   : [[Stored_Data objectAtIndex:Index_Of_Stored_Devices] Device_Sex]];
            [Stored_Data replaceObjectAtIndex:Index_Of_Stored_Devices withObject:storedDevicesCell];
        }
        // ---------------------- Mode_Identifier == @"05" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Write_Identifier]) {
            
        }
        // ---------------------- Mode_Identifier == @"04" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Baby_Information_Identifier]) {
            
        }
    }
}

#pragma mark - Methods
// ---------------------- 新增裝置至 Stored_Devices ----------------------
- (void) addNewDeviceToStored : (NSMutableArray *)  stored_Devices
         peripheral :           (CBPeripheral *)    peripheral {
    [storedDevicesCell cell:peripheral
       nowDeviceInformation:nil
  previousDeviceInformation:nil
            babyInformation:nil
        storedMovementState:[[NSMutableArray alloc] init]
                 deviceName:nil
                   deviceID:nil
                  deviceSex:nil];
    [Stored_Data addObject:storedDevicesCell];
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
- (NSMutableArray *) getStoredDataPeripheralArray : (NSMutableArray *) stored_Data {
    NSMutableArray *Stored_Devices_Peripheral = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < [stored_Data count]; i++) {
        [Stored_Devices_Peripheral addObject:[[stored_Data objectAtIndex:i] Peripheral]];
    }
    return Stored_Devices_Peripheral;
}

// ---------------------- 找出 Stored_Devices 在這次的 index -----------------
- (int8_t) getIndexOfStoredDevices : (CBPeripheral *) peripheral {
    for(uint8_t i = 0; i < [Stored_Data count]; i++)
        if([[Stored_Data objectAtIndex:i] Peripheral] == peripheral)
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
@end
