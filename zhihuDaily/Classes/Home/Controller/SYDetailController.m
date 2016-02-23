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
#import "SYStoryNavigationView.h"
#import "SYShareView.h"
#import "SYCommentsTableController.h"

@interface SYDetailController () <UIWebViewDelegate, SYStoryNavigationViewDelegate>


@property (nonatomic, weak) SYTopView   *topView;
@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, weak) UIView *footer;


@property (nonatomic, weak) SYStoryNavigationView *storyNav;

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
    

    SYStoryNavigationView *storyNav = [[[NSBundle mainBundle] loadNibNamed:@"SYStoryNavigationView" owner:self options:nil] firstObject];
    self.storyNav = storyNav;
    storyNav.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
    [self.view addSubview:storyNav];
    storyNav.delegate = self;
    

    

}
- (void)storyNavigationView:(SYStoryNavigationView *)navView didClicked:(NSInteger)index {
    switch (index) {
        case 0: // dismis
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case 1: // next
            if ([self.delegate respondsToSelector:@selector(nextStoryForDetailController:)]) {
                self.story = [self.delegate nextStoryForDetailController:self];
                
            }
            
            break;
        case 2: // like
            
            break;
        case 3: { // share {
            SYShareView *shareView = [[SYShareView alloc] init];
            [shareView show];
        }
            break;
        
        case 4: {// comment
            SYCommentsTableController *ctc = [[SYCommentsTableController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctc];
            ctc.story = self.story;
            [self presentViewController:nav animated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)dealloc {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
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
        _webView.backgroundColor = [UIColor whiteColor];
        [self.webView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return _webView;
}



#pragma mark webView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *absoString = request.URL.absoluteString;
    if ([absoString hasPrefix:@"http"]) {

        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *nav = [sb instantiateViewControllerWithIdentifier:@"webViewNavi"];
        
        SYWebViewController *wvc = nav.childViewControllers.firstObject;
        wvc.request = request;
        
        
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
        
    } else if ([absoString hasPrefix:@"detailimage:"]) {
        NSString *url = [absoString stringByReplacingOccurrencesOfString:@"detailimage:"
                                       withString:@""];
        [SYImageView imageWithURLString:url];
        return NO;
        
        
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //调整字号
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages = @"function getImages(){"\
    "var objs = document.getElementsByTagName(\"img\");"\
    "for(var i=0;i<objs.length;i++){"\
    "objs[i].onclick=function(){"\
    "document.location=\"detailimage:\"+this.src;"\
    "};};return objs.length;};";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];    [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    
    
    NSLog(@"%@", NSStringFromCGSize(self.webView.scrollView.contentSize));
    
    self.footer.frame = CGRectMake(kScreenWidth*0.5-40, self.webView.scrollView.contentSize.height, 80, 30);
}



- (UIView *)footer {
    if (!_footer) {
        UIView *footer = [[UIView alloc] init];
        footer.backgroundColor = [UIColor redColor];
        [self.webView.scrollView addSubview:footer];
        _footer = footer;
    }
    return _footer;
}



- (void)setStory:(SYStory *)story {
    _story = story;
    
    if (!story) return;
    
    [SYStoryTool getDetailWithId:self.story.id completed:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SYDetailStory *ds = (SYDetailStory *)obj;
            [self.webView loadHTMLString:ds.htmlStr baseURL:nil];
            self.topView.title.text = ds.title;
            [self.topView.image sd_setImageWithURL:[NSURL URLWithString:ds.image]];
            self.topView.author.text = ds.image_source;
        });
    }];
    
    // 设置 extraStory
    [SYStoryTool getExtraWithId:self.story.id completed:^(id obj) {
        SYExtraStory *es = (SYExtraStory *)obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.storyNav.extraStory = es;
        });
    }];
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
