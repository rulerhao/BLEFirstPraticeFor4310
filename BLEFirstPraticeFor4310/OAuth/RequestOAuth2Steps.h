//
//  RequestOAuth2Steps.h
//  MQTTTest
//
//  Created by louie on 2020/12/10.
//

#import "ViewController.h"

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

@end

NS_ASSUME_NONNULL_END
