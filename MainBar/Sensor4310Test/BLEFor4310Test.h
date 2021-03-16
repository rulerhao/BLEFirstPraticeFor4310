//
//  BLEFor4310Test.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/12.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "StoredDevicesCell.h"
NS_ASSUME_NONNULL_BEGIN

@class BLEFor4310Test;

@protocol BLEFor4310TestDelegate <NSObject>

@optional
- (NSMutableArray *) getStoredData;
- (void) addStoredData : (StoredDevicesCell *) Cell;
- (void) removeStoredData : (NSInteger) Index;
- (void) replaceStoredData : (NSInteger) Index
                      cell : (StoredDevicesCell *) Cell;
// OTP
- (NSTimeInterval) getOTPTimeInterval;

- (NSString *) getClientID;

// MQTT
/* MQTT Publish */
- (void) mqttPublish : (NSString *) Device_Type
        deviceSerial : (NSString *) Device_Serial
          deviceUUID : (NSString *) Device_UUID
                  t1 : (NSInteger) T1
                  t2 : (NSInteger) T2
                  t3 : (NSInteger) T3
             battery : (int) Battery
              breath : (BOOL) Breath
             motionX : (float) Motion_X
             motionY : (float) Motion_Y
             motionZ : (float) Motion_Z;
@end

@interface BLEFor4310Test : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property(assign) id <BLEFor4310TestDelegate> delegate;

- (void) startBLE;
@end

NS_ASSUME_NONNULL_END
