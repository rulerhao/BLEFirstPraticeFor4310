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
    NSData *Characteristic;
    NSData *Device_Information;
    NSData *Baby_Information;
    NSMutableArray *Stored_Movement_State;
    NSString *Device_Name;
    NSString *Device_ID;
    NSString *Device_Sex;
    NSString *Device_Model;
    NSString *Device_EPROM;
    NSString *Device_UUID;
    NSString *Device_Status;
    NSInteger Serial_Been_Register;
}

- (void)
cell                        : (nullable CBPeripheral *)     Peripheral
characteristic              : (nullable NSData *)           Characteristic
deviceInformation           : (nullable NSData *)           Device_Information
babyInformation             : (nullable NSData *)           Baby_Information
storedMovementState         : (nullable NSMutableArray *)   Stored_Movement_State
deviceName                  : (nullable NSString *)         Device_Name
deviceID                    : (nullable NSString *)         Device_ID
deviceSex                   : (nullable NSString *)         Device_Sex
deviceModel                 : (nullable NSString *)         Device_Model
deviceEPROM                 : (nullable NSString *)         Device_EPROM
deviceUUID                  : (nullable NSString *)         Device_UUID
deviceStatus                : (nullable NSString *)         Device_Status
serialBeenRegister          : (NSInteger)                   Serial_Been_Register;

@property (readwrite, nonatomic) CBPeripheral *Peripheral;
@property (readwrite, nonatomic) NSData *Characteristic;
@property (readwrite, nonatomic) NSData *Device_Information;
@property (readwrite, nonatomic) NSData *Baby_Information;
@property (readwrite, nonatomic) NSMutableArray *Stored_Movement_State;
@property (readwrite, nonatomic) NSString *Device_Name;
@property (readwrite, nonatomic) NSString *Device_ID;
@property (readwrite, nonatomic) NSString *Device_Sex;
@property (readwrite, nonatomic) NSString *Device_Model;
@property (readwrite, nonatomic) NSString *Device_EPROM;
@property (readwrite, nonatomic) NSString *Device_UUID;
@property (readwrite, nonatomic) NSString *Device_Status;
@property (readwrite, nonatomic) NSInteger Serial_Been_Register;

@end

NS_ASSUME_NONNULL_END
