//
//  MyNavigationController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/17.
//

#import "MyNavigationController.h"


@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    RootNavigationView = [MyNavigationController alloc];
    RootNavigationView = self;
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LogInController *logInController = [StoryBoard instantiateViewControllerWithIdentifier:@"LogInUIViewController"];
    [RootNavigationView pushViewController:logInController animated:NO];
}

@end
