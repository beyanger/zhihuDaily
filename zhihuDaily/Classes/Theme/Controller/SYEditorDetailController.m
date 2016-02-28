//
//  SYEditorDetailController.m
//  zhihuDaily
//
//  Created by yang on 16/2/28.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYEditorDetailController.h"


@interface SYEditorDetailController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation SYEditorDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view bringSubviewToFront:self.indicatorView];
    self.title = self.editor.name;
    self.webView.delegate = self;
    
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/editor/%d/profile-page/ios", self.editor.id];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.indicatorView startAnimating];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http ://www.baidu.com"]];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSLog(@"--- %@", request.URL.absoluteString);
    
    NSString *url = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/editor/%d/profile-page/ios", self.editor.id];
    
    if ([request.URL.absoluteString isEqualToString:url]) {
        return YES;
    }

    [[UIApplication sharedApplication] openURL:request.URL];
    return NO;
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
