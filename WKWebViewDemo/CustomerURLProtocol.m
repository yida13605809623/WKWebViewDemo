//
//  CustomerURLProtocol.m
//  WebViewErrorProjectDemo
//
//  Created by 益达 on 16/1/19.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "CustomerURLProtocol.h"
//#import "NSUrlSess"


static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";


@interface CustomerURLProtocol()<NSURLConnectionDelegate>

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSURLSessionDataTask *task;

@end

@implementation CustomerURLProtocol

//抽象类必须要实现的部分
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
    {
        
        //NSLog(@"当前处理的url  %@ " , request.URL.absoluteString);
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
            return NO;
        }
        
        return YES;
    }
    return NO;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}


- (void)startLoading {

    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    
    //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];

    NSLog(@"发送请求的url :  %@ " , [[mutableReqeust URL] absoluteString]);
    //后续可以换个网路层  只要能娶到网络的里面的header的状态码就行了
    
    
    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];

}

- (void) stopLoading {
    
    [self.connection cancel];
}

#pragma mark - connnection delegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response  {
    
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if([httpResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        
        if(httpResponse.statusCode == 302) {
            NSDictionary *message = [[NSDictionary alloc] initWithObjectsAndKeys:connection.originalRequest.URL.absoluteString,@"url",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:Code302Request object:message];
        }
    }
   
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}
@end
