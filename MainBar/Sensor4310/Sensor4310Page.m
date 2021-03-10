//
//  Sensor4310ViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/26.
//

#import "Sensor4310Page.h"

@interface Sensor4310Page () <ShowViewControllerDelegate>

@property(nonatomic, strong) ShowViewController *showViewController;

@end

@implementation Sensor4310Page

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"NowController = Sensor4310Page");
    self.CurrentController = ViewController_Sensor4310;
    
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
    self.showViewController.delegate = self;
    
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

- (NSInteger)getCurrentController_ShowViewController {
    return self.CurrentController;
}
@end
