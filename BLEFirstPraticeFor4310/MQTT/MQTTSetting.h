//
//  MQTTSetting.h
//  MQTTTest
//
//  Created by louie on 2020/11/23.
//

#import "ViewController.h"
#import "IDFVProcess.h"
#import <MQTTClient.h>
#import <MQTTWebsocketTransport.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MQTTSetting : UIViewController
{
    NSString *User_Name;
    NSString *Password;
    NSString *ClientID;
    MQTTSession *Session;
    MQTTWebsocketTransport *Transport;
}

@property (retain, nonatomic) NSString *User_Name;
@property (retain, nonatomic) NSString *Password;
@property (retain, nonatomic) NSString *ClientID;
@property (retain, nonatomic) MQTTSession *Session;
@property (retain, nonatomic) MQTTWebsocketTransport *Transport;

- (void) InitMQTTSetting;

@end

NS_ASSUME_NONNULL_END
