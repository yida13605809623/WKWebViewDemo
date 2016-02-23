//
//  PluginsViewController.m
//  WKWebViewDemo
//
//  Created by 益达 on 16/1/27.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "PluginsViewController.h"
#import <WebKit/WebKit.h>

@interface PluginsViewController ()<WKScriptMessageHandler>
@property (strong, nonatomic) WKWebView *wkWebView;
@end

@implementation PluginsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // WKWebView的配置
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    [configuration.userContentController addScriptMessageHandler:self name:@"jsCall"];
    
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    [self.view addSubview:_wkWebView];
    
    NSString *console = @"console";
    [self runPluginJS:@[console]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WKScriptMessageHandler
- (void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if([message.name isEqualToString:@"jsCall"]) {
        NSDictionary *classInfo = (NSDictionary *)message.body;
        
        NSString *className = classInfo[@"className"];
        NSString *classSelector = classInfo[@"classSelector"];
        NSDictionary *classParams = classInfo[@"classParams"];//根据参数来区分执行的方法
        
        if(className.length == 0 || classSelector.length == 0) {
            return;
        }
        
        Class newClass  = NSClassFromString(className);
        NSObject *object = nil;
        if(newClass) {
            object = [[newClass alloc] init];
        }
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        SEL selector = NSSelectorFromString(classSelector);
        if([object respondsToSelector:selector]) {
            if(classParams.count == 0) {
                [object performSelector:selector withObject:nil];
            } else if(classParams.count > 0) {
                [object performSelector:selector withObject:classParams];
            }
        }
#pragma clang diagnostic pop
        
    }
}


- (void) runPluginJS:(NSArray *) array {
    
    //可以同时添加多个文件
    for(NSString * jsFileName in array) {
        NSString *path = [[NSBundle mainBundle] pathForResource:jsFileName ofType:@"js"];
        NSString *fileContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [self.wkWebView evaluateJavaScript:fileContent completionHandler:^(id response , NSError * error) {
            
        }];
    }
}

@end
