//
//  OuhealthcareWebView.m
//  BLEFirstPraticeFor4310
//
//  Created by louie on 2020/12/23.
//

#import "OuhealthcareWebViewController.h"

@interface OuhealthcareWebViewController ()
@property (strong, nonatomic) IBOutlet WKWebView *Wk_Web_View;

@end

@implementation OuhealthcareWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.Wk_Web_View = [[WKWebView alloc] init];
    [self setupWebView:self.Wk_Web_View];
    
    // ---------------------- Set URL ----------------------
    NSString *RequestURL = @"https://healthcare.oucare.com";
    NSURL *url = [[NSURL alloc] initWithString: RequestURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    
    // ---------------------- 開始開啟網頁 ----------------------
    [self.Wk_Web_View loadRequest: request];
}

- (void)
setupWebView : (WKWebView *) WKWeb_View {
    [WKWeb_View setUIDelegate:self];
    [WKWeb_View setNavigationDelegate:self];
    [WKWeb_View setAllowsBackForwardNavigationGestures:YES];
}

- (void)
webView             :(WKWebView *)      webView
didFinishNavigation :(WKNavigation *)   navigation {
    
}

-(void)
webView                             : (WKWebView *)                             webView
decidePolicyForNavigationResponse   : (WKNavigationResponse *)                  navigationResponse
decisionHandler                     : (void (^)(WKNavigationResponsePolicy))    decisionHandler {
    navigationResponse.response.URL;
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)
webView:(WKWebView *)webView
didStartProvisionalNavigation:(WKNavigation *)navigation {
}

- (void)
webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
@end
