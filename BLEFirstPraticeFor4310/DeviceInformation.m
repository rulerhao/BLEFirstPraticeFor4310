//
//  DeviceInformation.m
//  MQTTTest
//
//  Created by louie on 2020/11/19.
//

#import "DeviceInformation.h"

@interface DeviceInformation ()

@end

@implementation DeviceInformation

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)
deviceInformation : (nullable NSString *) device_Model
serial            : (nullable NSString *) device_Serial
uuid              : (nullable NSString *) device_UUID
{
    model = device_Model;
    serial = device_Serial;
    uuid = device_UUID;
}

- (NSString *) getModel
{
    return model;
}

- (NSString *) getSerial
{
    return serial;
}

- (NSString *) getUUID
{
    return uuid;
}

@end
