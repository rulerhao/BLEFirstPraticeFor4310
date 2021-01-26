//
//  OrganizationPage.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/22.
//

#import "OrganizationPage.h"

@interface OrganizationPage ()

@property(readwrite, nonatomic) NSInteger viewControllerNumber;
@property(nonatomic, strong) ShowViewController *showViewController;

@end

@implementation OrganizationPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllerNumber = ViewController_Organization;
    
    [self viewInit];
    
    [self updateConstraints];
}
#pragma mark - View Initial

- (void) viewInit {
    //--------------------- View -----------------------
    
    //--------------------- ViewController -----------------------
    self.showViewController = [[ShowViewController alloc] init];
    self.showViewController.CurrentController = self.viewControllerNumber;
    [self.showViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.showViewController.view setUserInteractionEnabled:YES];
    [self addChildViewController:self.showViewController];
    
    [self.view addSubview:self.showViewController.view];
    [self.showViewController didMoveToParentViewController:self];
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
