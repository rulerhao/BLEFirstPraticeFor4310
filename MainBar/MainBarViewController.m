//
//  MainBarViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/22.
//

#import "MainBarViewController.h"

@interface MainBarViewController ()

@property(nonatomic, strong) ShowViewController *showViewController;

@end

@implementation MainBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewInit];
    
    [self updateConstraints];
}

#pragma mark - View Initial

- (void) viewInit {
    //--------------------- View -----------------------
    
    //--------------------- ViewController -----------------------
    NSLog(@"self.CurrentControllerMainBarViewController = %ld", (long)self.CurrentController);
    switch (self.CurrentController) {
        case ViewController_Sensor4310:
            [self addSensor4310MainBarViewController];
            break;
        case ViewController_Organization:
            [self addOrganizationMainBarViewController];
            break;
        default:
            break;
    }
}

#pragma mark - Constraints
- (void)updateConstraints {
    
}

- (void) addSensor4310MainBarViewController {
    Sensor4310MainBarViewController *sensor4310MainBarViewController = [[Sensor4310MainBarViewController alloc] init];
    sensor4310MainBarViewController.CurrentController = self.CurrentController;
    [sensor4310MainBarViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [sensor4310MainBarViewController.view setUserInteractionEnabled:YES];
    [sensor4310MainBarViewController setCurrentController:self.CurrentController];
    
    [self addChildViewController:sensor4310MainBarViewController];
    
    [self.view addSubview:sensor4310MainBarViewController.view];
    [sensor4310MainBarViewController didMoveToParentViewController:self];
}

- (void) addOrganizationMainBarViewController {
    OrganizationMainBarViewController *organizationMainBarViewController = [[OrganizationMainBarViewController alloc] init];
    organizationMainBarViewController.CurrentController = self.CurrentController;
    [organizationMainBarViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [organizationMainBarViewController.view setUserInteractionEnabled:YES];
    [organizationMainBarViewController setCurrentController:self.CurrentController];
    
    [self addChildViewController:organizationMainBarViewController];
    
    [self.view addSubview:organizationMainBarViewController.view];
    [organizationMainBarViewController didMoveToParentViewController:self];
}
@end
