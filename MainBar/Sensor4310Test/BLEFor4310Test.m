//
//  BLEFor4310Test.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/12.
//

#import "BLEFor4310Test.h"
#import "KS4310Setting.h"
#import "Convert4310Information.h"
@interface BLEFor4310Test ()
{
    KS4310Setting *ks4310Setting;
}

@property(strong, nonatomic) CBCentralManager *CM;
@end

@implementation BLEFor4310Test

- (instancetype) init {
// ---------------------- 初始化 CB Central Manager ----------------------
    ks4310Setting = [KS4310Setting alloc];
    [ks4310Setting InitKS4310Setting];
    
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    return self;
}

- (void) startBLE {
    
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
        NSMutableArray *Stored_Data = [[NSMutableArray alloc] init];
        Stored_Data = [self.delegate getStoredData];
        // ---------------------- 判斷新搜尋到的 Device 有沒有在已搜尋到的裝置中 ----------------------
        BOOL Device_Contain = NO;
        for(int i = 0; i < [Stored_Data count]; i++) {
            if([[peripheral identifier] isEqual:[[[Stored_Data objectAtIndex:i] Peripheral] identifier]]) {
                NSLog(@"Device_Contain = %@", [peripheral identifier]);
                Device_Contain = YES;
                break;
            }
        }
        // ---------------------- 如果已搜尋到的 Stored_Devices 中不包含新搜尋到的 Device ----------------------
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
                      deviceStatus:nil
                serialBeenRegister:-1];
            /* 新增至 Stored_Devices */
            [self.delegate addStoredData:storedDeviceCell];
            
            NSLog(@"ADdobject_peripheral = %@", peripheral);
            /* 連接 Peripheral */
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
/// 0 為 Device Information
/// 1 不確定
/// 2 為 FFF0 所在的位置 也就是放 Bluetooth 資訊的位置
/// @param peripheral Peripheral
/// @param error Error
- (void)     peripheral              :(CBPeripheral *)   peripheral
             didDiscoverServices     :(NSError *)        error {
    NSLog(@"didDiscoverServices.services = %@", [peripheral services]);
    [peripheral discoverCharacteristics:nil
                             forService:[[peripheral services] objectAtIndex:2]];
}

//---------------------- Core Bluetooth Delegate - 發現到 Characteristics 時的 Delegate ------------------
/// notify 剛進來的 characteristic.
/// 因為 Device 回傳的資訊來自於FFF1 而 FFF1 在 service 中的 index 為 0
/// 因此設為 0
/// @param peripheral Peripheral
/// @param service Service
/// @param error Error
- (void) peripheral                              : (CBPeripheral *)   peripheral
         didDiscoverCharacteristicsForService    : (CBService *)      service
         error                                   : (NSError *)        error {
    NSLog(@"didDiscoverCharacteristicsForService.Characteristic = %@", [service characteristics]);
    CBCharacteristic *CBChar = [[service characteristics] objectAtIndex:0];
    // ---------------------- 設置 Characteristics 改變時的 Delegate ----------------------
    [peripheral setNotifyValue:true forCharacteristic:CBChar];
}

//---------------------- Core Bluetooth Delegate - Characteristics 改變時的 Delegate ------------------
- (void)    peripheral                          :(CBPeripheral *)       peripheral
            didUpdateValueForCharacteristic     :(CBCharacteristic *)   characteristic
            error                               :(NSError *)            error {
    NSLog(@"didUpdateValueForCharacteristic");
    
    NSMutableArray *Stored_Data = [self.delegate getStoredData];
    // ---------------------- 篩選出 Device name 為 KS-4310 的裝置 ----------------------
    if([peripheral.name isEqual: @"KS-4310"]) {
        NSLog(@"Characteristic = %@", [characteristic value]);
        int8_t Index_Of_Stored_Devices = [self getIndexOfStoredDevices:peripheral storedData:Stored_Data];
        StoredDevicesCell *Cell_Of_Stored_Devices = [StoredDevicesCell alloc];
        Cell_Of_Stored_Devices = [Stored_Data objectAtIndex:Index_Of_Stored_Devices];
        // ---------------------- 如果是首次進入 ----------------------
        if(!Cell_Of_Stored_Devices.Characteristic) {
            NSLog(@"首次進入喔 Peripheral.identifier = %@", peripheral.identifier);
            /* Write 04 to get device memory */
            [self write04ToKS4310:peripheral];
        }
        // ---------------------- 判別這次手機發出的模式 ----------------------
        NSData *Mode_Identifier = [[characteristic value] subdataWithRange:NSMakeRange(0, 1)];
        /* Mode_Identifier == @"00" */
        if([Mode_Identifier isEqual:ks4310Setting.Sense_Identifier]) {
            // ---------------------- Movement ----------------------
            /* 如果上次的 Device Information 已經被給值
               也就是說已經上傳過資訊至 Stored_Data      */
            if([Cell_Of_Stored_Devices Device_Information]) {
                NSLog(@"0x00 have value");
                /* 更新 Movement state array */
                Convert4310Information *convert4310Information = [Convert4310Information alloc];
                NSMutableArray *Movement_State_Array = [convert4310Information movementStateRefresh : [characteristic value]
                                                                               storedDeviceCell     : Cell_Of_Stored_Devices
                                                                               movementScanTime     : ks4310Setting.Movement_Scan_Time];
                /* 取得 Breath status */
                BOOL Breath_Status = [convert4310Information getMovementNormal:Movement_State_Array ScanTime:ks4310Setting.Movement_Scan_Time];
                /* 更新裝置感測資訊至 Storeed_Data */
                [Cell_Of_Stored_Devices setPeripheral:peripheral];
                [Cell_Of_Stored_Devices setCharacteristic:[characteristic value]];
                [Cell_Of_Stored_Devices setDevice_Information:[characteristic value]];
                [Cell_Of_Stored_Devices setStored_Movement_State:Movement_State_Array];
                [self.delegate replaceStoredData:Index_Of_Stored_Devices cell:Cell_Of_Stored_Devices];
                
                // ---------------------- Publish 至 ouhub ---------------------
                // 先確認是否取得OTP 以及OTP是否過期
                NSTimeInterval OTPTimeInterval = [self.delegate getOTPTimeInterval];
                NSTimeInterval NowTimeInterval = [NSDate date].timeIntervalSince1970;
                NSLog(@"OTPTimeInterval = %f", OTPTimeInterval);
                NSLog(@"NowTimeInterval = %f", NowTimeInterval);
                if(OTPTimeInterval < 1) {
                    NSLog(@"OTPTimeInterval don't get yet!");
                }
                else {
                    // TODO: MQTT Publish
                    // 假如已取得 OTP 則利用 MQTT Publish 至 Server
                    if([self.delegate getClientID]) {
                        NSLog(@"Publish -- MqttMain.Client_ID = %@", [self.delegate getClientID]);
                        NSLog(@"storedDevicesCell.Device_EPROM = %@", Cell_Of_Stored_Devices.Device_EPROM);
                        NSLog(@"storedDevicesCell.Device_UUID = %@", Cell_Of_Stored_Devices.Device_UUID);
                        if(Cell_Of_Stored_Devices.Device_EPROM && Cell_Of_Stored_Devices.Device_UUID) {
                            NSLog(@"TestForModelInPublishTest = %@", Cell_Of_Stored_Devices.Device_Model);
                            NSLog(@"PublishTestStart");
                            [MqttMain publishTest:Cell_Of_Stored_Devices.Device_Model
                                     deviceSerial:Cell_Of_Stored_Devices.Device_EPROM
                                       deviceUUID:Cell_Of_Stored_Devices.Device_UUID
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
            }
            // ---------------------- 首次更新裝置感測資訊至 Storeed_Data ----------------------
            // 與上差別在於無更新呼吸起伏 
            else {
                NSLog(@"***** 首次更新裝置感測資訊至 Storeed_Data *****");
                Cell_Of_Stored_Devices.Peripheral = peripheral;
                Cell_Of_Stored_Devices.Characteristic = [characteristic value];
                Cell_Of_Stored_Devices.Device_Information = [characteristic value];
                [self.delegate replaceStoredData:Index_Of_Stored_Devices cell:Cell_Of_Stored_Devices];
            }
        }
        // ---------------------- Mode_Identifier == @"04" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Baby_Information_Identifier]) {
            NSLog(@"***** 更新 Baby Information 資訊至 Storeed_Data *****");
            Cell_Of_Stored_Devices.Peripheral = peripheral;
            Cell_Of_Stored_Devices.Characteristic = [characteristic value];
            Cell_Of_Stored_Devices.Baby_Information = [characteristic value];
            
            
            NSData *EPROM = [NSData alloc];
            EPROM = [[characteristic value] subdataWithRange:NSMakeRange(1, 11)];
            NSLog(@"Device eprom = %@", EPROM);
            
            NSString *newStr = [[NSString alloc] initWithData:EPROM encoding:NSASCIIStringEncoding];
            NSLog(@"newStrForEPROM = %@", newStr);
            
            NSString *EPROM_String = [self stringToHex:newStr];
            NSLog(@"NewNewHexString = %@", EPROM_String);
            
            /* 在取得裝置 EPROM 後更新 Stored_Data */
            NSLog(@"***** Set KS-4310 EPROM To Stored_Data Serial *****");
            Cell_Of_Stored_Devices.Device_EPROM = [EPROM_String uppercaseString];
            [self.delegate replaceStoredData:Index_Of_Stored_Devices cell:Cell_Of_Stored_Devices];
            
            // TODO:向伺服器查證該裝置是否已註冊
            NSLog(@"EPROM = %@", EPROM);
//            NSLog(@"OAuth.Access_Token = %@", OAuth.Access_Token);
//            if(EPROM && OAuth.Access_Token) {
//                NSLog(@"EPROM and OTP LIVE");
//                // 像伺服器求 Device UUID
//                [OAuth connectDeviceToServer:EPROM];
//            }
        }
        // ---------------------- Mode_Identifier == @"05" ----------------------
        else if([Mode_Identifier isEqual:ks4310Setting.Write_Identifier]) {
            // ---------------------- Write 04 ----------------------
            [self write04ToKS4310:peripheral];
        }
        else {
            
        }
        NSLog(@"Mode_Identifier = %@", Mode_Identifier);
    }
}

//---------------------- Core Bluetooth Delegate - Device 斷線------------------
-(void)     centralManager : (CBCentralManager *) central
   didDisconnectPeripheral : (CBPeripheral *) peripheral
                     error : (NSError *) error {
    NSMutableArray *Stored_Data = [[NSMutableArray alloc] init];
    Stored_Data = [self.delegate getStoredData];
    uint8_t Index_Of_Disconnected_Device = [self getIndexOfStoredDevices:peripheral
                                                              storedData:Stored_Data];
    [self.delegate removeStoredData:Index_Of_Disconnected_Device];
}
#pragma mark - Stored_Data
#pragma mark - METHODS
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

// ---------------------- Write 04 -----------------
- (void)
write04ToKS4310 : (CBPeripheral *) Peripheral
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
#pragma mark - Timer
@end
