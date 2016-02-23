//
//  SYDetailController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYDetailController.h"
#import "SYStory.h"
#import "YSHttpTool.h"
#import "SYTopView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "SYWebViewController.h"
#import "SYStoryTool.h"
#import "SYDetailStory.h"
#import "SYImageView.h"

@interface SYDetailController () <UIWebViewDelegate>

@property (nonatomic, strong) SYStory *story;

@property (nonatomic, weak) SYTopView   *topView;
@property (nonatomic, weak) UIWebView *webView;
@end

@implementation SYDetailController

- (instancetype)initWithStory:(SYStory *)story
{
    self = [super init];
    if (self) {
        self.story = story;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [SYStoryTool getDetailWithId:self.story.id completed:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SYDetailStory *ds = (SYDetailStory *)obj;
            [self.webView loadHTMLString:ds.htmlStr baseURL:nil];
            self.topView.title.text = ds.title;
            [self.topView.image sd_setImageWithURL:[NSURL URLWithString:ds.image]];
            self.topView.author.text = ds.image_source;
        });
    }];
    

    UIView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"SYBottomView" owner:self options:nil] firstObject];
    bottomView.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    [self.view addSubview:bottomView];
    
    
    
}


- (SYTopView *)topView {
    if (!_topView) {
        _topView = [[[NSBundle mainBundle] loadNibNamed:@"SYTopView" owner:self options:nil] firstObject];
        _topView.clipsToBounds = YES;
        _topView.frame = CGRectMake(0, -40, kScreenWidth, 200+40);
        
        
        _topView.image.contentMode = UIViewContentModeCenter;
        [self.webView.scrollView addSubview:_topView];
    }
    return _topView;
}

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-40);
        [self.view addSubview:webView];
        _webView = webView;
        _webView.delegate = self;
        [self.webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([request.URL.absoluteString hasPrefix:@"http"]) {

        SYWebViewController *wvc = [[SYWebViewController alloc] init];
        wvc.request = request;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wvc];
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat yoffset = [change[@"new"] CGPointValue].y;
        
        if (yoffset < 0) {
            self.topView.frame = CGRectMake(0, yoffset, kScreenWidth, 200-yoffset);
        }
    }
}



@end
