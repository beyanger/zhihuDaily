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
#import "UIView+Extension.h"
#import "Masonry.h"

@interface SYDetailController () <UIWebViewDelegate, SYStoryNavigationViewDelegate, UIScrollViewDelegate>


@property (nonatomic, weak) SYTopView   *topView;
@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, weak) UILabel *footer;
@property (nonatomic, weak) UILabel *header;

@property (nonatomic, weak) UIImageView *upArrow;
@property (nonatomic, weak) UIImageView *downArrow;

@property (nonatomic, weak) SYStoryNavigationView *storyNav;

@end

@implementation SYDetailController

- (instancetype)initWithStory:(SYStory *)story
{
    self = [super init];
    if (self) {

        self.view.backgroundColor = [UIColor whiteColor];
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
    
    self.position = _position;
    

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
        _webView.scrollView.delegate = self;
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
    static  NSString * const jsGetImages = @"function setImages(){"\
    "var images = document.getElementsByTagName(\"img\");"\
    "for(var i=0;i<images.length;i++){"\
    "images[i].onclick=function(){"\
    "document.location=\"detailimage:\"+this.src;"\
    "};};return images.length;};";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];
    [webView stringByEvaluatingJavaScriptFromString:@"setImages()"];
    
    // 获取网页上的所有图片
    NSString *jsImage = @"var images= document.getElementsByTagName('img');"
                        "var imageUrls = \"\";"
                        "for(var i = 0; i < images.length; i++)"
                            "{var image = images[i];"
                            "imageUrls += image.src+\"...beyanger....\";"
                        "}"
                        "imageUrls.toString();";
    
    NSString *imageUrls = [webView stringByEvaluatingJavaScriptFromString:jsImage];
    
    NSArray *imageArray = [imageUrls componentsSeparatedByString:@"...beyanger...."];
#pragma todo 设置图片浏览界面的上一张和下一张功能
    

    self.footer.center = CGPointMake(kScreenWidth*0.5, self.webView.scrollView.contentSize.height+20);
    self.header.center = CGPointMake(kScreenWidth*0.5, -40);
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -80) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(prevStoryForDetailController:)]) {
                SYStory *story  = [self.delegate prevStoryForDetailController:self];
                if (story) {
                    // 切换动画
                    [UIView animateWithDuration:0.2 animations:^{
                        self.webView.y = self.webView.height;
                    } completion:^(BOOL finished) {
                        self.story = story;
                        self.webView.y = -self.webView.height;
                        [UIView animateWithDuration:0.2 animations:^{
                            self.webView.y = 0;
                        }];
                    }];
                }
            }
        });
    } else if (scrollView.contentSize.height - scrollView.contentOffset.y-kScreenHeight < -120) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(nextStoryForDetailController:)]) {
                SYStory *story  = [self.delegate nextStoryForDetailController:self];
                if (story) {
                    // 切换动画
                    [UIView animateWithDuration:0.2 animations:^{
                        self.webView.y = -self.webView.height;
                    } completion:^(BOOL finished) {
                        self.webView.y = self.webView.height;
                        self.story = story;
                        [UIView animateWithDuration:0.2 animations:^{
                            self.webView.y = 0;
                        }];

                    }];
                }
            }
        });
    }
}



- (UILabel *)footer {
    if (!_footer) {
        UILabel *footer = [[UILabel alloc] init];
        [self.webView.scrollView addSubview:footer];
        footer.textColor = [UIColor grayColor];
        footer.textAlignment = NSTextAlignmentCenter;
        footer.text = @"载入下一篇";
        [footer sizeToFit];
        _footer = footer;
    
        UIImage *image = [UIImage imageNamed:@"upArrow"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [footer addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 20));
            make.centerY.mas_equalTo(footer);
            make.right.mas_equalTo(footer.mas_left).offset(-10);
        }];
        _upArrow = imageView;
    }
    return _footer;
}

- (UILabel *)header {
    if (!_header) {
        UILabel *header = [[UILabel alloc] init];
        [self.webView.scrollView insertSubview:header aboveSubview:self.topView];
        header.textColor = [UIColor whiteColor];
        header.textAlignment = NSTextAlignmentCenter;
        _header = header;
        
        UIImage *image = [UIImage imageNamed:@"downArrow"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [header addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 20));
            make.centerY.mas_equalTo(header);
            make.right.mas_equalTo(header.mas_left).offset(-10);
        }];
        _downArrow = imageView;
    }
    return _header;
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


- (void)setPosition:(long)position {
    _position = position;
    if (position == 0) {
        self.header.text = @"已经是第一篇";
        self.downArrow.alpha = 0.0;
    } else {
        self.header.text = @"载入上一篇";
        self.downArrow.alpha = 1.0;
    }
    [self.header sizeToFit];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat yoffset = [change[@"new"] CGPointValue].y;
        if (yoffset < 0) {
            self.topView.frame = CGRectMake(0, yoffset, kScreenWidth, 200-yoffset);
        }

        CGAffineTransform transform = CGAffineTransformIdentity;
        if (yoffset < -80) {
            transform = CGAffineTransformMakeRotation(M_PI);
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.downArrow.transform = transform;
        }];
        
        transform = CGAffineTransformIdentity;
        if (self.webView.scrollView.contentSize.height - self.webView.scrollView.contentOffset.y-kScreenHeight < -120) {
            transform = CGAffineTransformMakeRotation(M_PI);
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.upArrow.transform = transform;
        }];
        
    }
}




@end
