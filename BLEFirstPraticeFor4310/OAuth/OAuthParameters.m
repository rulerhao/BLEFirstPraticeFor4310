//
//  OAuthParameters.m
//  MQTTTest
//
//  Created by louie on 2020/12/2.
//

#import "OAuthParameters.h"

@interface OAuthParameters ()

@end

@implementation OAuthParameters

/**
 * 例如 Parameter[0] 現在變成 Cilent_ID
 * Parameter[0][0] 現在變成 Client_ID_Title
 * Parameter[0][1] 現在變成 Client_ID_Value
 */
- (NSMutableArray *) logInParameters {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"c90ccc18-2fab-11eb-a13f-02420a00080e";
    NSMutableArray *Parameters_For_Client_ID =[[NSMutableArray alloc] init];
    [Parameters_For_Client_ID addObject:Client_ID_Title];
    [Parameters_For_Client_ID addObject:Client_ID_Value];
    [Parameters addObject:Parameters_For_Client_ID];
    
    NSString *Redirect_URL_Title = @"redirect_uri";
    NSString *Redirect_URL_Value = @"oucare://oauth2/callback";
    NSMutableArray *Parameters_For_Redirect_URL =[[NSMutableArray alloc] init];
    [Parameters_For_Redirect_URL addObject:Redirect_URL_Title];
    [Parameters_For_Redirect_URL addObject:Redirect_URL_Value];
    [Parameters addObject:Parameters_For_Redirect_URL];
    
    NSString *Scope_Title = @"scope";
    NSString *Scope_Value = @"connect-ouhub";
    NSMutableArray *Parameters_For_Scope =[[NSMutableArray alloc] init];
    [Parameters_For_Scope addObject:Scope_Title];
    [Parameters_For_Scope addObject:Scope_Value];
    [Parameters addObject:Parameters_For_Scope];
    
    NSString *Response_Mode_Title = @"response_mode";
    NSString *Response_Mode_Value = @"json";
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

- (NSMutableArray *) takeCodeParameter {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"c90ccc18-2fab-11eb-a13f-02420a00080e";
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

- (NSMutableArray *) takeAccessTokenBodyParameters : (NSString *) Code_Value {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"c90ccc18-2fab-11eb-a13f-02420a00080e";
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
- (NSString *) takeAccessTokenURLWithCodeParameters {
    NSString *Origin_URL = @"https://healthng.oucare.com/oauth/token";
    return Origin_URL;
}
// 第四步驟 用RefreshToken取得AccessToken時所需要的參數
- (NSMutableArray *) takeRefreshTokenBodyParameters : (NSString *) Refresh_Token {
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    
    NSString *Client_ID_Title = @"client_id";
    NSString *Client_ID_Value = @"c90ccc18-2fab-11eb-a13f-02420a00080e";
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

- (NSString *) takeBearerTokenBodyParameters {
    NSString *Origin_URL = @"https://healthng.oucare.com/api/v1/ouhub/otp";
    NSString *Device_Type_Title = @"device_type";
    NSString *Device_Type_Value = @"ios";
    NSString *Device_UUID_Ttile = @"device_uuid";
    NSString *Device_UUID_Value = @"11111111-2222-3333-444444444444";
    
    NSString *JSON_Data = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}", Device_Type_Title, Device_Type_Value, Device_UUID_Ttile, Device_UUID_Value];
    NSLog(@"Bearer_URL = %@", JSON_Data);
    return JSON_Data;
}

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
