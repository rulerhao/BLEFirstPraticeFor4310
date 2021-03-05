//
//  RequestOAuth2Steps.h
//  MQTTTest
//
//  Created by louie on 2020/12/10.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "EncodeOrguitsUUIDAndTimeStamp.h"
NS_ASSUME_NONNULL_BEGIN

@interface RequestOAuth2Steps : UIViewController

// 登錄用的URL設定
- (void)
logIn       : (NSString *)  requestURLString
wKWebView   : (WKWebView *) WKWebView;
    
- (void)takeCode : (WKWebView *) WKWebView;

- (void)
takeAccessToken : (NSString *) Code_Value
wKWebView       : (WKWebView *) WKWebView;

- (void)
takeRefreshAccesssTokenThroughRefreshToken : (NSString *)  Refresh_Token
wKWebView                                  : (WKWebView *) WKWebView;

- (void)
takeOTP         : (NSString *)  Access_Token
wKWebView       : (WKWebView *) WKWebView;


// 註冊裝置
- (void)
signUpDevices          : (NSString *)  Access_Token
orgunits               : (NSString *)  Orgunits
timeInterval : (NSTimeInterval) timeInterval 
wKWebView          : (WKWebView *) WKWebView;

// 取得裝置資訊
- (void)
takeDevicesInformation          : (NSString *)  Access_Token
deviceUUID                      : (NSString *)  Device_UUID
wKWebView                       : (WKWebView *) WKWebView;

// 更新裝置資訊
- (void) refreshDevicesInformation          : (NSString *)  Access_Token
                            status          : (NSInteger)   Status
                        deviceUUID          : (NSString *)  Device_UUID
                         wKWebView          : (WKWebView *) WKWebView;
// 更新手機狀態
- (void) refreshPhoneInformation          : (NSString *)  Access_Token
                            status        : (NSInteger)   Status
                            client_ID    : (NSString *) Client_ID
                         wKWebView        : (WKWebView *) WKWebView;
    
// 機構裝置列表及過濾 過濾用法，用來搜尋特定型號序號
- (void)
getDeviceUUIDThroughModelAndSerial : (NSString *) Access_Token
orgunits                           : (NSString *) Orgunits
wKWebView                          : (WKWebView *) WkWenView
model                              : (NSString *) Model
serial                             : (NSString *) Serial;

@end

NS_ASSUME_NONNULL_END
