//
//  HTMLProcess.h
//  MQTTTest
//
//  Created by louie on 2020/12/8.
//

#import "ViewController.h"
#import "OAuth2Main.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTMLProcess : UIViewController

// 取得HTML所以字串
- (nullable NSString *)
notifyWhenGetHTMLString   : (id) WebView_Controller
webView         : (WKWebView *)         WebView;

- (NSString *) htmlStringToJSONFormatString : (NSString *) HTML_String;
- (NSDictionary *) htmlStringToJsonDictionary : (NSString *) HTML_String;
@end

NS_ASSUME_NONNULL_END
