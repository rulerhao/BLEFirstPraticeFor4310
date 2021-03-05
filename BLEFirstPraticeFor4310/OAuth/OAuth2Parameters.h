//
//  OAuthParameters.h
//  MQTTTest
//
//  Created by louie on 2020/12/2.
//

#import "ViewController.h"
#import "EncodeOrguitsUUIDAndTimeStamp.h"
NS_ASSUME_NONNULL_BEGIN

@interface OAuth2Parameters : UIViewController
// 登入
- (NSMutableArray *) logInParameters;
- (NSMutableArray *) logInBodyParameters;
- (NSString *) logInURLWithParameters;

// 取得 code
- (NSMutableArray *) takeCodeParameter;
- (NSString *) takeCodeURLWithParameters;

// 取得 Access token
- (NSMutableArray *) takeAccessTokenBodyParameters : (NSString *) Code_Value;
- (NSString *) takeAccessTokenURLWithCodeParameters;

// 第四步驟 用RefreshToken取得AccessToken時所需要的參數
- (NSMutableArray *) takeRefreshTokenBodyParameters : (NSString *) Refresh_Token;
- (NSString *) takeRefreshTokenURLWithCodeParameters;

// Take OTP
- (NSString *) takeOTPBodyParameters : (NSString *) Device_Type
                          deviceUUID : (NSString *) Device_UUID;
    
- (NSString *) takeBearerTokenURLWithCodeParameters;
- (NSString *) takeBearerTokenBodyParameters;

// 註冊裝置
- (NSString *) signUpDevicesURLWithParameters : (NSString *) OrgunitsUUID;
- (NSMutableArray *) signUpDevicesBodyParameters : (NSString *) OrgunitsUUID;

// 取得裝置資訊
- (NSString *) takeDevicesInformationURLWithParameters : (NSString *) Device_UUID;

// 更新裝置狀態
- (NSString *) refreshDevicesInformationURLWithParameters : (NSString *) Device_UUID;
    
- (NSMutableArray *) refreshDevicesInformationBodyParameters : (NSString *) Code_Value;

// 更新手機狀態
- (NSString *) refreshPhoneInformationURLWithParameters : (NSString *) Client_ID;

// Log In URL 的 Parameters
- (NSString *) getDeviceUUIDThroughModelAndSerialURLWithParameters : (NSString *) Orgunits_String
                                                             model : (NSString *) Model
                                                            serial : (NSString *) Serial;

#pragma mark -- Methods

- (NSString *) Parameters_Merge : (NSMutableArray *) Parameters;

@end

NS_ASSUME_NONNULL_END
