//
//  SYWebViewController.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYWebViewController.h"
#import "SYShareView.h"


@interface SYWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) UIView *cover;
@property (nonatomic, weak) SYShareView  *shareView;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *forward;


@end

@implementation SYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateButton];
   
    self.webView.delegate = self;
    [self.webView loadRequest:self.request];
}




- (IBAction)pop {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)reload {
    [self.webView reload];
}
- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}
- (IBAction)share:(id)sender {
    SYShareView *shareView = [[SYShareView alloc] init];
    [shareView show];
}



- (void)setRequest:(NSURLRequest *)request {
    _request = request;
}



- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.indicator startAnimating];
    [self updateButton];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicator stopAnimating];
    [self updateButton];
    
    
    self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


- (void)updateButton {
    self.back.enabled = self.webView.canGoBack;
    self.forward.enabled = self.webView.canGoForward;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
