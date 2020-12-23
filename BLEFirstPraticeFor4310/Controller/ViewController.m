//
//  ViewController.m
//  MQTTTest
//
//  Created by louie on 2020/11/11.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>


MQTTSession* MySeccion;


@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set notificationCenter to get OAuth2 returning informaiton from OAuth2Main
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(didGetOAuthOTPNotification:) //接收到該Notification時要call的function
        name:@"getOAuthOTPNotification"
        object:nil];
    
    OAuth2Main *webViewController = [OAuth2Main new];
    [self.view addSubview:webViewController];
    [webViewController InitEnter : self];
//    MQTTMain *MqttMain = [[MQTTMain alloc] init];
//    [MqttMain MQTTStart];
}

- (void) viewDidAppear:(BOOL)animated
{
//    NSLog(@"viewDidAppear");
//    // set storyboard
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    // set web viewcontroller
//    WebViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
//    // set viewcontroller style
//    // full screen
//    //webViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    // start to change
//    [self presentViewController:webViewController animated:YES completion:nil];
    
//    NSLog(@"StartWebViewController");
//    NSLog(@"self = %@", self);
//    WebViewController *webViewController = [WebViewController new];
//    [self.view addSubview:webViewController];
//    [webViewController InitEnter];
    
    NSLog(@"HaveANiceDay123123");
}

// 得到 OTP 走這
- (void)
didGetOAuthOTPNotification:(NSNotification *)notification {
    NSLog(@"getOAuthOTPSusscess");
    
    // Read OTP information dictionary
    NSDictionary * userInfo = [notification userInfo]; //讀取userInfo
    // MQTT Subscribe
    MQTTMain *mqttMain = [MQTTMain alloc];
    [mqttMain MQTTStart:[userInfo allValues]];
    
}
/**
 * 按下 Publish button 的觸發事件
 */
- (IBAction)TouchDownPublishButton:(id)sender
{
    MQTTMain *MqttMain = [[MQTTMain alloc] init];
    // Default Publish
    //[MqttMain MQTTPublishImplementDefalut];
    
    [MqttMain MQTTPublishImplement:@"KS-4310"
                     Device_Serial:@"S15"
                       Device_UUID:@"92ee96a6-ff9a-11ea-8fd3-0242ac160004"
                      Temperature1:30
                      Temperature2:35
                      Temperature3:40
                           Battery:50
                            Breath:false
                          Motion_X:123.1
                          Motion_Y:252.6
                          Motion_Z:929.1];
}
@end
