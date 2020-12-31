//
//  StoredDevicesCell.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/30.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
NS_ASSUME_NONNULL_BEGIN

@interface StoredDevicesCell : NSObject
{
    CBPeripheral *Peripheral;
    CBCharacteristic *Now_Device_Information;
    CBCharacteristic *Previous_Device_Information;
    CBCharacteristic *Baby_Information;
    NSMutableArray *Stored_Movement_State;
    NSString *Device_Name;
    NSString *Device_ID;
    NSString *Device_Sex;
}

- (void)
cell                        : (nullable CBPeripheral *)     Peripheral
nowDeviceInformation        : (nullable CBCharacteristic *) Now_Device_Information
previousDeviceInformation   : (nullable CBCharacteristic *) Previous_Device_Information
babyInformation             : (nullable CBCharacteristic *) Baby_Information
storedMovementState         : (nullable NSMutableArray *)   Stored_Movement_State
deviceName                  : (nullable NSString *)         Device_Name
deviceID                    : (nullable NSString *)         Device_ID
deviceSex                   : (nullable NSString *)         Device_Sex;

@property (readwrite, nonatomic) CBPeripheral *Peripheral;
@property (readwrite, nonatomic) CBCharacteristic *Now_Device_Information;
@property (readwrite, nonatomic) CBCharacteristic *Previous_Device_Information;
@property (readwrite, nonatomic) CBCharacteristic *Baby_Information;
@property (readwrite, nonatomic) NSMutableArray *Stored_Movement_State;
@property (readwrite, nonatomic) NSString *Device_Name;
@property (readwrite, nonatomic) NSString *Device_ID;
@property (readwrite, nonatomic) NSString *Device_Sex;

@end

NS_ASSUME_NONNULL_END
