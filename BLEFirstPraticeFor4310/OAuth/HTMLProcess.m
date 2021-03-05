//
//  HTMLProcess.m
//  MQTTTest
//
//  Created by louie on 2020/12/8.
//

#import "HTMLProcess.h"

@interface HTMLProcess ()

@end

@implementation HTMLProcess

- (void)viewDidLoad {
    [super viewDidLoad];
}

// 取得HTML所以字串
- (nullable NSString *)
getHTMLString   : (id)                  OAuth2Main
webView         : (WKWebView *)         WebView {
    __block NSString *Return_HTML_String = nil;
    
    [WebView evaluateJavaScript:@"document.documentElement.outerHTML"
              completionHandler:^(id result, NSError *error) {
        NSLog(@"Evaluateerror = %@", error);
        NSLog(@"Evaluateresult = %@", result);
        if (error == nil) {
            if (result != nil) {
                Return_HTML_String = [NSString stringWithFormat:@"%@", result];
                NSLog(@"Return_HTML_String = %@", Return_HTML_String);
                NSMutableArray *Information = [[NSMutableArray alloc] init];
                [Information addObject: Return_HTML_String];
                [Information addObject: WebView];
                NSDictionary *HTML_String_Dict = [NSDictionary dictionaryWithObject:Information
                                                                             forKey:[[WebView URL] path]];
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"NotificationName" //Notification以一個字串(Name)下去辨別
                    object:OAuth2Main
                    userInfo:HTML_String_Dict];
            }
        } else {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
    }];
    return Return_HTML_String;
}

- (NSString *) htmlStringToJSONFormatString : (NSString *) HTML_String {
    NSRange JSON_Range;
    NSRange Left_Quote_Range = [HTML_String rangeOfString:@"{"];
    NSRange Right_Quote_Range = [HTML_String rangeOfString:@"}"];
    JSON_Range = NSMakeRange(Left_Quote_Range.location, Right_Quote_Range.location - Left_Quote_Range.location + 1);
    NSString *HTTP_String_JSON = [HTML_String substringWithRange:JSON_Range];
    
    return HTTP_String_JSON;
}

- (NSDictionary *) htmlStringToJsonDictionary : (NSString *) HTML_String {
    NSString *HTML_Pre_String = @"<html><head></head><body><pre style=\"word-wrap: break-word; white-space: pre-wrap;\">";
    NSString *HTML_Post_String = @"</pre></body></html>";
    NSInteger Left_Side_Position = [HTML_String rangeOfString:HTML_Pre_String].location + HTML_Pre_String.length;
    NSInteger Right_Side_Position = [HTML_String rangeOfString:HTML_Post_String].location - 1;
    NSString *Device_Information_Json_String = [HTML_String substringWithRange:NSMakeRange(Left_Side_Position, Right_Side_Position - Left_Side_Position + 1)];
    NSLog(@"get htmlStringToJsonDictionary = %@", Device_Information_Json_String);
    JSONProcess *Json_Process = [JSONProcess alloc];
    NSDictionary *Device_Information_Json = [Json_Process NSStringToJSONDict:Device_Information_Json_String];
    
    return Device_Information_Json;
}
@end
