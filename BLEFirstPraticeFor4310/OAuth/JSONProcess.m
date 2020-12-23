//
//  OAuth2ForOuhealth.m
//  MQTTTest
//
//  Created by louie on 2020/12/8.
//

#import "JSONProcess.h"

@interface JSONProcess ()

@end

@implementation JSONProcess

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSString *) getAccessTokenThroughHTML : (NSString *) string_For_Search {
    NSLog(@"string_For_Search = %@", string_For_Search);
    NSString *Remain_String = string_For_Search;
    NSRange Remain_String_Range;
    NSRange Token_Title_Range = [Remain_String rangeOfString:@"\"access_token\""];
    Remain_String = [Remain_String substringFromIndex:Token_Title_Range.location + Token_Title_Range.length];
    NSRange Token_Left_Quote_Range = [Remain_String rangeOfString:@"\""];
    Remain_String = [Remain_String substringFromIndex:Token_Left_Quote_Range.location + Token_Left_Quote_Range.length];
    NSRange Token_Right_Quote_Range = [Remain_String rangeOfString:@"\""];
    NSRange Token_Range = NSMakeRange(0, Token_Right_Quote_Range.location);
    NSString *Token = [Remain_String substringWithRange:Token_Range];
    NSLog(@"AccessTokenABC = %@", Token);
    return Token;
}

- (NSString *) getRefresgTokenThroughHTML : (NSString *) string_For_Search {
    NSLog(@"string_For_Search = %@", string_For_Search);

    NSString *Remain_String = string_For_Search;
    NSRange Remain_String_Range;
    NSRange Token_Title_Range = [Remain_String rangeOfString:@"\"refresh_token\""];
    Remain_String = [Remain_String substringFromIndex:Token_Title_Range.location + Token_Title_Range.length];
    NSRange Token_Left_Quote_Range = [Remain_String rangeOfString:@"\""];
    Remain_String = [Remain_String substringFromIndex:Token_Left_Quote_Range.location + Token_Left_Quote_Range.length];
    NSRange Token_Right_Quote_Range = [Remain_String rangeOfString:@"\""];
    NSRange Token_Range = NSMakeRange(0, Token_Right_Quote_Range.location);
    NSString *Token = [Remain_String substringWithRange:Token_Range];
    NSLog(@"RefreshTokenABC = %@", Token);
    return Token;
}

- (NSDictionary *) NSStringToJSONDict : (NSString *) JSON_String {
    NSData *JsonData = [JSON_String dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    id JsonObject = [NSJSONSerialization JSONObjectWithData:JsonData options:0 error:&error];
    
    NSDictionary *jsonDictionary = (NSDictionary *)JsonObject;
    
    return jsonDictionary;
}
@end
