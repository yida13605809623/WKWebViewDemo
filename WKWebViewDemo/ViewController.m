//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by 益达 on 16/1/25.
//  Copyright © 2016年 张伟. All rights reserved.
//

#import "ViewController.h"
#import "SimpleWebViewController.h"
#import "JSInjectionViewController.h"
#import "PluginsViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *simpleWebButton;
@property (weak, nonatomic) IBOutlet UIButton *jsInjectionButton;
@property (weak, nonatomic) IBOutlet UIButton *pluginsButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSLog(@"title is   %@ ", NSLocalizedString(@"title", nil));
    
    
    NSLocale 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)simpleWebButtonClick:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SimpleWebViewController *simpleVC = [board instantiateViewControllerWithIdentifier:@"simplewebvc"];
    [self.navigationController pushViewController:simpleVC animated:YES];
    
}

- (IBAction)jsInjectionButtonClick:(id)sender {
 
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JSInjectionViewController *jsInjectionVC = [board instantiateViewControllerWithIdentifier:@"jsinjectionvc"];
    [self.navigationController pushViewController:jsInjectionVC animated:YES];
}

- (IBAction)pluginsButtonClick:(id)sender {
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PluginsViewController *pluginsVC = [board instantiateViewControllerWithIdentifier:@"pluginsvc"];
    [self.navigationController pushViewController:pluginsVC animated:YES];
    
}

@end
