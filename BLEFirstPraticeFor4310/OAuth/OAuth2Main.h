//
//  WebViewController.h
//  MQTTTest
//
//  Created by louie on 2020/11/27.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <OIDAuthorizationRequest.h>
#import <OIDAuthState.h>
#import <OIDAuthorizationService.h>
#import "OAuth2Parameters.h"
#import "URLProcess.h"
#import "HTMLProcess.h"
#import "JSONProcess.h"
#import "RequestOAuth2Steps.h"

NS_ASSUME_NONNULL_BEGIN

@interface OAuth2Main : UIView <WKUIDelegate, WKNavigationDelegate>

- (void)InitEnter : (UIViewController *) View_Controller;

@property(readwrite, nonatomic) WKWebView *WKWeb_View;
@property(readwrite, nonatomic) NSString *Access_Token;
@property(readwrite, nonatomic) NSString *Refresh_Token;

@end

NS_ASSUME_NONNULL_END
