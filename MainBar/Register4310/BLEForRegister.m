//
//  BLEForRegister.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/9.
//

#import "BLEForRegister.h"

@interface BLEForRegister ()
@property(strong, nonatomic) NSMutableArray *Stored_Data;
@end

@implementation BLEForRegister

- (instancetype) init {
    self.Stored_Data = [[NSMutableArray alloc] init];
    
    return self;
}
#pragma mark - Core Bluetooth Delegate
//---------------------- Core Bluetooth Delegate - CB Central Manager 狀態變更時的 Delegate ------------------
- (void) centralManagerDidUpdateState : (CBCentralManager *) central {
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
        centralManager        : (CBCentralManager *)            central
        didDiscoverPeripheral : (CBPeripheral *)                peripheral
        advertisementData     : (NSDictionary<NSString *,id> *) advertisementData
        RSSI                  : (NSNumber *)                    RSSI {
    // ---------------------- 篩選出 Device name 為 KS-4310 的裝置 ----------------------
    if([peripheral.name isEqual: @"KS-4310"]) {
        BOOL Device_Contain = NO;
        //* 判斷新搜尋到的 Device 有沒有在已搜尋到的裝置中 */
        for(int i = 0; i < self.Stored_Data.count; i++) {
            StoredDevicesCell *cell = [StoredDevicesCell alloc];
            cell = [self.Stored_Data objectAtIndex:i];
            if([peripheral.identifier isEqual:cell.Peripheral.identifier]) {
                Device_Contain = YES;
                break;
            }
        }
        // ---------------------- 如果已搜尋到的 Stored_Devices 中不包含新搜尋到的 Device ----------------------
        if(Device_Contain == NO) {
            /* 新增至 Stored_Devices */
            StoredDevicesCell *cell = [StoredDevicesCell alloc];
            [cell cell:peripheral
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
          deviceStatus:nil
             serialBeenRegister:-1];
            
            [self.Stored_Data addObject:cell];
            
            /* 連接 Peripheral */
            [central connectPeripheral:peripheral options:nil];
        }
    }
}

//---------------------- Core Bluetooth Delegate - 當連接到 Peripheral 時的 Delegate ------------------
- (void) centralManager       : (CBCentralManager *) central
         didConnectPeripheral : (CBPeripheral *)     peripheral {
    NSLog(@"didConnectPeripheral.peripheral = %@", peripheral);
    peripheral.delegate = self;
    /* Discover services */
    [peripheral discoverServices:nil];
}

//---------------------- Core Bluetooth Delegate - 發現到 Services 時的 Delegate ------------------
- (void) peripheral          : (CBPeripheral *) peripheral
         didDiscoverServices : (NSError *)      error {
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
- (void) peripheral                           : (CBPeripheral *)   peripheral
         didDiscoverCharacteristicsForService : (CBService *)      service
         error                                : (NSError *)        error {
    NSLog(@"didDiscoverCharacteristicsForService.Characteristic = %@", [service characteristics]);
    /**
     notify 剛進來的 characteristic.
     因為 Device 回傳的資訊來自於FFF1 而 FFF1 在 service 中的 index 為 0
     因此設為 0
     */
    CBCharacteristic *Characteristic = [[service characteristics] objectAtIndex:0];
    // ---------------------- 設置 Characteristics 改變時的 Delegate ----------------------
    [peripheral setNotifyValue:true forCharacteristic:Characteristic];
}

//---------------------- Core Bluetooth Delegate - Characteristics 改變時的 Delegate ------------------
- (void)    peripheral                          :(CBPeripheral *)       peripheral
            didUpdateValueForCharacteristic     :(CBCharacteristic *)   characteristic
            error                               :(NSError *)            error {
    NSLog(@"didUpdateValueForCharacteristic");
    // ---------------------- BLE devices array cell 在這次的 index ----------------------
    NSInteger Index_Of_BLE_Devices_Array_Cell = 0;
    for(NSInteger i = 0; i < self.Stored_Data.count; i++) {
        StoredDevicesCell *cell = [StoredDevicesCell alloc];
        cell = [self.Stored_Data objectAtIndex:i];
        
        if([peripheral.identifier isEqual:cell.Peripheral.identifier]) {
            Index_Of_BLE_Devices_Array_Cell = i;
            break;
        }
    }
    
    // ---------------------- KS-4310 ----------------------
    if([[peripheral name] isEqual:@"KS-4310"]) {
        NSLog(@"it's KS-4310");
        /* 上次的 Cell */
        StoredDevicesCell *cell = [StoredDevicesCell alloc];
        cell = [self.Stored_Data objectAtIndex:Index_Of_BLE_Devices_Array_Cell];
        
        /**
         * 在首次進入時會 write 04 並且會獲得記憶體回傳的 04........ update value
         * 一般情況下會持續收到 00....... update value
         * write 05 後會收到0555AA後再 write 04 並會因此收到記憶體回傳的 04....... update value
         */
        // ---------------------- 如果是首次進入 ----------------------
        if(!cell.Characteristic) {
            NSLog(@"首次進入喔");
            /* Write 04 to get device memory */
            [self write04ToKS4310:peripheral];
        }
        /* 判別這次手機發出的模式 */
        NSData *Mode_Identifier = [[characteristic value] subdataWithRange:NSMakeRange(0, 1)];
        KS4310Setting *ks4310Setting = [KS4310Setting alloc];
        // ---------------------- Mode_Identifier == @"00" ----------------------
        if([Mode_Identifier isEqual:ks4310Setting.Sense_Identifier]) {
            // ---------------------- Movement ----------------------
            /* 如果上次的 Device Information 已經被給值
               也就是說已經上傳過資訊至 Stored_Data       */
            if(cell.Device_Information) {
                NSLog(@"cell = %@", cell);
                // ---------------------- 更新 Movement state array ----------------------
                Convert4310Information *convert4310Information = [Convert4310Information alloc];
                NSMutableArray *Movement_State_Array = [convert4310Information movementStateRefresh : [characteristic value]
                                                                               storedDeviceCell     : cell
                                                                               movementScanTime     : ks4310Setting.Movement_Scan_Time];
                NSLog(@"Movement_State_Array = %@", Movement_State_Array);

                // 取得 Breath status
                BOOL Breath_Status = [convert4310Information getMovementNormal:Movement_State_Array
                                                                      ScanTime:ks4310Setting.Movement_Scan_Time];
                /* 更新裝置感測資訊至 Stored_Data */
                NSLog(@"Test_Duplicate_Before_Peripheral1 = %@", [cell Peripheral]);
                cell.Peripheral = peripheral;
                cell.Characteristic = [characteristic value];
                cell.Device_Information = [characteristic value];
                cell.Stored_Movement_State = Movement_State_Array;
                NSLog(@"Test_Duplicate_After_Peripheral1 = %@", [cell Peripheral]);
                [self.Stored_Data replaceObjectAtIndex:Index_Of_BLE_Devices_Array_Cell
                                            withObject:cell];
            }
            // ---------------------- 首次更新裝置感測資訊至 Storeed_Data ----------------------
            /* 與上差別在於無更新呼吸起伏 */
            else {
                NSLog(@"***** 首次更新裝置感測資訊至 Storeed_Data *****");
                cell.Peripheral = peripheral;
                cell.Characteristic = [characteristic value];
                cell.Device_Information = [characteristic value];
                [self.Stored_Data replaceObjectAtIndex:Index_Of_BLE_Devices_Array_Cell
                                            withObject:cell];
            }
        }
        // ---------------------- Mode_Identifier == @"04" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Baby_Information_Identifier]) {
            NSLog(@"***** 更新 Baby Information 資訊至 Storeed_Data *****");
            cell.Peripheral = peripheral;
            cell.Characteristic = [characteristic value];
            cell.Baby_Information = [characteristic value];
            [self.Stored_Data replaceObjectAtIndex:Index_Of_BLE_Devices_Array_Cell
                                        withObject:cell];
            // 向伺服器查證該裝置是否已註冊
            NSData *EPROM = [NSData alloc];
            EPROM = [[characteristic value] subdataWithRange:NSMakeRange(1, 11)];
            NSLog(@"Device eprom = %@", EPROM);
            
            NSString *newStr = [[NSString alloc] initWithData:EPROM encoding:NSASCIIStringEncoding];
            NSLog(@"newStrForEPROM = %@", newStr);
            
            NSString *EPROM_String = [self stringToHex:newStr];
            NSLog(@"NewNewHexString = %@", EPROM_String);
            
            if(cell.Device_EPROM) {
                NSLog(@"EPROM Live");
            } else {
                NSLog(@"EPROM Not Live");
            }
            
            // 在取得裝置 EPROM 後更新 Stored_Data
            NSLog(@"***** Set KS-4310 EPROM To Stored_Data Serial *****");
            cell.Device_EPROM = EPROM_String;
            [self.Stored_Data replaceObjectAtIndex:Index_Of_BLE_Devices_Array_Cell
                                        withObject:cell];
            
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

// ---------------------- Write 04 -----------------
- (void) write04ToKS4310 : (CBPeripheral *) Peripheral
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
@end
