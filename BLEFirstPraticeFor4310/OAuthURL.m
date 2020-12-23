//
//  OAuthURL.m
//  MQTTTest
//
//  Created by louie on 2020/12/2.
//

#import "OAuthURL.h"

@interface OAuthURL ()

@end

@implementation OAuthURL

- (NSString *) getLogIn_URL_With_Parameters {
    NSString *URL_With_Parameters = @"";
    NSString *Origin_URL = @"https://healthng.oucare.com/oauth/login";
    NSString *Parameters_Syntax = @"?";
    
    NSMutableArray *Parameters = [[NSMutableArray alloc] init];
    OAuthParameters *oAuthParameters = [OAuthParameters alloc];
    Parameters = [oAuthParameters LoginParameter];
    
    NSString *Parameters_String;
    // get string contains all parameters
    Parameters_String = [oAuthParameters Parameters_Merge:Parameters];
    NSLog(@"Parameters_String = %@", Parameters_String);
    // get string url with all parameters
    URL_With_Parameters = [NSString stringWithFormat:@"%@%@%@", Origin_URL, Parameters_Syntax, Parameters_String];
    NSLog(@"URL_With_Parameters = %@", URL_With_Parameters);
    
    return URL_With_Parameters;
}

@end
