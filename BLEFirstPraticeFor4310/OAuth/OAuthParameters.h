//
//  OAuthParameters.h
//  MQTTTest
//
//  Created by louie on 2020/12/2.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OAuthParameters : UIViewController
- (NSMutableArray *) logInParameters;
- (NSMutableArray *) logInBodyParameters;
- (NSString *) logInURLWithParameters;

- (NSMutableArray *) takeCodeParameter;
- (NSString *) takeCodeURLWithParameters;

- (NSMutableArray *) takeAccessTokenBodyParameters : (NSString *) Code_Value;
- (NSString *) takeAccessTokenURLWithCodeParameters;

- (NSMutableArray *) takeRefreshTokenBodyParameters : (NSString *) Refresh_Token;
- (NSString *) takeRefreshTokenURLWithCodeParameters;

- (NSString *) takeBearerTokenURLWithCodeParameters;
- (NSString *) takeBearerTokenBodyParameters;

- (NSString *) Parameters_Merge : (NSMutableArray *) Parameters;
@end

NS_ASSUME_NONNULL_END
