//
//  SYEditorDetailController.m
//  zhihuDaily
//
//  Created by yang on 16/2/28.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYEditorDetailController.h"
#import "SYZhihuTool.h"

@interface SYEditorDetailController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, copy) NSString *url;
@end

@implementation SYEditorDetailController


#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view bringSubviewToFront:self.indicatorView];
    
    NSString *url = nil;
    
    if ([self.editor isKindOfClass:[SYEditor class]]) {
        SYEditor *editor = self.editor;
        self.title = [self.editor name];
        url = [SYZhihuTool getEditorHomePageWithEditor:editor];
    } else {
        SYRecommender *rec = self.editor;
        self.title = [[self.editor name] stringByAppendingString:@"--知乎"];
        url = [SYZhihuTool getRecommenderHomePageWithRecommender:rec];
    }

    self.url = url;
    
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.indicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    if ([request.URL.absoluteString hasPrefix:@"http://news-at.zhihu.com/api/4/editor/"] || [request.URL.absoluteString hasPrefix:@"http://www.zhihu.com/people/"]) {
        return YES;
    }

    [[UIApplication sharedApplication] openURL:request.URL];
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
