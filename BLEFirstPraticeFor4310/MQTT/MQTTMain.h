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

- (void) mqttStart : (NSArray *) OAuth_Information
    viewController : (UIViewController *) View_Controller;
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

@end

NS_ASSUME_NONNULL_END
