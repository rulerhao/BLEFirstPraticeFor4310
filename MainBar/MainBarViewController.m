//
//  MainBarViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/22.
//

#import "MainBarViewController.h"

@interface MainBarViewController ()

@property(nonatomic, strong) ShowViewController *showViewController;
@property(nonatomic, strong) Sensor4310MainBarViewController *sensor4310MainBarViewController;
@property(nonatomic, strong) OrganizationMainBarViewController *organizationMainBarViewController;

@end

@implementation MainBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"MainBarViewControllerMovetoParent");
}

- (void)controllerInit {
    NSLog(@"NowController = MainBarViewController");
    NSLog(@"DelegateCurrentController = %ld", [self.delegate getCurrentController_MainBarViewControlelr]);
    [self viewInit];
    
    NSLog(@"organizationMainBarViewController.height = %f", self.organizationMainBarViewController.view.bounds.size.height);
    //[self updateConstraints];
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- View -----------------------
    //--------------------- ViewController -----------------------
    NSLog(@"self.CurrentControllerMainBarViewController = %ld", self.CurrentController);
    switch (self.CurrentController) {
        case ViewController_Sensor4310:
            [self addSensor4310MainBarViewController];
            break;
        case ViewController_Organization:
            [self addOrganizationMainBarViewController];
            break;
        case ViewController_Registrater4310:
            [self addRegisterMainBarViewController];
            break;
        default:
            break;
    }
}

#pragma mark - Constraints
- (void)updateConstraints {
}

- (void) addSensor4310MainBarViewController {
    self.sensor4310MainBarViewController = [[Sensor4310MainBarViewController alloc] init];
    self.sensor4310MainBarViewController.CurrentController = self.CurrentController;
    [self.sensor4310MainBarViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.sensor4310MainBarViewController.view setUserInteractionEnabled:YES];
    [self.sensor4310MainBarViewController setCurrentController:self.CurrentController];
    
    [self addChildViewController:self.sensor4310MainBarViewController];
    
    [self.view addSubview:self.sensor4310MainBarViewController.view];
    [self.sensor4310MainBarViewController didMoveToParentViewController:self];
    
    //--------------------- Constraints -----------------------
    [self.sensor4310MainBarViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.sensor4310MainBarViewController controllerInit];
}

- (void) addOrganizationMainBarViewController {
    self.organizationMainBarViewController = [[OrganizationMainBarViewController alloc] init];
    self.organizationMainBarViewController.CurrentController = self.CurrentController;
    [self.organizationMainBarViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.organizationMainBarViewController.view setUserInteractionEnabled:YES];
    [self.organizationMainBarViewController setCurrentController:self.CurrentController];
    
    [self addChildViewController:self.organizationMainBarViewController];
    
    [self.view addSubview:self.organizationMainBarViewController.view];
    [self.organizationMainBarViewController didMoveToParentViewController:self];
    
    //--------------------- Constraints -----------------------
    [self.organizationMainBarViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.organizationMainBarViewController controllerInit];
    
}

- (void) addRegisterMainBarViewController {
    Register4310ViewController *register4310ViewController = [[Register4310ViewController alloc] init];
    register4310ViewController.CurrentController = self.CurrentController;
    [register4310ViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [register4310ViewController.view setUserInteractionEnabled:YES];
    [register4310ViewController setCurrentController:self.CurrentController];
    
    [self addChildViewController:register4310ViewController];
    
    [self.view addSubview:register4310ViewController.view];
    [register4310ViewController didMoveToParentViewController:self];
    
    //--------------------- Constraints -----------------------
    [register4310ViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [register4310ViewController controllerInit];
}
@end
