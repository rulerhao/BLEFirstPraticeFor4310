//
//  Register4310Page.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/9.
//

#import "Register4310Page.h"

@interface Register4310Page ()

@property(nonatomic, strong) ShowViewController *showViewController;

@end

@implementation Register4310Page

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"NowController = Registration4310");
    self.CurrentController = ViewController_Registrater4310;
    
    [self viewInit];
    
    [self updateConstraints];
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- View -----------------------
    
    //--------------------- ViewController -----------------------
    
    self.showViewController = [[ShowViewController alloc] init];
    [self.showViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.showViewController.view setUserInteractionEnabled:YES];
    
    NSLog(@"self.CurrentControllerInSensor4310 = %ld", self.CurrentController);
    [self.showViewController setCurrentController:self.CurrentController];
    
    [self addChildViewController:self.showViewController];
    [self.view addSubview:self.showViewController.view];
    [self.showViewController didMoveToParentViewController:self];
    [self.showViewController controllerInit];
}

#pragma mark - Constraints
- (void)updateConstraints {
    //--------------------- ViewController -----------------------
    [self.showViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
}

@end
