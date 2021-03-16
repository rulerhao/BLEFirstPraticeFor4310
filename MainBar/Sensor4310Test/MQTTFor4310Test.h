//
//  MQTTFor4310Test.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/15.
//

#import <Foundation/Foundation.h>
#import <MQTTClient.h>
#import <MQTTWebsocketTransport.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MQTTFor4310Test;

@protocol MQTTFor4310TestDelegate <NSObject>
- (NSString *) getAccessToken;
- (NSString *) getClientID;
- (WKWebView *) getWebView;
@optional

@end

@interface MQTTFor4310Test : NSObject <MQTTSessionDelegate>

@property(assign) id <MQTTFor4310TestDelegate> delegate;

- (void) mqttConnect : (NSString *) Client_ID
           User_Name : (NSString *) User_Name
                 OTP : (NSString *) OTP
         OTP_Expired : (NSInteger) OTP_Expired;

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
