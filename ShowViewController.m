//
//  ShowViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/13.
//

#import "ShowViewController.h"
@interface ShowViewController () <FunctionBarViewControllerDelegate, MainBarViewControllerDelegate>
{
    ImageSetting *imageSetting;
}

@property(nonatomic, strong) UIImageView *backgroundImageView;

@property(nonatomic, strong) UIView *mainBarView;
@property(nonatomic, strong) UIView *adBarView;
@property(nonatomic, strong) TitleBarViewController *titleBarViewController;
@property(nonatomic, strong) FunctionBarViewController *functionBarViewController;
@property(nonatomic, strong) MainBarViewController *mainBarViewController;


@end

@implementation ShowViewController
	
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"functionBarViewControllerHeight = %f", self.functionBarViewController.view.bounds.size.height);
    NSLog(@"functionBarViewControllerWidth = %f", self.functionBarViewController.view.bounds.size.width);
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    NSLog(@"ShowViewControllerMovetoParent");
}

- (void) controllerInit {
    NSLog(@"self.CurrentController = %ld", self.CurrentController);
    NSLog(@"NowController = ShowViewController");
    NSLog(@"adasd = %ld", [self.delegate getCurrentController_ShowViewController]);

    imageSetting = [[ImageSetting alloc] init];
    
    //--------------------- Init -----------------------
    currentController = ViewController_Organization;
    //--------------------- View Init -----------------------
    [self viewInit];
    //--------------------- Constraints set -----------------------
    [self updateConstraints];
}
#pragma mark - View Initial

- (void) viewInit {
    //--------------------- View -----------------------
    
    //--------------------- Background ImageView -----------------------
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.backgroundImageView setImage:imageSetting.Kjump_Background_Image];
    
    [self.view addSubview: self.backgroundImageView];
    
    //--------------------- Title Bar ViewController -----------------------
    self.titleBarViewController = [[TitleBarViewController alloc] init];
    [self.titleBarViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.titleBarViewController.view setUserInteractionEnabled:YES];
    [self addChildViewController:self.titleBarViewController];
    
    [self.titleBarViewController setCurrentController:self.CurrentController];
    
    [self.view addSubview:self.titleBarViewController.view];
    [self.titleBarViewController didMoveToParentViewController:self];
    
    //--------------------- Function Bar ViewController -----------------------
    NSLog(@"CurrentController in function bar1 = %ld", (long)self.CurrentController);
    self.functionBarViewController = [[FunctionBarViewController alloc] init];
    NSLog(@"CurrentController in function bar2 = %ld", (long)self.CurrentController);
    [self.functionBarViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    NSLog(@"CurrentController in function bar3 = %ld", (long)self.CurrentController);
    [self.functionBarViewController.view setUserInteractionEnabled:YES];
    [self.functionBarViewController setCurrentController:self.CurrentController];
    NSLog(@"CurrentController in function bar4 = %ld", (long)self.CurrentController);
    [self addChildViewController:self.functionBarViewController];
    NSLog(@"CurrentController in function bar5 = %ld", (long)self.CurrentController);
    self.functionBarViewController.delegate = self;
    
    [self.view addSubview:self.functionBarViewController.view];
    [self.functionBarViewController didMoveToParentViewController:self];
    [self.functionBarViewController controllerInit];
    
    //--------------------- mainView -----------------------
    self.mainBarViewController = [[MainBarViewController alloc] init];
    [self.mainBarViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.mainBarViewController.view setUserInteractionEnabled:YES];
    [self addChildViewController:self.mainBarViewController];
    
    NSLog(@"CurrentControllerInShowViewController = %ld", self.CurrentController);
    [self.mainBarViewController setCurrentController:self.CurrentController];
    self.mainBarViewController.delegate = self;
    
    [self.view addSubview:self.mainBarViewController.view];
    [self.mainBarViewController didMoveToParentViewController:self];
    [self.mainBarViewController controllerInit];
    
    //--------------------- adBarView -----------------------
    self.adBarView = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.adBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[self.adBarView setBackgroundColor:[UIColor brownColor]];
    
    [self.view addSubview: self.adBarView];
}
#pragma mark - Constraints
- (void)updateConstraints {
    //--------------------- Background ImageView -----------------------
    [self.backgroundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    
    //Title Bar ViewController
    [self.titleBarViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(imageSetting.Kjump_Background_Title_Bar_Height);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    
    //Function Bar ViewController
    [self.functionBarViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {        make.top.equalTo(self.titleBarViewController.view.mas_safeAreaLayoutGuideBottom);
        make.bottom.equalTo(self.titleBarViewController.view.mas_safeAreaLayoutGuideBottom).offset(imageSetting.Kjump_Background_Function_Bar_Height);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    
    //--------------------- Main Bar View -----------------------
    [self.mainBarViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.functionBarViewController.view.mas_safeAreaLayoutGuideBottom);
        make.bottom.equalTo(self.functionBarViewController.view.mas_safeAreaLayoutGuideBottom).offset(imageSetting.Kjump_Background_Main_Bar_Height);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    
    //--------------------- Ad Bar View -----------------------
    [self.adBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainBarViewController.view.mas_safeAreaLayoutGuideBottom);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
}
#pragma mark - Delegate
- (void) registerButtonBeClicked {
    NSLog(@"RegisterButtonBeClickedInShowViewController");
    [self.mainBarViewController registerButtonBeClicked];
}
#pragma mark - Methods

- (void) functionName:(UIButton *) sender {

    NSLog(@"Button be touched");
    NSLog(@"Tag : %@", sender.class);
    NSArray *array = [self.navigationController viewControllers];
    NSLog(@"array = %@", array);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSArray *array = [self.navigationController viewControllers];
//        [RootNavigationView popToViewController:[array objectAtIndex:1] animated:NO];
//    });
}

// 按下時觸發
- (void) touchesBegan : (NSSet<UITouch *> *)touches
            withEvent : (UIEvent *)event {
    NSLog(@"ShowtouchesBegan");
}

- (NSInteger) getCurrentController_MainBarViewControlelr {
    return self.CurrentController;
}
@end
