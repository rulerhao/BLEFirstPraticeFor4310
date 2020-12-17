//
//  AppDelegate.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/9/25.
//

#import <UIKit/UIKit.h>
#import "MyNavigationController.h"
@class MyNavigationController;

extern MyNavigationController *RootNavigationView;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

