//
//  AppDelegate.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/9/25.
//

#import "AppDelegate.h"

MyNavigationController *RootNavigationView;
BLEFor4310 *BLE;
NSString *Now_Time;
NSString *Now_Navigation_Name;
dispatch_queue_t GlobalQueue;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    GlobalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RootNavigationView = [StoryBoard instantiateViewControllerWithIdentifier:@"myNavigationController"];
    //-------------------NowTime----------------
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    Now_Time = [dateFormatter stringFromDate:[NSDate date]];
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
