//
//  WebViewController.m
//  MQTTTest
//
//  Created by louie on 2020/11/27.
//

#import "OAuth2Main.h"


@interface OAuth2Main ()
{
    UIViewController *View_Controller_For_Notify;
    //NSNotificationCenter *get_HTMLString_Notification_Center;
}
@end

@implementation OAuth2Main

/**
 * Access Token 可以維持大概一個小時
 */

- (void)InitEnter : (UIViewController *) View_Controller {
    self.delegate = View_Controller;
    // 設定機構
    OAuth.Orgunits = @"7da0f976-f732-11ea-b7aa-0242ac160004";
    OAuth.Device_Type = @"ios";
    OAuth.Device_ID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    View_Controller_For_Notify = View_Controller;
    self.WKWeb_View = [[WKWebView alloc] init];
    [self setupWebView : self.WKWeb_View];
    OAuth2Parameters *oAuthParameters = [OAuth2Parameters alloc];
    NSString *RequestURL = [oAuthParameters logInURLWithParameters];
    RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
    if([[Reachability reachabilityWithHostName:@"https://healthng.oucare.com/site/login"] currentReachabilityStatus] == 1) {
        [requestOAuth2Steps     logIn : RequestURL
                            wKWebView : self.WKWeb_View];
        // 當登錄完成後做 get code 動作
    }
    NSLog(@"afterLogin");
}

- (void)
setupWebView : (WKWebView *) WKWeb_View {
    [WKWeb_View setFrame:CGRectZero];
    [WKWeb_View setUIDelegate:self];
    [WKWeb_View setNavigationDelegate:self];
    [WKWeb_View setAllowsBackForwardNavigationGestures:YES];
    // Constraint
//    [self setupWKWebViewConstain : Base_View
//                       wKWebView : WKWeb_View];
}

#pragma mark WebView Delegate
- (void)
webView             :(WKWebView *)      webView
didFinishNavigation :(WKNavigation *)   navigation {
    NSLog(@"didFinishNavigation URL = %@", [webView URL]);
    NSURL *URL = webView.URL;
    NSURLComponents *URL_Components = [NSURLComponents componentsWithString:URL.absoluteString];
    NSLog(@"[URL_Components path] = %@", [URL_Components path]);
    if([[URL_Components path]  isEqual: @"/oauth/login"]) {
        NSLog(@"didFinishNavigation_oauth/login");
        RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
        [requestOAuth2Steps takeCode:webView];
    }
    
    else if([[URL_Components path]  isEqual: @"/oauth/authorize"]) {
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        NSString *Return_String = [htmlProcess getHTMLString   : self
                                               webView         : webView];
        NSLog(@"Return_String = %@", Return_String);
    }
    
    // 在取得 Access Token 後
    // 這裡有兩個可能會進入
    // 1. 是在完成以 code 來取得 Access token 和 Refresh token
    // 2. 是在完成以 refresh token 來取得 Access token 和 Refresh token
    else if ([[URL_Components path]  isEqual: @"/oauth/token"]) {
        // get_HTMLString_Notification_Center = [NSNotificationCenter defaultCenter];
        NSLog(@"URL_Components = %@",URL_Components);
        [[NSNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(getHTMLStringNotification:) //接收到該Notification時要call的function
            name:@"NotificationName"
            object:nil];
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        [htmlProcess getHTMLString   : self
                     webView         : webView];
    }
    // 取得 OTP 後
    else if ([[URL_Components path]  isEqual: @"/api/v1/ouhub/otp"]) {
        NSLog(@"GetOTP");
        HTMLProcess *htmlProcess = [HTMLProcess alloc];
        [htmlProcess getHTMLString   : self
                     webView         : webView];
    }
    // 如果是註冊後
    else if([[URL_Components path] isEqual:[[NSString alloc] initWithFormat:@"%@%@%@", @"/api/v1/orgunits/", self.Orgunits, @"/devices/registration"]]) {
        NSLog(@"Finish registration");
        [webView evaluateJavaScript:@"document.documentElement.outerHTML"
                  completionHandler:^(id result, NSError *error) {
            NSLog(@"Evaluateerror = %@", error);
            NSLog(@"Evaluateresult = %@", result);
            if (error == nil) {
                if (result != nil) {
                    NSString *TestJson = result;
                    NSInteger Left_Side_Position = [TestJson rangeOfString:@"pre-wrap"].location + 11;
                    NSInteger Right_Side_Position = [TestJson rangeOfString:@"</pre>"].location - 1;
                    NSString *JSON_String = [TestJson substringWithRange:NSMakeRange(Left_Side_Position, Right_Side_Position - Left_Side_Position + 1)];
                    NSLog(@"Finish registration = %@", JSON_String);
                    
                    JSONProcess *Json_Process = [JSONProcess alloc];
                    NSDictionary *Json_Dictionary = [Json_Process NSStringToJSONDict:JSON_String];
                    NSLog(@"New_Json_Dictionary = %@", Json_Dictionary);
                    
                    NSString *Device_Model = [Json_Dictionary valueForKey:@"model"];
                    NSString *Device_UUID = [Json_Dictionary valueForKey:@"uuid"];
                    NSString *Device_Serial = [Json_Dictionary valueForKey:@"serial"];
                    NSString *Device_Status = [Json_Dictionary valueForKey:@"status"];
                    
                    for(int i = 0; i < BLE.Stored_Data.count; i++) {
                        StoredDevicesCell *storedDevicesCell = [StoredDevicesCell alloc];
                        storedDevicesCell = [BLE.Stored_Data objectAtIndex:i];
                        if(!storedDevicesCell.Device_UUID) {
                            NSLog(@"***** Put Model, Serial, UUID and Serial in Stored_Data which were get by registration *****");
                            storedDevicesCell.Device_Model = Device_Model;
                            storedDevicesCell.Device_EPROM = Device_Serial;
                            storedDevicesCell.Device_UUID = Device_UUID;
                            storedDevicesCell.Device_Status = Device_Status;
                            storedDevicesCell.Serial_Been_Register = 1;
                            [BLE.Stored_Data replaceObjectAtIndex:i withObject:storedDevicesCell];
                            // write 入EPROM內
                            NSLog(@"***** Write Serial to EPROM which were get by registration *****");
                            NSData *data = [self hexStringToData:[NSString stringWithFormat:@"%@%@%@", @"05", Device_Serial, @"AA"]];
                            NSLog(@"Write Serial to EPROM = %@", data);
                            [BLE write05ToKS4310EPROM:storedDevicesCell.Peripheral data:data];
                            break;
                        }
                    }
                }
            }
        }];
    }
    // 透過 Serial 取得裝置 UUID 和 Serial 的回傳
    else if ([[URL_Components path] isEqual:[[NSString alloc] initWithFormat:@"%@%@%@", @"/api/v1/orgunits/", self.Orgunits, @"/devices"]]) {
        NSLog(@"***** Return value -- get device information by serial *****");
        [webView evaluateJavaScript:@"document.documentElement.outerHTML"
                  completionHandler:^(id result, NSError *error) {
            NSLog(@"Evaluateerror = %@", error);
            NSLog(@"Evaluateresult = %@", result);
            
            if (error == nil) {
                if (result != nil) {
                    NSString *HTML_String = result;
                    HTMLProcess *html_Process = [HTMLProcess alloc];
                    NSDictionary *Device_Information_Json = [html_Process htmlStringToJsonDictionary:HTML_String];
                    NSLog(@"Return value -- get device information by serial -- Device_Information_Json = %@", Device_Information_Json);
                    NSDictionary *Device_Items_Json_Dictionary = [Device_Information_Json valueForKey:@"items"];
                    NSLog(@"Items_Json_Dictionary = %@", Device_Items_Json_Dictionary);
                    
                    // ------------------ 如果此 Serial 是已註冊 ------------------
                    if(Device_Items_Json_Dictionary.count != 0) {
                        NSLog(@"這個裝置的 Serial 是已註冊的");
                        NSString *Device_Model = [[Device_Items_Json_Dictionary valueForKey:@"model"] objectAtIndex:0];
                        NSString *Device_UUID = [[Device_Items_Json_Dictionary valueForKey:@"uuid"] objectAtIndex:0];
                        NSString *Device_Serial = [[Device_Items_Json_Dictionary valueForKey:@"serial"] objectAtIndex:0];
                        NSString *Device_Status = [[Device_Items_Json_Dictionary valueForKey:@"status"] objectAtIndex:0];
                        NSLog(@"這個裝置的 Serial 是已註冊的 -- Model = %@", Device_Model);
                        NSLog(@"這個裝置的 Serial 是已註冊的 -- UUID = %@", Device_UUID);
                        NSLog(@"這個裝置的 Serial 是已註冊的 -- Serial = %@", Device_Serial);
                        NSLog(@"這個裝置的 Serial 是已註冊的 -- status = %@", Device_Status);
                        
                        // 在取得裝置 EPROM 後更新儲存
                        for(int i = 0 ; i < BLE.Stored_Data.count; i++) {
                            StoredDevicesCell *storedDevicesCell = [StoredDevicesCell alloc];
                            storedDevicesCell = [BLE.Stored_Data objectAtIndex:i];
                            NSLog(@"WHYNORUNIN EPROM = %@", storedDevicesCell.Device_EPROM);
                            NSLog(@"Device_Serial = %@", storedDevicesCell.Device_EPROM);
                            if([[storedDevicesCell.Device_EPROM uppercaseString] isEqual:Device_Serial]) {
                                NSLog(@"Device UUID FOr already register = %@", [[BLE.Stored_Data objectAtIndex:i] Device_UUID]);
                                storedDevicesCell.Device_Model = Device_Model;
                                storedDevicesCell.Device_EPROM = Device_Serial;
                                storedDevicesCell.Device_UUID = Device_UUID;
                                storedDevicesCell.Device_Status = Device_Status;
                                storedDevicesCell.Serial_Been_Register = 1;
                                [BLE.Stored_Data replaceObjectAtIndex:i withObject:storedDevicesCell];
                                break;
                            }
                        }
                        
                    }
                    // ------------------ 如果此 Serial 是未註冊 -----------------
                    else if([[Device_Information_Json valueForKey:@"_links"] count] != 0) {
                        NSString *URL_String = [[[Device_Information_Json valueForKey:@"_links"] valueForKey:@"self"] valueForKey:@"href"];
                        NSLog(@"Not registered = %@", URL_String);
                        NSString *Serial_Title_String = @"serial%5D=";
                        NSInteger Serial_Title_Length = [Serial_Title_String length];
                        NSInteger Serial_Title_Location = [URL_String rangeOfString:Serial_Title_String].location;
                        
                        NSString *After_Serial_String = @"&amp;page";
                        NSInteger After_Serial_String_Location = [URL_String rangeOfString:After_Serial_String].location;
                        
                        NSLog(@"Serial_String_Not_Register_Previous = %ld", Serial_Title_Location);
                        NSLog(@"Serial_String_Not_Register_After = %ld", After_Serial_String_Location);
                        NSInteger Serial_Length = After_Serial_String_Location - (Serial_Title_Location + Serial_Title_Length);
                        NSString *Serial_String = [URL_String substringWithRange:NSMakeRange(Serial_Title_Location + Serial_Title_Length , Serial_Length)];
                        NSLog(@"Serial_String_Not_Register = %@", Serial_String);
                        for(int i = 0; i < BLE.Stored_Data.count; i++) {
                            StoredDevicesCell *cell = [StoredDevicesCell alloc];
                            cell = [BLE.Stored_Data objectAtIndex:i];
                            NSLog(@"Serial_String_Not_Register_EPROM = %@", [cell Device_EPROM]);
                            if([Serial_String isEqual: [cell Device_EPROM]]) {
                                cell.Serial_Been_Register = 0;
                                [BLE.Stored_Data replaceObjectAtIndex:i withObject:cell];
                            }
                        }
                        NSLog(@"***** This KS-4310 device have not registerd. *****");
//                        StoredDevicesCell *cell = [StoredDevicesCell alloc];
                        //cell = [BLE.Stored_Data objectAtIndex:<#(NSUInteger)#>]
                        // 開始註冊
//                        [OAuth signUpDevice:self.Access_Token
//                                   orgunits:self.Orgunits
//                                  wkWebView:self.WKWeb_View];
                    }
                    else {
                    }
                }
            } else {
                NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
            }
        }];
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
//    else {
//        // 取得 code
//        URLProcess *urlProcess = [URLProcess alloc];
//        NSString *URL_Query = [[webView URL] query];
//        NSLog(@"URL_Query = %@", URL_Query);
//        NSMutableArray *Parameters = [urlProcess getURLParameters:URL_Query];
//        NSLog(@"Parameters = %@", Parameters);
//        NSMutableDictionary *Code_Dict = [Parameters objectAtIndex:0];
//        NSLog(@"Code_Dict = %@", Code_Dict);
//        NSString *Code_Key = @"code";
//        NSLog(@"NotYetGetInto = %@", [Code_Dict allKeys]);
//        // 取得 access token
//        if([[[Code_Dict allKeys]objectAtIndex:0] isEqual:Code_Key]) {
//            NSLog(@"getintocodekey");
//            NSString *Code_Value = [Code_Dict valueForKey:Code_Key];
//            NSLog(@"Code_Value = %@", Code_Value);
////            RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
////            [requestOAuth2Steps takeAccessToken:Code_Value
////                                      wKWebView:webView];
//            HTMLProcess *htmlProcess = [HTMLProcess alloc];
//            [htmlProcess getHTMLString   : self
//                         webView         : webView];
//        }
//    }
    NSLog(@"didFinishNavigation");
}
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
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    Parameters = [urlProcess getURLParameters:URL_Query];
    NSLog(@"Parameters = %@", Parameters);
    NSString *URL_Path = [URL_Components path];
    NSLog(@"URL_Path = %@", URL_Path);
    if([URL_Host isEqual:@"healthng.oucare.com"]) {
        if([[URL_Components path]  isEqual: @"/oauth/login"]) {
            
        }
        else if([[URL_Components path]  isEqual: @"/oauth/token"]) {
            
        }
        // Log in回傳的
        else if([[URL_Components path]  isEqual: @"/"]){
            if([[URL_Query substringWithRange:NSMakeRange(0, 4)] isEqual:@"code"]) {
                NSString *Code = [URL_Query substringFromIndex:5];
                RequestOAuth2Steps *requestOAuth2Steps = [[RequestOAuth2Steps alloc] init];
                [requestOAuth2Steps takeAccessToken:Code wKWebView:webView];
            }
        }
        // 透過 Serial 取得裝置資訊的回傳
        else if ([[URL_Components path] isEqual:@"/api/v1/orgunits/7da0f976-f732-11ea-b7aa-0242ac160004/devices"]) {
            
        }
        else {
            
        }
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
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

/// autoLayout 設定
- (void)setupWKWebViewConstain : (UIView *) ViewController
                     wKWebView : (WKWebView *) webView {
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 四個邊的距離設定為零
    NSLayoutConstraint *topConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeTop
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: ViewController
                                 attribute: NSLayoutAttributeTop
                                multiplier: 1.0
                                  constant: 0];
    
    NSLayoutConstraint *bottomConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeBottom
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: ViewController
                                 attribute: NSLayoutAttributeBottom
                                multiplier: 1.0
                                  constant: 0];
    
    NSLayoutConstraint *leftConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeLeft
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: ViewController
                                 attribute: NSLayoutAttributeLeft
                                multiplier: 1.0
                                  constant: 0];
    
    NSLayoutConstraint *rightConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeRight
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: ViewController
                                 attribute: NSLayoutAttributeRight
                                multiplier: 1.0
                                  constant: 0];
    
    NSArray *constraints = @[
                             topConstraint,
                             bottomConstraint,
                             leftConstraint,
                             rightConstraint
                             ];
    
    [ViewController addConstraints:constraints];
}

- (BOOL) HaveLogInCookies : (WKWebView *) WKWeb_View {
    // cookies
    WKHTTPCookieStore *cookieStore = WKWeb_View.configuration.websiteDataStore.httpCookieStore;
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    NSDictionary *headers = [[NSDictionary alloc] init];
    [cookieStore getAllCookies:^(NSArray* cookies) {
        if (cookies.count > 0) {
            for (NSHTTPCookie *cookie in cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                [cookieArray addObject:cookie];
                if([cookie.name isEqual:@"_identity"]) {
                    
                }
                if([cookie.name isEqual:@"PHPSESSID"]) {
                    
                }
                if([cookie.name isEqual:@"_csrf"]) {
                    
                }
            }
        }
    }];
    headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    return true;
}

- (void)
getHTMLStringNotification:(NSNotification *)notification {
    NSLog(@"getIntogetHTMLStringNotification");
    NSDictionary *userInfo = [notification userInfo]; //讀取userInfo
    NSString *HTTP_String_Key = [[userInfo allKeys] objectAtIndex:0];
    NSMutableArray *HTTP_Information = [[userInfo allValues] objectAtIndex:0];
    NSString *HTTP_String_Value = [HTTP_Information objectAtIndex:0];
    NSLog(@"HTTP_String_Value = %@", HTTP_String_Value);
    WKWebView *WKWeb_View = [HTTP_Information objectAtIndex:1];
    NSLog(@"HTTP_String_Key = %@", HTTP_String_Key);
    
    HTMLProcess *htmlProcess = [HTMLProcess alloc];
    NSString *HTTP_String_JSON = [htmlProcess htmlStringToJSONFormatString:HTTP_String_Value];
    NSLog(@"HTTP_String_JSON = %@", HTTP_String_JSON);
    JSONProcess *Json_Process = [JSONProcess alloc];
    NSDictionary *Json_Dictionary = [Json_Process NSStringToJSONDict:HTTP_String_JSON];
    NSLog(@"Json_Dictionary = %@", Json_Dictionary);
    if([HTTP_String_Key isEqual: @"/oauth/token"]) {
        self.Access_Token = [Json_Dictionary valueForKey:@"access_token"];
        self.Refresh_Token = [Json_Dictionary valueForKey:@"refresh_token"];
        
        NSLog(@"Access_Token = %@", self.Access_Token);
        NSLog(@"Refresh_Token123 = %@", self.Refresh_Token);
        
        [self.delegate dismissAlertViewForWebNavigatin];
        //    暫時沒有使用 Refresh Token 來做 Refresh 的動作
//        [self takeRefreshAccesssTokenThroughRefreshToken:Refresh_Token];
        RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
        [requestOAuth2Steps takeOTP   : self.Access_Token
                            wKWebView : WKWeb_View];
    }
    else if ([HTTP_String_Key  isEqual: @"/api/v1/ouhub/otp"]) {
        NSLog(@"Get OTP json dictionary = %@", Json_Dictionary);
        NSString *Client_ID = [Json_Dictionary valueForKey:@"client_id"];
        NSString *User_Name = [Json_Dictionary valueForKey:@"username"];
        NSString *OTP = [Json_Dictionary valueForKey:@"otp"];
        NSString *OTP_Expired = [Json_Dictionary valueForKey:@"otp_expired"];
        
        NSLog(@"OTPValue = %@", Client_ID);
        NSLog(@"OTPValue = %@", User_Name);
        NSLog(@"OTPValue = %@", OTP);
        NSLog(@"OTPValue = %@", OTP_Expired);

        // Set OTP Value As Dictionary To Send TO Notification Reciever;
        NSMutableArray *OTP_Information = [[NSMutableArray alloc] init];
        [OTP_Information addObject: Client_ID];
        [OTP_Information addObject: User_Name];
        [OTP_Information addObject: OTP];
        [OTP_Information addObject: OTP_Expired];
        NSDictionary *OTP_Information_Dictionary = [NSDictionary dictionaryWithObject:OTP_Information forKey:User_Name];
        
        MqttMain = [MQTTMain new];
        [MqttMain mqttStart:[OTP_Information_Dictionary allValues] viewController:nil];
        
        // Set notification to trigger getOAuth
        [[NSNotificationCenter defaultCenter]
            postNotificationName:@"getOAuthOTPNotification" //Notification以一個字串(Name)下去辨別
            object:View_Controller_For_Notify
            userInfo:OTP_Information_Dictionary];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:@"NotificationName"
                                                      object:nil];
    }
}
//
- (void) getDevicesInformationNotification:(NSNotification *)notification {
    
}

- (void) connectDeviceToServer : (NSData *) EPROM {
    NSLog(@"NewStrForEPROMDATA = %@", EPROM);
    
    NSString* newStr = [[NSString alloc] initWithData:EPROM encoding:NSASCIIStringEncoding];
    NSLog(@"newStrForEPROM = %@", newStr);
    
    NSString *EPROM_String = [[self stringToHex:newStr] uppercaseString];
    NSLog(@"NewNewHexString = %@", EPROM_String);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
        [requestOAuth2Steps getDeviceUUIDThroughModelAndSerial:self.Access_Token
                                                      orgunits:self.Orgunits
                                                     wKWebView:self.WKWeb_View
                                                         model:@"KS-4310"
                                                        serial:EPROM_String];
    }];
}

- (void) signUpDevice : (NSString *) Access_Token
             orgunits : (NSString *) Orgunits
            wkWebView : (WKWebView *) WKWebView{
    NSLog(@"***** Register KS-4310 device *****");
    RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
    NSDate *start = [NSDate date];
    [requestOAuth2Steps signUpDevices:Access_Token
                             orgunits:Orgunits
                         timeInterval:[start timeIntervalSince1970]
                            wKWebView:WKWebView];
}

#pragma mark -- METHODS
// String to HEX
- (NSString *) stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];

    NSMutableString *hexString = [[NSMutableString alloc] init];

    for(NSUInteger i = 0; i < len; i++ )
    {
        // [hexString [NSString stringWithFormat:@"%02x", chars[i]]]; /*previous input*/
        [hexString appendFormat:@"%02x", chars[i]]; /*EDITED PER COMMENT BELOW*/
    }

    return hexString;
}

- (NSData *) hexStringToData : (NSString *) Hex_String {
    NSString *command = Hex_String;

    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    NSLog(@"%@", commandToSend);
    return commandToSend;
}

// 取得裝置資訊
- (void)
takeDevicesInformation          : (NSString *)  Access_Token
deviceUUID                      : (NSString *)  Device_UUID
wKWebView                       : (WKWebView *) WKWebView {
    RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
    [requestOAuth2Steps takeDevicesInformation:Access_Token deviceUUID:Device_UUID wKWebView:WKWebView];
}

// 更新裝置資訊
- (void) refreshDevicesInformation          : (NSString *)  Access_Token
                            status          : (NSInteger)   Status
                        deviceUUID          : (NSString *)  Device_UUID
                         wKWebView          : (WKWebView *) WKWebView {
    RequestOAuth2Steps *requestOAuth2Steps = [RequestOAuth2Steps alloc];
    [requestOAuth2Steps refreshDevicesInformation:Access_Token
                                           status:Status
                                       deviceUUID:Device_UUID
                                        wKWebView:WKWebView];
}
@end
