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

@interface BLEFor4310 : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
- (void) startFor4310BLE;

@property(strong, nonatomic) CBCentralManager *CM;
@property(strong, nonatomic) NSMutableArray *Stored_Data;

@end

NS_ASSUME_NONNULL_END
