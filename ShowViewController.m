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
    self.functionBarViewController = [[FunctionBarViewController alloc] init];
    [self.functionBarViewController.view setAutoresizingMask:UIViewAutoresizingNone];
    [self.functionBarViewController.view setUserInteractionEnabled:YES];
    [self addChildViewController:self.functionBarViewController];
    
    [self.functionBarViewController setCurrentController:self.CurrentController];
    self.functionBarViewController.delegate = self;
    
    [self.view addSubview:self.functionBarViewController.view];
    [self.functionBarViewController didMoveToParentViewController:self];
    
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
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //Title Bar ViewController
    [self.titleBarViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_top).offset(imageSetting.Kjump_Background_Title_Bar_Height);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //Function Bar ViewController
    [self.functionBarViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {        make.top.equalTo(self.titleBarViewController.view.mas_bottom);
        make.bottom.equalTo(self.titleBarViewController.view.mas_bottom).offset(imageSetting.Kjump_Background_Function_Bar_Height);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //--------------------- Main Bar View -----------------------
    [self.mainBarViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.functionBarViewController.view.mas_bottom);
        make.bottom.equalTo(self.functionBarViewController.view.mas_bottom).offset(imageSetting.Kjump_Background_Main_Bar_Height);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    //--------------------- Ad Bar View -----------------------
    [self.adBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainBarViewController.view.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
}
#pragma mark - Delegate

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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"ShowtouchesBegan");
}

- (NSInteger)getCurrentController_MainBarViewControlelr {
    return self.CurrentController;
}
@end
