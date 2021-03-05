//
//  Convert4310Information.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/10/7.
//

#import "ViewController.h"
#import "CalFunc.h"
#import "StringProcessFunc.h"
#import "StoredDevicesCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface Convert4310Information : UIViewController

- (NSInteger) get_Location_X:(NSData *) data_Bytes;
- (NSInteger) get_Location_Y:(NSData *) data_Bytes;
- (NSInteger) get_Location_Z:(NSData *) data_Bytes;

- (Boolean) get_Movement_Status :(NSInteger) X
            y                   :(NSInteger) Y
            z                   :(NSInteger) Z
            previous_x          :(NSInteger) previous_X
            previous_y          :(NSInteger) previous_Y
            previous_z          :(NSInteger) previous_Z;

- (float)getTemperature_1:(NSData *) data_Bytes;
- (float)getTemperature_2:(NSData *) data_Bytes;
- (float)getTemperature_3:(NSData *) data_Bytes;
- (float)getTemperature_4:(NSData *) data_Bytes;

- (NSUInteger)getBattery_Volume:(NSData *) data_Bytes;

- (NSString *) getDeviceName : (NSData *) data_Bytes;
- (NSString *) getDeviceID : (NSData *) data_Bytes;
- (NSString *) getDeviceSex : (NSData *) data_Bytes;

- (NSMutableArray *)
refreshMovementState    : (NSData *)   characteristic_Value
storedDevices           : (NSMutableArray *)    StoredDevices
movementScanTime        : (NSInteger)           MovementScanTime
index                   : (NSUInteger)          index;
    
- (NSMutableArray *)
movementStateRefresh    : (NSData *)            characteristic_Value
storedDeviceCell        : (StoredDevicesCell *) Stored_Device_Cell
movementScanTime        : (NSInteger)           MovementScanTime;
    
- (BOOL)
    getMovementNormal       : (NSMutableArray *)    Movement_Recode_Array
ScanTime                : (NSUInteger)          ScanTime;
@end

NS_ASSUME_NONNULL_END
