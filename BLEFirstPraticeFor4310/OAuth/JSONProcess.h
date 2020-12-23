//
//  OAuth2ForOuhealth.h
//  MQTTTest
//
//  Created by louie on 2020/12/8.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSONProcess : UIViewController

- (NSString *) getAccessTokenThroughHTML : (NSString *) string_For_Search;
- (NSString *) getRefresgTokenThroughHTML : (NSString *) string_For_Search;
- (NSDictionary *) NSStringToJSONDict : (NSString *) JSON_String;
    
@end

NS_ASSUME_NONNULL_END
