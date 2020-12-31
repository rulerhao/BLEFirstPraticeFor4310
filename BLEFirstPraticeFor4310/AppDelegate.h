//
//  AppDelegate.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/9/25.
//

#import <UIKit/UIKit.h>
#import "MyNavigationController.h"
@class MyNavigationController;
@class BLEFor4310;

extern MyNavigationController *RootNavigationView;
extern BLEFor4310 *BLE;
extern NSString *Now_Time;
extern NSString *Now_Navigation_Name;

extern dispatch_queue_t GlobalQueue;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

