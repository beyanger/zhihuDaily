//
//  SYWebViewController.m
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYWebViewController.h"

@interface SYWebViewController () <UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, weak) UIActivityIndicatorView *indicator;
@end

@implementation SYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(dismis)];
   
    [self.webView loadRequest:self.request];
}


- (void)dismis {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] init];
        _webView = webView;
        webView.frame = self.view.bounds;
        webView.delegate = self;
        [self.view addSubview:webView];
    }
    return _webView;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aiv];
        _indicator = aiv;
    }
    return _indicator;
}


- (void)setRequest:(NSURLRequest *)request {
    _request = request;
    
}



- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.indicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicator stopAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
