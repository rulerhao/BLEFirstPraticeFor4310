//
//  MyNavigationController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/17.
//

#import "MyNavigationController.h"


@interface MyNavigationController ()
{
    NSTimer *BLEBeDisabledTimer;
}
@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableNowTimeTimer];
    //-------------------------------------
    RootNavigationView = [MyNavigationController alloc];
    RootNavigationView = self;
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInController *logInController = [StoryBoard instantiateViewControllerWithIdentifier:@"LogInUIViewController"];
    [RootNavigationView pushViewController:logInController animated:NO];
}

- (void) enableNowTimeTimer {
    BLEBeDisabledTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(showNowTime:)
                                   userInfo:nil
                                    repeats:YES];
}

// 顯示Timer到期時無BLE時的Alert View
- (void) showNowTime :(NSTimer*)sender {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    //NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    Now_Time = [dateFormatter stringFromDate:[NSDate date]];
}
@end
