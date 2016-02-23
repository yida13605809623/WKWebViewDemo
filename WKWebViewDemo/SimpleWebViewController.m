//
//  SimpleWebViewController.m
//  WKWebViewDemo
//
//  Created by 益达 on 16/1/25.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "SimpleWebViewController.h"
#import <WebKit/WebKit.h>


#define  Test 2

@interface SimpleWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *wkWebView;
@end

@implementation SimpleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view.
    
    if(Test == 1) {
        [self testWKWebviewInjectionUA];
    } else if(Test == 2) {
        [self javascriptInjection];
    } else {
        [self openSimpleLink];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) rightButtonClick:(UIButton *) button {
    
    
    [_wkWebView evaluateJavaScript:@"share()" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
       
        NSLog(@"全局的内容显: %@ " , result);
        
    }];
}


#pragma mark -  WKNavigationDelegate 
- (void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s  %@ " , __FUNCTION__ , navigation);
}

- (void) webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"%s  %@ " , __FUNCTION__ , navigation);
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"%s  %@ " , __FUNCTION__ , navigation);
    
    [webView evaluateJavaScript:@"window.isReadyForYouZanJSBridge=\'2.0.0\'" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result  %@ " , result);
    }];
}

- (void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s  %@ " , __FUNCTION__ ,navigation);
}

//接收到服务器的跳转请求之后调用
- (void) webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"%s  %@ " , __FUNCTION__ , navigation);
}


//在发送请求之前，决定是否跳转
- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlString = [navigationAction.request.URL absoluteString];
    NSRange rangle = [urlString rangeOfString:@"redirect_uri"];
    if(rangle.location != NSNotFound) {
        decisionHandler(WKNavigationActionPolicyCancel);//如果cancle，整个页面不会被加载
        return;
    }
    //测试
    if([[navigationAction.request.URL host] isEqualToString:@"wap.koudaitong.com"] || [[navigationAction.request.URL host] isEqualToString:@"wap.youzan.com"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

//收到响应时，决定是否跳转
- (void) webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    //不需要响应的链接
    NSString *urlString = [navigationResponse.response.URL absoluteString];
    NSRange rangle = [urlString rangeOfString:@"redirect_uri"];
    if(rangle.location != NSNotFound) {
        decisionHandler(WKNavigationResponsePolicyCancel);//如果cancle，整个页面不会被加载
        return;
    }

    //测试
    if([[navigationResponse.response.URL host] isEqualToString:@"wap.koudaitong.com"] || [[navigationResponse.response.URL host] isEqualToString:@"wap.youzan.com"]) {
        decisionHandler(WKNavigationResponsePolicyAllow);
        return;
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - wkUIDelegate  
/**
 *  创建一个新的wkwebview
 *
 *
 *  @return
 */
//- (WKWebView *) webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//    
//    return nil;
//}

- (void)webViewDidClose:(WKWebView *)webView {
}

/**
 *  弹出对应的alertView
 *
 *  @param webView           <#webView description#>
 *  @param message           暂时只能接收到message信息
 *  @param frame             <#frame description#>
 *  @param completionHandler <#completionHandler description#>
 *  通常的alertViews的事件   alert(message,[title,callback])
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    completionHandler();
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    
    completionHandler(YES);
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    completionHandler(@"yida");
    
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    NSLog(@"message  %@ " , message.body);
}

#pragma mark -  UA  test
- (void) testWKWebviewInjectionUA {
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.wkWebView];
    __weak typeof(self) weakSelf = self;
    
    
    
    [self.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *userAgent = result;
        NSString *newUserAgent = [userAgent stringByAppendingString:@" kdtUnion_demo"];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent,@"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
        
        strongSelf.wkWebView = [[WKWebView alloc] initWithFrame:strongSelf.view.bounds];
        
        [strongSelf.wkWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"测试结果：  %@ " , response);
        }];
        
//        [self openYouzanLink];
    }];
}

- (void) openYouzanLink {
    
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://wap.koudaitong.com/v2/showcase/homepage?kdt_id=618192&reft=1446789192046&spm=f3456438"]]];
    
}


#pragma mark -  简单的JS脚本注入回调
- (void) javascriptInjection{
    
     //我们常见的几个时间
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick:)];
    
     NSString *alertJS = @"window.alert('yida');";//confrim   prompt  这些都可以尝试下
    
//    NSString *confirmJS = @"window.confirm('message');";
//    NSString *promptJS = @"var sign = window.prompt('message'); if(sign == 'yida'){window.alert('yida');}";
    
    
    NSString *injectionJS = @"function yidatest(){window.webkit.messageHandlers.jsCall.postMessage('yida');}";
    
     // 根据JS字符串初始化WKUserScript对象
     WKUserScript *script = [[WKUserScript alloc] initWithSource:alertJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
     
     // WKWebView的配置
     WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
     [configuration.userContentController addUserScript:script];
     [configuration.userContentController addScriptMessageHandler:self name:@"jsCall"];
    
     _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
     _wkWebView.UIDelegate = self;
     _wkWebView.navigationDelegate = self;
     
     NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
     [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
     [self.view addSubview:_wkWebView];
}

#pragma mark - open simple link 
- (void) openSimpleLink {
    
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];
    
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://wap.koudaitong.com/v2/showcase/homepage?kdt_id=618192&reft=1446789192046&spm=f3456438"]]];
}

@end
