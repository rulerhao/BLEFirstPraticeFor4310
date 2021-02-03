//
//  BLEFor4310.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/23.
//

#import "ViewController.h"
#import "CalFunc.h"
#import "StoredDevicesCell.h"
#import "KS4310Setting.h"
#import "Convert4310Information.h"

NS_ASSUME_NONNULL_BEGIN
@class BLEFor4310;

@protocol BLEFor4310Delegate <NSObject>

@optional
- (void)parentMethodThatChildCanCall;
- (void)addNewDevice:(CBPeripheral *)peripheral;
- (void)updateCharacteristic:(CBPeripheral *)peripheral characteristic :(CBCharacteristic *)characteristic;
- (void)synchronizeStoredDevices:(NSMutableArray *)stored_Devices;
- (void)updateForBusy:(NSMutableArray *)stored_Devices;
@end

@interface BLEFor4310 : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
- (void) startFor4310BLE;

@property(strong, nonatomic) CBCentralManager *CM;
@property(strong, nonatomic) NSMutableArray *Stored_Data;
@property(assign) id <BLEFor4310Delegate> delegate;

@end

NS_ASSUME_NONNULL_END
