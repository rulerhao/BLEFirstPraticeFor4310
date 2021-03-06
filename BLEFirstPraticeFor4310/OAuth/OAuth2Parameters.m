//
//  OAuthParameters.m
//  MQTTTest
//
//  Created by louie on 2020/12/2.
//

#import "OAuth2Parameters.h"

@interface OAuth2Parameters ()

@end

@implementation OAuth2Parameters

/**
 * 例如 Parameter[0] 現在變成 Cilent_ID
 * Parameter[0][0] 現在變成 Client_ID_Title
 * Parameter[0][1] 現在變成 Client_ID_Value
 */

// 登入
- (NSMutableArray *) logInParameters {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"29e8b6d5-0c51-11eb-9788-0242ac160004";
    NSMutableArray *Parameters_For_Client_ID =[[NSMutableArray alloc] init];
    [Parameters_For_Client_ID addObject:Client_ID_Title];
    [Parameters_For_Client_ID addObject:Client_ID_Value];
    [Parameters addObject:Parameters_For_Client_ID];
    
    NSString *Redirect_URL_Title = @"redirect_uri";
    NSString *Redirect_URL_Value = @"https://healthng.oucare.com";
    NSMutableArray *Parameters_For_Redirect_URL =[[NSMutableArray alloc] init];
    [Parameters_For_Redirect_URL addObject:Redirect_URL_Title];
    [Parameters_For_Redirect_URL addObject:Redirect_URL_Value];
    [Parameters addObject:Parameters_For_Redirect_URL];
    
    NSString *Scope_Title = @"scope";
    NSString *Scope_Value = @"ouhub.connect";
    NSMutableArray *Parameters_For_Scope =[[NSMutableArray alloc] init];
    [Parameters_For_Scope addObject:Scope_Title];
    [Parameters_For_Scope addObject:Scope_Value];
    [Parameters addObject:Parameters_For_Scope];
    
    NSString *Response_Mode_Title = @"response_mode";
    NSString *Response_Mode_Value = @"redirect";
    NSMutableArray *Parameters_For_Response_Mode =[[NSMutableArray alloc] init];
    [Parameters_For_Response_Mode addObject:Response_Mode_Title];
    [Parameters_For_Response_Mode addObject:Response_Mode_Value];
    [Parameters addObject:Parameters_For_Response_Mode];
    
    NSString *Code_Challenge_Title = @"code_challenge";
    NSString *Code_Challenge_Value = @"ocYCWfMwcSjWZok91g7EAZsKLdqPI7Nn_qoUWIdHHM4";
    NSMutableArray *Parameters_For_Code_Challenge =[[NSMutableArray alloc] init];
    [Parameters_For_Code_Challenge addObject:Code_Challenge_Title];
    [Parameters_For_Code_Challenge addObject:Code_Challenge_Value];
    [Parameters addObject:Parameters_For_Code_Challenge];
    
    NSLog(@"Test = %@", [[Parameters objectAtIndex:0] objectAtIndex:0]);
    return Parameters;
}

// Log In 的 parameters
- (NSMutableArray *) logInBodyParameters {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    NSString *User_Name_Title = @"username";
    NSString *Uesr_Name_Value = @"kjump";
    NSMutableArray *Parameters_For_Uesr_Name =[[NSMutableArray alloc] init];
    [Parameters_For_Uesr_Name addObject:User_Name_Title];
    [Parameters_For_Uesr_Name addObject:Uesr_Name_Value];
    [Parameters addObject:Parameters_For_Uesr_Name];
    
    NSString *Password_Title = @"password";
    NSString *Password_Value = @"1234qwer";
    NSMutableArray *Parameters_For_Password =[[NSMutableArray alloc] init];
    [Parameters_For_Password addObject:Password_Title];
    [Parameters_For_Password addObject:Password_Value];
    [Parameters addObject:Parameters_For_Password];
    return Parameters;
}

// Log In URL 的 Parameters
- (NSString *) logInURLWithParameters {
    NSString *URL_With_Parameters = @"";
    NSString *Origin_URL = @"https://healthng.oucare.com/oauth/login";
    NSString *Parameters_Syntax = @"?";
    
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    Parameters = [self logInParameters];
    
    NSString *Parameters_String;
    // get string contains all parameters
    Parameters_String = [self Parameters_Merge:Parameters];
    NSLog(@"Parameters_String = %@", Parameters_String);
    // get string url with all parameters
    URL_With_Parameters = [NSString stringWithFormat:@"%@%@%@", Origin_URL, Parameters_Syntax, Parameters_String];
    NSLog(@"URL_With_Parameters = %@", URL_With_Parameters);
    
    return URL_With_Parameters;
}

// 取得 code 的 Parameters
- (NSMutableArray *) takeCodeParameter {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"29e8b6d5-0c51-11eb-9788-0242ac160004";
    NSMutableArray *Parameters_For_Client_ID =[[NSMutableArray alloc] init];
    [Parameters_For_Client_ID addObject:Client_ID_Title];
    [Parameters_For_Client_ID addObject:Client_ID_Value];
    [Parameters addObject:Parameters_For_Client_ID];
    
    NSString *Response_Type_Title = @"response_type";
    NSString *Response_Type_Value = @"code";
    NSMutableArray *Parameters_For_Response_Type =[[NSMutableArray alloc] init];
    [Parameters_For_Response_Type addObject:Response_Type_Title];
    [Parameters_For_Response_Type addObject:Response_Type_Value];
    [Parameters addObject:Parameters_For_Response_Type];
    
    NSString *Redirect_URI_Title = @"redirect_uri";
    NSString *Redirect_URI_Value = @"https://healthng.oucare.com";
    NSMutableArray *Parameters_For_Redirect_URI =[[NSMutableArray alloc] init];
    [Parameters_For_Redirect_URI addObject:Redirect_URI_Title];
    [Parameters_For_Redirect_URI addObject:Redirect_URI_Value];
    [Parameters addObject:Parameters_For_Redirect_URI];
    
    NSString *Code_Challenge_Title = @"code_challenge";
    NSString *Code_Challenge_Value = @"ocYCWfMwcSjWZok91g7EAZsKLdqPI7Nn_qoUWIdHHM4";
    NSMutableArray *Parameters_For_Code_Challenge =[[NSMutableArray alloc] init];
    [Parameters_For_Code_Challenge addObject:Code_Challenge_Title];
    [Parameters_For_Code_Challenge addObject:Code_Challenge_Value];
    [Parameters addObject:Parameters_For_Code_Challenge];
    
    NSString *Code_Challenge_Method_Title = @"code_challenge_method";
    NSString *Code_Challenge_Method_Value = @"S256";
    NSMutableArray *Parameters_For_Code_Challenge_Method =[[NSMutableArray alloc] init];
    [Parameters_For_Code_Challenge_Method addObject:Code_Challenge_Method_Title];
    [Parameters_For_Code_Challenge_Method addObject:Code_Challenge_Method_Value];
    [Parameters addObject:Parameters_For_Code_Challenge_Method];
    
    NSLog(@"parametersForCode = %@", Parameters);
    NSLog(@"TestParameters = %@", [[Parameters objectAtIndex:0] objectAtIndex:0]);
    return Parameters;
}

// 取得 Code 的 Parameters
- (NSString *) takeCodeURLWithParameters {
    NSString *URL_With_Parameters = @"";
    NSString *Origin_URL = @"https://healthng.oucare.com/oauth/authorize";
    NSString *Parameters_Syntax = @"?";
    
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    Parameters = [self takeCodeParameter];
    
    NSString *Parameters_String;
    // get string contains all parameters
    Parameters_String = [self Parameters_Merge:Parameters];
    NSLog(@"Parameters_String = %@", Parameters_String);
    // get string url with all parameters
    URL_With_Parameters = [NSString stringWithFormat:@"%@%@%@", Origin_URL, Parameters_Syntax, Parameters_String];
    NSLog(@"URL_With_Parameters = %@", URL_With_Parameters);
    
    return URL_With_Parameters;
}

// 取得 Access token 的 Parameters
- (NSMutableArray *) takeAccessTokenBodyParameters : (NSString *) Code_Value {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"29e8b6d5-0c51-11eb-9788-0242ac160004";
    NSMutableArray *Parameters_For_Client_ID =[[NSMutableArray alloc] init];
    [Parameters_For_Client_ID addObject:Client_ID_Title];
    [Parameters_For_Client_ID addObject:Client_ID_Value];
    [Parameters addObject:Parameters_For_Client_ID];
    
    NSString *Grant_Type_Title = @"grant_type";
    NSString *Grant_Type_Value = @"authorization_code";
    NSMutableArray *Parameters_For_Grant_Type =[[NSMutableArray alloc] init];
    [Parameters_For_Grant_Type addObject:Grant_Type_Title];
    [Parameters_For_Grant_Type addObject:Grant_Type_Value];
    [Parameters addObject:Parameters_For_Grant_Type];
    
    NSString *Parameter_Code_Title = @"code";
    NSString *Parameter_Code_Value = Code_Value;
    NSMutableArray *Parameters_For_Parameter_Code =[[NSMutableArray alloc] init];
    [Parameters_For_Parameter_Code addObject:Parameter_Code_Title];
    [Parameters_For_Parameter_Code addObject:Parameter_Code_Value];
    [Parameters addObject:Parameters_For_Parameter_Code];
    
    NSString *Redirect_URI_Title = @"redirect_uri";
    NSString *Redirect_URI_Value = @"https://healthng.oucare.com";
    NSMutableArray *Parameters_For_Redirect_URI =[[NSMutableArray alloc] init];
    [Parameters_For_Redirect_URI addObject:Redirect_URI_Title];
    [Parameters_For_Redirect_URI addObject:Redirect_URI_Value];
    [Parameters addObject:Parameters_For_Redirect_URI];
    
    NSString *Code_Verifier_Method_Title = @"code_verifier";
    NSString *Code_Verifier_Method_Value = @"ThisIsntRandomButItNeedsToBe43CharactersLong";
    NSMutableArray *Parameters_For_Code_Verifier_Method =[[NSMutableArray alloc] init];
    [Parameters_For_Code_Verifier_Method addObject:Code_Verifier_Method_Title];
    [Parameters_For_Code_Verifier_Method addObject:Code_Verifier_Method_Value];
    [Parameters addObject:Parameters_For_Code_Verifier_Method];
    
    NSLog(@"parametersForCode = %@", Parameters);
    NSLog(@"TestParameters = %@", [[Parameters objectAtIndex:0] objectAtIndex:0]);
    return Parameters;
}

// 取得 Access Token 的 Parameters
- (NSString *) takeAccessTokenURLWithCodeParameters {
    NSString *Origin_URL = @"https://healthng.oucare.com/oauth/token";
    return Origin_URL;
}

// 第四步驟 用RefreshToken取得AccessToken時所需要的參數
- (NSMutableArray *) takeRefreshTokenBodyParameters : (NSString *) Refresh_Token {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"29e8b6d5-0c51-11eb-9788-0242ac160004";
    NSMutableArray *Parameters_For_Client_ID =[[NSMutableArray alloc] init];
    [Parameters_For_Client_ID addObject:Client_ID_Title];
    [Parameters_For_Client_ID addObject:Client_ID_Value];
    [Parameters addObject:Parameters_For_Client_ID];
    
    NSString *Grant_Type_Title = @"grant_type";
    NSString *Grant_Type_Value = @"refresh_token";
    NSMutableArray *Parameters_For_Grant_Type =[[NSMutableArray alloc] init];
    [Parameters_For_Grant_Type addObject:Grant_Type_Title];
    [Parameters_For_Grant_Type addObject:Grant_Type_Value];
    [Parameters addObject:Parameters_For_Grant_Type];
    
    NSString *Refresh_Token_Title = @"refresh_token";
    NSString *Refresh_Token_Value = Refresh_Token;
    NSMutableArray *Parameters_For_Refresh_Token =[[NSMutableArray alloc] init];
    [Parameters_For_Refresh_Token addObject:Refresh_Token_Title];
    [Parameters_For_Refresh_Token addObject:Refresh_Token_Value];
    [Parameters addObject:Parameters_For_Refresh_Token];
    
    NSLog(@"parametersForCode = %@", Parameters);
    NSLog(@"TestParameters = %@", [[Parameters objectAtIndex:0] objectAtIndex:0]);
    return Parameters;
}

- (NSString *) takeRefreshTokenURLWithCodeParameters {
    NSString *Origin_URL = @"https://healthng.oucare.com/oauth/token";
    return Origin_URL;
}

- (NSString *) takeBearerTokenURLWithCodeParameters {
    NSString *Origin_URL = @"https://healthng.oucare.com/api/v1/ouhub/otp";
    return Origin_URL;
}

- (NSString *) takeBearerTokenBodyParameters : (NSString *) Device_Type
                                  deviceUUID : (NSString *) Device_UUID {
    NSString *Origin_URL = @"https://healthng.oucare.com/api/v1/ouhub/otp";
    NSString *Device_Type_Title = @"device_type";
    NSString *Device_Type_Value = OAuth.Device_Type;
    NSString *Device_UUID_Ttile = @"device_uuid";
    NSString *Device_UUID_Value = OAuth.Device_ID;
    
    NSString *JSON_Data = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}", Device_Type_Title, Device_Type_Value, Device_UUID_Ttile, Device_UUID_Value];
    NSLog(@"Bearer_URL = %@", JSON_Data);
    return JSON_Data;
}

// 註冊裝置
- (NSString *) signUpDevicesURLWithParameters : (NSString *) OrgunitsUUID {
    NSMutableString *URL = [[NSMutableString alloc] init];
    NSString *Origin_URL = @"https://healthng.oucare.com/api/v1/orgunits/";
    NSString *Origin_URL2 = @"/devices/registration";
    
    [URL appendString:Origin_URL];
    [URL appendString:OrgunitsUUID];
    [URL appendString:Origin_URL2];
    
    return URL;
}

- (NSMutableArray *) signUpDevicesBodyParameters : (NSString *) OrgunitsUUID {
    EncodeOrguitsUUIDAndTimeStamp *encodeOrguitsUUIDAndTimeStamp = [[EncodeOrguitsUUIDAndTimeStamp alloc] init];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Model_Title = @"model";
    NSString *Model_Value = @"KS-4310";
    NSMutableArray *Parameters_For_Model =[[NSMutableArray alloc] init];
    [Parameters_For_Model addObject:Model_Title];
    [Parameters_For_Model addObject:Model_Value];
    [Parameters addObject:Parameters_For_Model];
    
    NSString *Serial_Title = @"serial";
    NSString *Serial_Value = [encodeOrguitsUUIDAndTimeStamp getSerialString:OrgunitsUUID timeInterval:timeInterval];
    NSMutableArray *Parameters_For_Serial =[[NSMutableArray alloc] init];
    [Parameters_For_Serial addObject:Serial_Title];
    [Parameters_For_Serial addObject:Serial_Value];
    [Parameters addObject:Parameters_For_Serial];
    
    NSString *Time_Title = @"time";
    NSString *Time_Value = [NSString stringWithFormat:@"%f", timeInterval];
    NSMutableArray *Parameters_For_Time = [[NSMutableArray alloc] init];
    [Parameters_For_Time addObject:Time_Title];
    [Parameters_For_Time addObject:Time_Value];
    [Parameters addObject:Parameters_For_Time];
    
    NSLog(@"parametersForCode = %@", Parameters);
    NSLog(@"TestParameters = %@", [[Parameters objectAtIndex:0] objectAtIndex:0]);
    return Parameters;
}
// 取得裝置資訊
- (NSString *) takeDevicesInformationURLWithParameters : (NSString *) Device_UUID {
    NSString *Origin_URL = [[NSString alloc] initWithFormat:@"%@%@", @"https://healthng.oucare.com/api/v1/devices/", Device_UUID];
    return Origin_URL;
}
// 更新裝置狀態
- (NSString *) refreshDevicesInformationURLWithParameters : (NSString *) Device_UUID {
    NSString *Origin_URL = [[NSString alloc] initWithFormat:@"%@%@%@", @"https://healthng.oucare.com/api/v1/devices/", Device_UUID, @"/status"];
    return Origin_URL;
}

- (NSMutableArray *) refreshDevicesInformationBodyParameters : (NSString *) Code_Value {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"29e8b6d5-0c51-11eb-9788-0242ac160004";
    NSMutableArray *Parameters_For_Client_ID =[[NSMutableArray alloc] init];
    [Parameters_For_Client_ID addObject:Client_ID_Title];
    [Parameters_For_Client_ID addObject:Client_ID_Value];
    [Parameters addObject:Parameters_For_Client_ID];
    
    NSString *Grant_Type_Title = @"grant_type";
    NSString *Grant_Type_Value = @"authorization_code";
    NSMutableArray *Parameters_For_Grant_Type =[[NSMutableArray alloc] init];
    [Parameters_For_Grant_Type addObject:Grant_Type_Title];
    [Parameters_For_Grant_Type addObject:Grant_Type_Value];
    [Parameters addObject:Parameters_For_Grant_Type];
    
    NSString *Parameter_Code_Title = @"code";
    NSString *Parameter_Code_Value = Code_Value;
    NSMutableArray *Parameters_For_Parameter_Code =[[NSMutableArray alloc] init];
    [Parameters_For_Parameter_Code addObject:Parameter_Code_Title];
    [Parameters_For_Parameter_Code addObject:Parameter_Code_Value];
    [Parameters addObject:Parameters_For_Parameter_Code];
    
    NSString *Redirect_URI_Title = @"redirect_uri";
    NSString *Redirect_URI_Value = @"https://healthng.oucare.com";
    NSMutableArray *Parameters_For_Redirect_URI =[[NSMutableArray alloc] init];
    [Parameters_For_Redirect_URI addObject:Redirect_URI_Title];
    [Parameters_For_Redirect_URI addObject:Redirect_URI_Value];
    [Parameters addObject:Parameters_For_Redirect_URI];
    
    NSString *Code_Verifier_Method_Title = @"code_verifier";
    NSString *Code_Verifier_Method_Value = @"ThisIsntRandomButItNeedsToBe43CharactersLong";
    NSMutableArray *Parameters_For_Code_Verifier_Method =[[NSMutableArray alloc] init];
    [Parameters_For_Code_Verifier_Method addObject:Code_Verifier_Method_Title];
    [Parameters_For_Code_Verifier_Method addObject:Code_Verifier_Method_Value];
    [Parameters addObject:Parameters_For_Code_Verifier_Method];
    
    NSLog(@"parametersForCode = %@", Parameters);
    NSLog(@"TestParameters = %@", [[Parameters objectAtIndex:0] objectAtIndex:0]);
    return Parameters;
}

// 更新手機狀態
- (NSString *) refreshPhoneInformationURLWithParameters : (NSString *) Client_ID {
    NSString *Origin_URL = [[NSString alloc] initWithFormat:@"%@%@%@", @"https://healthng.oucare.com/api/v1/ouhub/clients/", Client_ID, @"/status"];
    return Origin_URL;
}

// 機構裝置列表及過濾 過濾用法，用來搜尋特定型號序號
// Log In 的 parameters
- (NSMutableArray *) getDeviceUUIDThroughModelAndSerialBodyParameters : (NSString *) model
                     serial                                           : (NSString *) Serial{
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    NSString *User_Name_Title = @"filter[model]";
    NSString *Uesr_Name_Value = model;
    NSMutableArray *Parameters_For_Uesr_Name =[[NSMutableArray alloc] init];
    [Parameters_For_Uesr_Name addObject:User_Name_Title];
    [Parameters_For_Uesr_Name addObject:Uesr_Name_Value];
    [Parameters addObject:Parameters_For_Uesr_Name];
    
    NSString *Password_Title = @"filter[serial]";
    NSString *Password_Value = Serial;
    NSMutableArray *Parameters_For_Password =[[NSMutableArray alloc] init];
    [Parameters_For_Password addObject:Password_Title];
    [Parameters_For_Password addObject:Password_Value];
    [Parameters addObject:Parameters_For_Password];
    return Parameters;
}

// Log In URL 的 Parameters
- (NSString *) getDeviceUUIDThroughModelAndSerialURLWithParameters : (NSString *) Orgunits_String
                                                             model : (NSString *) Model
                                                            serial : (NSString *) Serial {
    NSString *URL_With_Parameters = @"";
    NSString *Origin_URL = @"https://healthng.oucare.com/api/v1/orgunits";
    NSString *Parameters_Syntax = @"?";
    NSString *Orgunits_Parameters = [[NSString alloc] initWithFormat:@"%@%@%@", @"/", Orgunits_String, @"/devices"];
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    Parameters = [self getDeviceUUIDThroughModelAndSerialBodyParameters:Model
                                                                 serial:Serial];
    
    NSString *Parameters_String;
    // get string contains all parameters
    Parameters_String = [self Parameters_Merge:Parameters];
    NSLog(@"Parameters_String = %@", Parameters_String);
    // get string url with all parameters
    URL_With_Parameters = [NSString stringWithFormat:@"%@%@%@%@", Origin_URL, Orgunits_Parameters, Parameters_Syntax, Parameters_String];
    NSLog(@"URL_With_Parameters = %@", URL_With_Parameters);
    
    return URL_With_Parameters;
}
#pragma mark -- Methods

- (NSString *) Parameters_Merge : (NSMutableArray *) Parameters {
    NSUInteger Parameters_Number = [Parameters count];
    NSString *Parameters_String = @"";
    NSString *Parameters_And = @"&";
    NSString *Parameters_Is = @"=";
    for(NSUInteger i = 0; i < Parameters_Number; i++) {
        NSString *Title = [[Parameters objectAtIndex:i] objectAtIndex:0];
        NSString *Value = [[Parameters objectAtIndex:i] objectAtIndex:1];
        if (i == 0) Parameters_String = [NSString stringWithFormat:@"%@%@%@%@", Parameters_String, Title, Parameters_Is, Value];
        else Parameters_String = [NSString stringWithFormat:@"%@%@%@%@%@", Parameters_String, Parameters_And, Title, Parameters_Is, Value];
    }
    NSLog(@"Parameters_String = %@", Parameters_String);
    return Parameters_String;
}
@end
