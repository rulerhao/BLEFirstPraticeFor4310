//
//  RequestOAuth2Steps.m
//  MQTTTest
//
//  Created by louie on 2020/12/10.
//

#import "RequestOAuth2Steps.h"

@interface RequestOAuth2Steps ()

@end

@implementation RequestOAuth2Steps

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 登錄用的URL設定
// ------------------- Step 1 - App 登入 -------------------
- (void)
logIn       :   (NSString *)    requestURLString
wKWebView   :   (WKWebView *)   WKWebView {
    NSURL *url = [[NSURL alloc] initWithString: requestURLString];
    OAuth2Parameters *oAuthParameters = [OAuth2Parameters alloc];
    NSString *Body_String = [oAuthParameters Parameters_Merge:[oAuthParameters logInBodyParameters] ];
    NSData *Body = [Body_String dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSLog(@"BodyTest = %@", Body);
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[Body length]];
    NSLog(@"WKWebViewDelegate = %@", [WKWebView UIDelegate]);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSLog(@"WKWebView = %@", WKWebView);
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:Body];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:true];
    NSLog(@"Request = %@", request);
    [WKWebView loadRequest: request];
}

// ------------------- Step 2 取得 Auth Code (使用 PKCE) -------------------
- (void)takeCode : (WKWebView *) WKWebView {
    // cookies
    WKHTTPCookieStore *cookieStore = WKWebView.configuration.websiteDataStore.httpCookieStore;
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    NSDictionary *headers = [[NSDictionary alloc] init];
    [cookieStore getAllCookies:^(NSArray* cookies) {
        NSLog(@"cookies.count = %lu", (unsigned long)cookies.count);
        if (cookies.count > 0) {
            for (NSHTTPCookie *cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                [cookieArray addObject:cookie];
            }
        }
    }];
    headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    
    OAuth2Parameters *oAuthParameters = [OAuth2Parameters alloc];
    NSString *urlString = [oAuthParameters takeCodeURLWithParameters];
    NSLog(@"urlString1234 = %@", urlString);
    NSURL *url = [[NSURL alloc] initWithString: urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPShouldHandleCookies:true];
    [WKWebView loadRequest: request];
}
// ------------------- Step 3 Access Token -------------------
- (void)
takeAccessToken : (NSString *) Code_Value
wKWebView       : (WKWebView *) WKWebView {
    NSLog(@"Code_Value = %@", Code_Value);
    OAuth2Parameters *oAuthParameters = [OAuth2Parameters alloc];
    NSURL *url = [[NSURL alloc] initWithString: [oAuthParameters takeAccessTokenURLWithCodeParameters]];
    
    NSString *Body_String = [oAuthParameters Parameters_Merge:[oAuthParameters takeAccessTokenBodyParameters:Code_Value] ];;
    NSData *Body = [Body_String dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[Body length]];
    NSLog(@"Body_String = %@", Body_String);
    NSLog(@"URLOFTEAKEAT = %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:Body];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:true];
    NSLog(@"request = %@", request);
    [WKWebView loadRequest: request];
}

- (void)
takeRefreshAccesssTokenThroughRefreshToken : (NSString *)  Refresh_Token
wKWebView                                  : (WKWebView *) WKWebView {
    // get URL with Parameters
    OAuth2Parameters *oAuthParameters = [OAuth2Parameters alloc];
    NSURL *url = [[NSURL alloc] initWithString: [oAuthParameters takeRefreshTokenURLWithCodeParameters]];
    
    // set Body
    NSString *Body_String = [oAuthParameters Parameters_Merge:[oAuthParameters takeRefreshTokenBodyParameters:Refresh_Token] ];
    NSData *Body = [Body_String dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[Body length]];
    NSLog(@"Body_String = %@", Body_String);
    NSLog(@"URLOFTEAKEAT = %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:Body];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:true];
    [WKWebView loadRequest: request];
}

// Take OTP
- (void)
takeOTP         : (NSString *)  Access_Token
wKWebView       : (WKWebView *) WKWebView {
    NSLog(@"takeOTP");
    
    NSString *Device_Type = @"ios";
    NSString *Device_UUID = @"92ee96a5-ff9a-11ea-8fd3-0242ac160004";
    // URL
    NSURL *URL = [[NSURL alloc] initWithString:@"https://healthng.oucare.com/api/v1/ouhub/otp"];

    NSLog(@"sign up url = %@", URL);

    // Authorization
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", Access_Token];

    // Body
    
    NSMutableDictionary *Dict = [[NSMutableDictionary alloc] init];

    [Dict setValue:Device_Type forKey:@"device_type"];
    [Dict setValue:Device_UUID forKey:@"device_uuid"];
    
    NSDictionary *PostDict = [[NSDictionary alloc] initWithDictionary:Dict];

    NSLog(@"PostDict = %@", PostDict);

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:PostDict options:0 error:nil];
    NSString *urlString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSLog(@"stringData = %@", urlString);
    NSData *requestBodyData = [urlString dataUsingEncoding:NSUTF8StringEncoding];

    NSString *requestBodyDataLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBodyData length]];

    // Set Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBodyData];
    [request setValue:requestBodyDataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPShouldHandleCookies:true];

    [OAuth.WKWeb_View loadRequest: request];
}

- (void)
takeDevicesInformation          : (NSString *)  Access_Token
             wKWebView          : (WKWebView *) WKWebView {
    
    OAuth2Parameters *oAuthParameters = [OAuth2Parameters alloc];
    NSURL *URL = [[NSURL alloc] initWithString: [oAuthParameters takeDevicesInformationURLWithParameters]];
    
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", Access_Token];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPShouldHandleCookies:true];

    [OAuth.WKWeb_View loadRequest: request];
}

// 註冊裝置
- (void)
signUpDevices          : (NSString *)  Access_Token
orgunits               : (NSString *)  Orgunits
    wKWebView          : (WKWebView *) WKWebView {
    NSLog(@"signUp");
    // URL
    OAuth2Parameters *oAuthParameters = [OAuth2Parameters alloc];
    NSURL *URL = [[NSURL alloc] initWithString: [oAuthParameters signUpDevicesURLWithParameters:Orgunits]];
    
    NSLog(@"sign up url = %@", URL);
    
    // Authorization
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", Access_Token];
    
    // Body
    EncodeOrguitsUUIDAndTimeStamp *encodeOrguitsUUIDAndTimeStamp = [[EncodeOrguitsUUIDAndTimeStamp alloc] init];
    NSDate *start = [NSDate date];
    NSDictionary *PostDict = [[NSDictionary alloc] initWithDictionary:[encodeOrguitsUUIDAndTimeStamp getDeviceSerialDictionary:@"KS-4310" inputString:Orgunits timeInterval:[start timeIntervalSince1970]]];
    
    NSLog(@"PostDict = %@", PostDict);

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:PostDict options:0 error:nil];
    NSString *urlString =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSLog(@"stringData = %@", urlString);
    NSData *requestBodyData = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *requestBodyDataLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBodyData length]];

    // Set Request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:requestBodyData];
    [request setValue:requestBodyDataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPShouldHandleCookies:true];

    [OAuth.WKWeb_View loadRequest: request];
}
@end
