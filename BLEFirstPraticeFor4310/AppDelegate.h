//
//  AppDelegate.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/9/25.
//

#import <UIKit/UIKit.h>
#import "MyNavigationController.h"
#import "SettingEnum.h"
#import "OAuth2Main.h"
@class MyNavigationController;
@class BLEFor4310;
@class OAuth2Main;
@class MQTTMain;

extern CurrenctController currentController;
extern MyNavigationController *RootNavigationView;
extern BLEFor4310 *BLE;
extern OAuth2Main *OAuth;
extern MQTTMain *MqttMain;

extern NSString *Now_Time;
extern NSString *Now_Navigation_Name;

extern float *haveaniceday;
extern dispatch_queue_t GlobalQueue;

extern Class *NowClass;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

