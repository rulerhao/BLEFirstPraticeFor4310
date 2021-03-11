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

@class OAuth2Main;

@protocol OAuth2MainDelegate <NSObject>

@optional
- (void) synchronizeStoredDevices : (NSMutableArray *) Stored_Data;
- (void) dismissAlertViewForWebNavigatin;

@end

@interface OAuth2Main : UIView <WKUIDelegate, WKNavigationDelegate>

- (void)InitEnter : (UIViewController *) View_Controller;

@property(assign) id <OAuth2MainDelegate> delegate;

@property(readwrite, nonatomic) WKWebView *WKWeb_View;
@property(readwrite, nonatomic) NSString *Access_Token;
@property(readwrite, nonatomic) NSString *Refresh_Token;
@property(readwrite, nonatomic) NSString *Orgunits;
@property(readwrite, nonatomic) NSString *OTP;

@property(readwrite, nonatomic) NSString *Device_Type;
@property(readwrite, nonatomic) NSString *Device_ID;

- (void) connectDeviceToServer : (NSData *) characteristic;

- (void) signUpDevice;

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

@end

NS_ASSUME_NONNULL_END
