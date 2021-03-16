//
//  Sensor4310TestPage.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/12.
//

#import "Sensor4310TestPage.h"
@interface Sensor4310TestPage ()

@property(strong, nonatomic) ShowViewController *showViewController;

@end
@implementation Sensor4310TestPage

- (void) viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"NowController = Sensor4310TestPage");
    self.CurrentController = ViewController_Sensor4310Test;
    
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
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}

@end
