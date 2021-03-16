//
//  OAuthTest.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2021/3/12.
//

#import "OAuthTest.h"
#import "RequestOAuth2Steps.h"

@interface OAuthTest () 
{
    RequestOAuth2Steps *requestOAuth2Steps;
}
@property (strong, nonatomic) NSNotificationCenter *NotiCenter;
@property (strong, nonatomic) NSTimer *Refresh_Token_Expires_Timer;
@property (strong, nonatomic) NSTimer *Refresh_OTP_Expires_Timer;
@end

@implementation OAuthTest

- (instancetype) init {
    NSLog(@"OAuthTestInit");
    requestOAuth2Steps = [RequestOAuth2Steps alloc];
    self.Device_Name = [[UIDevice currentDevice] name];
    return self;
}

- (void) startOAuth {
    self.Orgunits = @"7da0f976-f732-11ea-b7aa-0242ac160004";
    self.Device_Type = @"ios";
    self.Device_ID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    self.NotiCenter = [NSNotificationCenter defaultCenter];
    [self.NotiCenter addObserver:self
                        selector:@selector(getHTMLStringAfterFinishNavigation:)
                            name:@"getHTMLString"
                          object:nil];
    
    self.WKWeb_View = [[WKWebView alloc] init];
    [self setupWebView : self.WKWeb_View];
    NSLog(@"self = %@", self);
    NSLog(@"self.uidelegate = %@", self.WKWeb_View.UIDelegate);
    NSLog(@"self.WKWeb_View = %@", self.WKWeb_View);
    
    if([[Reachability reachabilityWithHostName:@"https://healthng.oucare.com/site/login"] currentReachabilityStatus] == 1) {
        OAuth2Parameters *oAuthParameters = [OAuth2Parameters alloc];
        NSString *RequestURL = [oAuthParameters logInURLWithParameters];
        
        [requestOAuth2Steps     logIn : RequestURL
                            wKWebView : self.WKWeb_View];
        // 當登錄完成後做 get code 動作
    }
}

#pragma mark - WebView Delegate
// 在收到 response 後，决定是否跳轉
// 步驟請參考公司 pigo 建置的 github document
// https://github.com/kjws/ouhealth-ng/blob/master/docs/API-OAuth2.md
// 第一步驟登入後的 response
-(void)
webView                             : (WKWebView *)                             webView
decidePolicyForNavigationResponse   : (WKNavigationResponse *)                  navigationResponse
decisionHandler                     : (void (^)(WKNavigationResponsePolicy))    decisionHandler {
    NSLog(@"NavigationResponse");
    NSURL *URL = navigationResponse.response.URL;
    NSURLComponents *URL_Components = [NSURLComponents componentsWithString:URL.absoluteString];
    
    URLProcess *urlProcess = [URLProcess alloc];
    // 只顯示參數的部分
    NSString *URL_Host = [URL_Components host];
    NSString *URL_Query = [URL_Components query];
    NSString *URL_Path = [URL_Components path];
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    Parameters = [urlProcess getURLParameters:URL_Query];
    
    NSLog(@"URL_Path = %@", URL_Path);
    NSLog(@"Parameters = %@", Parameters);
    if([URL_Host isEqual:@"healthng.oucare.com"]) {
        if([URL_Path  isEqual: @"/oauth/login"]) {
        }
        else if([URL_Path  isEqual: @"/oauth/token"]) {
        }
        //--------- Log in 後 在此取得 log in 後的 code -------
        else if([URL_Path  isEqual: @"/"]){
            /* 登入成功 */
            if([[URL_Query substringWithRange:NSMakeRange(0, 4)] isEqual:@"code"]) {
                NSString *Code = [URL_Query substringFromIndex:5];
                [requestOAuth2Steps takeAccessToken:Code wKWebView:webView];
            }
            /* 登入失敗 */
            else {
                NSLog(@"Log in false");
            }
        }
        // 透過 Serial 取得裝置資訊的回傳
        else if ([URL_Path isEqual:[NSString stringWithFormat:@"%@%@%@", @"/api/v1/orgunits/", self.Orgunits, @"/devices"]]) {
        }
        else {
        }
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void) webView : (WKWebView *) webView didFinishNavigation : (WKNavigation *) navigation {
    NSURL *URL = webView.URL;
    NSURLComponents *URL_Components = [NSURLComponents componentsWithString:URL.absoluteString];
    NSLog(@"[URL_Components path] = %@", [URL_Components path]);
    //-------- 登入後的 -----------
    if([[URL_Components path]  isEqual: @"/oauth/login"]) {
        NSLog(@"didFinishNavigation_oauth/login");
        [requestOAuth2Steps takeCode:webView];
    }
    //--------- 取得 Authorize 後的 -----------
    else if([[URL_Components path]  isEqual: @"/oauth/authorize"]) {
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        NSString *Return_String = [htmlProcess notifyWhenGetHTMLString   : self
                                               webView         : webView];
        NSLog(@"Return_String = %@", Return_String);
    }
    
    // 在取得 Access Token 後
    // 這裡有兩個可能會進入
    // 1. 是在完成以 code 來取得 Access token 和 Refresh token
    // 2. 是在完成以 refresh token 來取得 Access token 和 Refresh token
    else if ([[URL_Components path]  isEqual: @"/oauth/token"]) {
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        [htmlProcess notifyWhenGetHTMLString:self webView:webView];
    }
    // 取得 OTP 後
    else if ([[URL_Components path]  isEqual: @"/api/v1/ouhub/otp"]) {
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        [htmlProcess notifyWhenGetHTMLString:self webView:webView];
    }
    // 如果是註冊後
    else if([[URL_Components path] isEqual:[[NSString alloc] initWithFormat:@"%@%@%@", @"/api/v1/orgunits/", self.Orgunits, @"/devices/registration"]]) {
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        [htmlProcess notifyWhenGetHTMLString:self webView:webView];
    }
    // 透過 Serial 取得裝置 UUID 和 Serial 的回傳
    else if ([[URL_Components path] isEqual:[[NSString alloc] initWithFormat:@"%@%@%@", @"/api/v1/orgunits/", self.Orgunits, @"/devices"]]) {
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        [htmlProcess notifyWhenGetHTMLString:self webView:webView];
    }

    else {
        __block NSString *Return_HTML_String = nil;
        [webView evaluateJavaScript:@"document.documentElement.outerHTML"
                  completionHandler:^(id result, NSError *error) {
            NSLog(@"Evaluateerror = %@", error);
            NSLog(@"Evaluateresult = %@", result);
            if (error == nil) {
                if (result != nil) {
                    Return_HTML_String = [NSString stringWithFormat:@"%@", result];
                    NSLog(@"Return_HTML_String = %@", Return_HTML_String);
                }
            }
            else {
                NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
            }
        }];
        NSLog(@"didfinishnavigation path = %@", [URL_Components path]);
    }
    NSLog(@"didFinishNavigation");
}
- (void)
webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
        NSLog(@"WKNavigationActionPolicyCancel");
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
        NSLog(@"WKNavigationActionPolicyAllow");
    }
}

#pragma mark - Notification Center
- (void) getHTMLStringAfterFinishNavigation : (NSNotification *) notification {
    NSMutableDictionary *HTML_Info_Dict = [[NSMutableDictionary alloc] initWithDictionary:[notification userInfo]];
    NSString *HTML_String = [HTML_Info_Dict valueForKey:@"HTMLString"];
    NSLog(@"HTML_String = %@", HTML_String);
    WKWebView *WebView = [HTML_Info_Dict valueForKey:@"WebView"];
    NSString *URL_Path = [[WebView URL] path];
    
    HTMLProcess *htmlProcess = [HTMLProcess alloc];
    NSDictionary *JSON_Dict = [htmlProcess htmlStringToJsonDictionary:HTML_String];
    NSLog(@"JSON_Dict = %@", JSON_Dict);
    
    if([URL_Path isEqual:@"/oauth/token"]) {
        NSString *Access_Token_Key = @"access_token";
        NSString *Refresh_Token_Key = @"refresh_token";
        NSString *Token_Type_Key = @"token_type";
        NSString *Expires_In_Key = @"expires_in";
        
        NSString *Access_Token = [JSON_Dict valueForKey:Access_Token_Key];
        NSString *Refresh_Token = [JSON_Dict valueForKey:Refresh_Token_Key];
        NSString *Token_Type = [JSON_Dict valueForKey:Token_Type_Key];
        NSInteger Expires_In = [[JSON_Dict valueForKey:Expires_In_Key] intValue];
        
        self.Access_Token = Access_Token;
        self.Refresh_Token = Refresh_Token;
        self.Token_Type = Token_Type;
        self.Expires_In = Expires_In;
        
        // Access Token 的過期判斷
        self.Refresh_Token_Expires_Timer = [NSTimer scheduledTimerWithTimeInterval:3500
                                         target:self
                                       selector:@selector(refreshToken:)
                                       userInfo:nil
                                        repeats:NO];
        
        [self takeOTP:self.Access_Token
          device_Name:self.Device_Name
          device_Type:self.Device_Type
          device_UUID:self.Device_ID
            wKWebView:self.WKWeb_View];
        
        // OTP 的過期判斷
        // Access Token 的過期判斷
        self.Refresh_OTP_Expires_Timer = [NSTimer scheduledTimerWithTimeInterval:3500
                                         target:self
                                       selector:@selector(refreshOTP:)
                                       userInfo:nil
                                        repeats:NO];
    }
    else if([URL_Path isEqual:@"/api/v1/ouhub/otp"]) {
        NSString *Client_ID_Title = @"client_id";
        NSString *User_Name_Title = @"username";
        NSString *OTP_Title = @"otp";
        NSString *OTP_Expired_Title = @"otp_expired";
        
        NSString *Client_ID = [JSON_Dict valueForKey:Client_ID_Title];
        NSString *User_Name = [JSON_Dict valueForKey:User_Name_Title];
        NSString *OTP = [JSON_Dict valueForKey:OTP_Title];
        NSInteger OTP_Expired = [[JSON_Dict valueForKey:OTP_Expired_Title] longValue];
        
        self.Client_ID = Client_ID;
        self.User_Name = User_Name;
        self.OTP = OTP;
        self.OTP_Expired = OTP_Expired;
        
        [self.delegate mqttConnect:Client_ID  userName:User_Name otp:OTP  otpExpired:OTP_Expired];
    }
}

#pragma mark - TIMER

#pragma mark - Get OTP
- (void) takeOTP : Access_Token
     device_Name : Device_Name
     device_Type : Device_Type
     device_UUID : Device_UUID
       wKWebView : WKWeb_View{
    [requestOAuth2Steps takeOTPTest:Access_Token
                        device_Name:[[UIDevice currentDevice] name]
                        device_Type:Device_Type
                        device_UUID:Device_UUID
                          wKWebView:WKWeb_View];
}

#pragma mark METHODS
- (void) setupWebView : (WKWebView *) WKWeb_View {
    NSLog(@"SetUpWeBView");
    //WKWeb_View = [[WKWebView alloc] init];
    WKWeb_View.frame = CGRectZero;
    WKWeb_View.UIDelegate = self;
    WKWeb_View.navigationDelegate = self;
    WKWeb_View.allowsBackForwardNavigationGestures = YES;
    WKWeb_View.scrollView.delegate = nil;
}


@end
