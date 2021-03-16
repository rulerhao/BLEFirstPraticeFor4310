//
//  FunctionBarViewController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/1/14.
//

#import "FunctionBarViewController.h"

@interface FunctionBarViewController ()
{
    FunctionBarImagesSetting *functionBarImagesSetting;
    NSInteger Button_Number;
    NSMutableArray *Button_Type_List;
}

@property(strong , nonatomic) UIButton *ToolButton1;
@property(strong , nonatomic) UIButton *ToolButton2;
@property(strong , nonatomic) UIButton *ToolButton3;
@property(strong , nonatomic) UIButton *ToolButton4;
@property(strong , nonatomic) UIButton *ToolButton5;
@property(strong , nonatomic) NSMutableArray *Button_Array_List;

@end

@implementation FunctionBarViewController
typedef NS_ENUM(NSInteger, FunctionButtonEnum){
    ButtonHaveNotThing = -1,
    BackViewController = 1,
    ExitViewController = 2,
    InformationWebSite = 3,
    RegisterViewController = 4
};

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) controllerInit {
    functionBarImagesSetting = [[FunctionBarImagesSetting alloc] init];
    self.Button_Array_List = [[NSMutableArray alloc] init];
    Button_Type_List = [[NSMutableArray alloc] init];
    Button_Number = 5;
    
    [self viewInit];
    [self updateConstraints];
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"FunctionBarHeight = %f", self.view.bounds.size.height);
}
#pragma mark - View Initial
- (void) viewInit {
    Button_Type_List = [self Function_Button_Type_Filter];
    for(NSInteger i = 0; i < Button_Number; i++) {
        UIButton *TestButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [TestButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [TestButton addTarget:self action:@selector(buttonBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [TestButton setImage:[self Function_Button_Image_Filter:[[Button_Type_List objectAtIndex:i] integerValue]] forState:UIControlStateNormal];
        [self.view addSubview:TestButton];

        [self.Button_Array_List addObject:TestButton];
    }
}
#pragma mark - Constraints
- (void)updateConstraints {
    UIButton *TempButton;
    for(NSInteger i = 0; i < Button_Number; i++) {
        TempButton = [self.Button_Array_List objectAtIndex:i];
        //--------------------- 最左邊的 Button -----------------------
        if(i == 0) {
            [TempButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(functionBarImagesSetting.Heigth_Edge_Length);
                make.bottom.equalTo(self.view.mas_bottom).offset(- functionBarImagesSetting.Heigth_Edge_Length);
                make.left.equalTo(self.view.mas_left).offset(functionBarImagesSetting.Width_Edge_Length);
                make.right.equalTo(self.view.mas_left).offset(functionBarImagesSetting.Width_Edge_Length + functionBarImagesSetting.Button_Width);
            }];
        }
        //--------------------- 其他的 Button -----------------------
        else {
            UIButton *TempButtonSec = [self.Button_Array_List objectAtIndex:i - 1];
            [TempButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(functionBarImagesSetting.Heigth_Edge_Length);
                make.bottom.equalTo(self.view.mas_bottom).offset(- functionBarImagesSetting.Heigth_Edge_Length);
                make.left.equalTo(TempButtonSec.mas_right).offset(functionBarImagesSetting.Interval_Length);
                make.right.equalTo(TempButtonSec.mas_right).offset(functionBarImagesSetting.Interval_Length + functionBarImagesSetting.Button_Width);
            }];
        }
    }
}
#pragma mark - Methods

- (void) buttonBeClicked:(UIButton *) sender {
    for(NSInteger i = 0; i < Button_Number; i++) {
        UIButton *Index_Button = [self.Button_Array_List objectAtIndex:i];
        if(Index_Button == sender) {
            NSInteger Button_Type = [[Button_Type_List objectAtIndex:i] integerValue];
            switch (Button_Type) {
                case BackViewController:
                    [self backViewController];
                    break;
                case ExitViewController:
                    [self exitToRoot];
                    break;
                case InformationWebSite:
                    [self openInformationWebsite];
                    break;
                case RegisterViewController:
                    [self registerViewController];
                    break;
                default:
                    break;
            }
        }
    }
}

- (NSMutableArray *) Function_Button_Type_Filter {
    NSMutableArray *Button_Type_List = [[NSMutableArray alloc] init];
    NSLog(@"FunctionBar Go Way = %ld", (long)self.CurrentController);
    switch (self.CurrentController) {
        case ViewController_Root:
            [Button_Type_List addObject:[NSNumber numberWithInteger:BackViewController]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:InformationWebSite]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ButtonHaveNotThing]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ButtonHaveNotThing]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ExitViewController]];
            break;
        case ViewController_Organization:
            [Button_Type_List addObject:[NSNumber numberWithInteger:BackViewController]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:InformationWebSite]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ButtonHaveNotThing]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ButtonHaveNotThing]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ExitViewController]];
            break;
        case ViewController_Sensor4310:
            [Button_Type_List addObject:[NSNumber numberWithInteger:BackViewController]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:InformationWebSite]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ButtonHaveNotThing]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:RegisterViewController]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ExitViewController]];
        case ViewController_Registrater4310:
            [Button_Type_List addObject:[NSNumber numberWithInteger:BackViewController]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:InformationWebSite]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ButtonHaveNotThing]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ButtonHaveNotThing]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ExitViewController]];
            break;
        case ViewController_Sensor4310Test:
            [Button_Type_List addObject:[NSNumber numberWithInteger:BackViewController]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:InformationWebSite]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ButtonHaveNotThing]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:RegisterViewController]];
            [Button_Type_List addObject:[NSNumber numberWithInteger:ExitViewController]];
            break;
    }
    return Button_Type_List;
}

- (UIImage *) Function_Button_Image_Filter : (NSInteger) Type_Number {
    UIImage *ButtonImage;
    switch (Type_Number) {
        case BackViewController:
            ButtonImage = [UIImage imageNamed:@"function_back.png"];
            break;
        case InformationWebSite:
            ButtonImage = [UIImage imageNamed:@"function_info.png"];
            break;
        case ExitViewController:
            ButtonImage = [UIImage imageNamed:@"view_exit.png"];
            break;
        case RegisterViewController:
            ButtonImage = [UIImage imageNamed:@"view_dataNumber.png"];
        default:
            break;
    }
    return ButtonImage;
}

// 按下時觸發
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
}
@synthesize delegate;

- (void) backViewController {
    [RootNavigationView popViewControllerAnimated:NO];
}

- (void) exitToRoot {
    NSArray *array = [self.navigationController viewControllers];
    for(NSInteger i = 0 ; i < [array count]; i++) {
        if([[array objectAtIndex:i] class] == LogInController.class) {
            [RootNavigationView popToViewController:[array objectAtIndex:1] animated:NO];
        }
    }
}

- (void) openInformationWebsite
{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://healthcare.oucare.com"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
             NSLog(@"Opened url");
        }
    }];
}

- (void) registerViewController {
//    Register4310Page *register4310Page = [[Register4310Page alloc] init];
//    [register4310Page setModalPresentationStyle:UIModalPresentationFullScreen];
//    [RootNavigationView pushViewController:register4310Page animated:NO];
    [self.delegate registerButtonBeClicked];
}
@end
