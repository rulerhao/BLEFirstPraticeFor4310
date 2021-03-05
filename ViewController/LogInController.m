//
//  LogInController.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/16.
//

#import "LogInController.h"

@interface LogInController ()
@property (strong, nonatomic) IBOutlet UITextField *Account_Text_View;
@property (strong, nonatomic) IBOutlet UITextField *Password_Text_View;
@property (strong, nonatomic) IBOutlet UITextView *Time_Text_Field;

@end

@implementation LogInController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"LoginViewDidLoad");
    self.Account_Text_View.delegate = self;
    self.Password_Text_View.delegate = self;
    self.Time_Text_Field.text = Now_Time;
}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"LoginViewAppearLoad");
    NSLog(@"DeviceCurrentName = %@", [[UIDevice currentDevice] name]);
    NSMutableDictionary *DictTest = [[NSMutableDictionary alloc] init];
//    NSLog(@"I PHONE BOUNDS = %@", [[UIScreen mainScreen] bounds]);
//    UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
//    CGFloat topPadding = window.safeAreaInsets.top;
//    CGFloat bottomPadding = window.safeAreaInsets.bottom;
//    NSLog(@"window.safeAreaInsetstest1 = %@", window.safeAreaInsets);
//    NSLog(@"window.safeAreaInsetstest2_height = %f", window.safeAreaLayoutGuide.layoutFrame.size.height);
//    NSLog(@"window.safeAreaInsetstest2_width = %f", window.safeAreaLayoutGuide.layoutFrame.size.width);
    
    // 當重複讀取時關閉他們
    if(BLE) {
        BLE = nil;
    }
    if(OAuth) {
        OAuth = nil;
    }
    if(MqttMain) {
        MqttMain = nil;
    }
        
}

// ---------------------- TextField -------------------
// 按return時觸發
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

// 按下時觸發
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
    // 當按下非keyboard時觸發關閉keyboard
    [self.view endEditing:true];
}

// ---------------------- Log In Button -------------------
- (IBAction)LogInButtonTouchDown:(id)sender {
    NSString *Account = self.Account_Text_View.text;
    NSString *Password = self.Password_Text_View.text;
    NSLog(@"Account_Account = %@", Account);
    NSLog(@"Account_Password = %@", Password);
    
    // ------------------ Run BLEFor4310 ---------------
    BLE = [BLEFor4310 new];
    
    OAuth = [OAuth2Main new];
    
    [OAuth InitEnter:self];
    
//    // ------------------ 跳到檢查畫面 ---------------
    Mode = 0;
    
    Sensor4310Page *sensor4310Page = [[Sensor4310Page alloc] init];
    [sensor4310Page setModalPresentationStyle:UIModalPresentationFullScreen];
    [RootNavigationView pushViewController:sensor4310Page animated:NO];
}

// ---------------------- 監測 Button -------------------
- (IBAction)WatchButton:(id)sender {
    NSString *Account = self.Account_Text_View.text;
    NSString *Password = self.Password_Text_View.text;
    NSLog(@"Account_Account = %@", Account);
    NSLog(@"Account_Password = %@", Password);
    
    // ------------------ Run BLEFor4310 ---------------
    OAuth = [OAuth2Main new];
    
    [OAuth InitEnter:self];
    
////    // ------------------ 跳到監測畫面 ---------------
//    WatcherViewController *watcherViewController = [[WatcherViewController alloc] init];
//    [watcherViewController setModalPresentationStyle:UIModalPresentationFullScreen];
//    [RootNavigationView pushViewController:watcherViewController animated:NO];
    //    // ------------------ 跳到檢查畫面 ---------------
    Mode = 1;
        Sensor4310Page *sensor4310Page = [[Sensor4310Page alloc] init];
        [sensor4310Page setModalPresentationStyle:UIModalPresentationFullScreen];
        [RootNavigationView pushViewController:sensor4310Page animated:NO];
}

@end
