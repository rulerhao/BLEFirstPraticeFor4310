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
    self.Account_Text_View.delegate = self;
    self.Password_Text_View.delegate = self;
    self.Time_Text_Field.text = Now_Time;
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
    
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    OrganizationController *OrganizationController = [StoryBoard instantiateViewControllerWithIdentifier:@"OrganizationUIViewController"];
    [RootNavigationView pushViewController:OrganizationController animated:NO];
    
    // ---------------------- Now Navigation Name -------------------
    Now_Navigation_Name = @"機構";
}

@end
