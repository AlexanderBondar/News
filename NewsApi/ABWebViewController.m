//
//  ABWebViewController.m
//  NewsApi
//
//  Created by Alexandr Bondar on 17.11.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABWebViewController.h"

@interface ABWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backAction:(UIBarButtonItem *)sender;

@end

@implementation ABWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL* url = [NSURL URLWithString:self.article.urlToArticles];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

}

#pragma mark - Action

- (IBAction)backAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
