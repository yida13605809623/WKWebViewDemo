//
//  Console.m
//  WKWebViewDemo
//
//  Created by 益达 on 16/1/27.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "Console.h"
#import <UIKit/UIKit.h>

@implementation Console

- (void)log:(NSDictionary *)info {
    
    NSLog(@"test:  %@  " , info);
}

- (void) show:(NSDictionary *) info {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:info[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
    
}

@end
