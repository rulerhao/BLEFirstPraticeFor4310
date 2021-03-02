//
//  MQTTMain.h
//  MQTTTest
//
//  Created by louie on 2020/11/24.
//

#import "ViewController.h"
#import <MQTTClient.h>
#import <MQTTWebsocketTransport.h>

NS_ASSUME_NONNULL_BEGIN

@interface MQTTMain : UIViewController <MQTTSessionDelegate>

@property(strong, nonatomic) NSMutableArray *MQTTMessage;

@property(strong, nonatomic) NSString *Client_ID;
@property(strong, nonatomic) NSString *User_Name;
@property(strong, nonatomic) NSString *OTP;
@property(strong, nonatomic) NSString *OTP_Expired;
- (void) mqttStart : (NSArray *) OAuth_Information
    viewController : (nullable UIViewController *) View_Controller;

- (void) MQTTPublishImplementDefalut;

- (void)
MQTTPublishImplement        : (NSString *) Model
Device_Serial               : (NSString *) Serial
Device_UUID                 : (NSString *) UUID
Temperature1                : (NSInteger)  t1
Temperature2                : (NSInteger)  t2
Temperature3                : (NSInteger)  t3
Battery                     : (int)        bat
Breath                      : (BOOL)       bre
Motion_X                    : (float)      motion_X
Motion_Y                    : (float)      motion_Y
Motion_Z                    : (float)      motion_Z;

- (void) publishTest : (NSString *) Device_Type
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

NS_ASSUME_NONNULL_END
