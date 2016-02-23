//
//  JSInjectionViewController.m
//  WKWebViewDemo
//
//  Created by 益达 on 16/1/26.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "JSInjectionViewController.h"
#import <WebKit/WebKit.h>

@interface JSInjectionViewController ()<WKScriptMessageHandler>

@property (strong, nonatomic) WKWebView *wkWebView;

@end

@implementation JSInjectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self javascriptInjection];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - wk script message handler 
- (void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"message: %@ " , message.body);
}

#pragma mark -  简单的JS脚本注入回调
- (void) javascriptInjection{
    
    // WKWebView的配置
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"jsCall"];
    
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    [self.view addSubview:_wkWebView];
}


@end
