//
//  BLEForRegister.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/9.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "KS4310Setting.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLEForRegister : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@end

NS_ASSUME_NONNULL_END
