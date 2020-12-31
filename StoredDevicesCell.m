//
//  StoredDevicesCell.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/30.
//

#import "StoredDevicesCell.h"

@implementation StoredDevicesCell
{
    
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
{
    self.Peripheral = Peripheral;
    self.Characteristic = Characteristic;
    self.Device_Information = Device_Information;
    self.Baby_Information = Baby_Information;
    self.Stored_Movement_State = Stored_Movement_State;
    self.Device_Name = Device_Name;
    self.Device_ID = Device_ID;
    self.Device_Sex = Device_Sex;
}

@synthesize Peripheral;
@synthesize Characteristic;
@synthesize Device_Information;
@synthesize Baby_Information;
@synthesize Stored_Movement_State;
@synthesize Device_Name;
@synthesize Device_ID;
@synthesize Device_Sex;

@end
