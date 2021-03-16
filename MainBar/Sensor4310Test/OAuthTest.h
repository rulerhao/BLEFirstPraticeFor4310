//
//  OAuthTest.h
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/12.
//

#import <UIKit/UIKit.h>
//#import "RequestOAuth2Steps.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OAuthTest;

@protocol OAuthTestDelegate <NSObject>

@optional
- (void) mqttConnect : (NSString *) Client_ID
            userName : (NSString *) User_Name
                 otp : (NSString *) OTP
          otpExpired : (NSInteger) OTP_Expired;
@end

@interface OAuthTest : NSObject <WKUIDelegate, WKNavigationDelegate>

@property (assign) id <OAuthTestDelegate> delegate;

@property (readwrite, nonatomic) WKWebView *WKWeb_View;

@property (readwrite, nonatomic) NSString *Device_Name;


@property (readwrite, nonatomic) NSString *Orgunits;
@property (readwrite, nonatomic) NSString *Device_Type;
@property (readwrite, nonatomic) NSString *Device_ID;

@property (readwrite, nonatomic) NSString *Access_Token;
@property (readwrite, nonatomic) NSString *Refresh_Token;
@property (readwrite, nonatomic) NSString *Token_Type;
@property (readwrite, nonatomic) NSInteger Expires_In;

// OTP
@property (readwrite, nonatomic) NSString *Client_ID;
@property (readwrite, nonatomic) NSString *User_Name;
@property (readwrite, nonatomic) NSString *OTP;
@property (readwrite, nonatomic) NSTimeInterval OTP_Expired;

- (void) startOAuth;

@end

NS_ASSUME_NONNULL_END
