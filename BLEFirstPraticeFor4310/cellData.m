//
//  cellData.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/8.
//

#import "cellData.h"

@interface cellData ()

@end

@implementation cellData

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)
addObj                  :(nullable CBPeripheral *)   Peripheral
nowDeviceInformationCharacteristic       :(nullable NSData *)         Now_Charact
previousCharacteristic  :(nullable NSData *)         Previous_Charact
nowBabyInformationCharacteristic      :(nullable NSData *)         Now_Baby_Infor
CurrentCharacteristic   :(nullable NSData *)         Current_Characteristic
storedMovementState     :(nullable NSMutableArray *) Stored_Movement_State
deviceName              :(nullable NSString *)       Device_Name
deviceID                :(nullable NSString *)       Device_ID
deviceSex               :(nullable NSString *)       Device_Sex
{
    peripheral = Peripheral;
    now_Charact = Now_Charact;
    previous_Charact = Previous_Charact;
    now_Baby_Infor = Now_Baby_Infor;
    current_Characteristic = Current_Characteristic;
    stored_Movemebt_State = Stored_Movement_State;
    device_Name = Device_Name;
    device_ID = Device_ID;
    device_Sex = Device_Sex;
}

- (CBPeripheral *) getPeripheral {
    return peripheral;
}

- (NSData *) getNowDeviceInformationCharacteristic {
    return now_Charact;
}

- (NSData *) getPreviousCharacteristic {
    return previous_Charact;
}

- (NSData *) getNowBabyInformationCharacteristic {
    return now_Baby_Infor;
}

- (NSData *) getCurrentCharacteristic {
    return current_Characteristic;
}

- (NSMutableArray *) getStoredMovementState {
    return stored_Movemebt_State;
}

- (NSString *) getDeviceName {
    return device_Name;
}

- (NSString *) getDeviceID {
    return device_ID;
}

- (NSString *) getDeviceSex {
    return device_Sex;
}

@end
