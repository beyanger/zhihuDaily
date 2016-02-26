//
//  SYDetailController.m
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYDetailController.h"
#import "SYStory.h"
#import "SYTopView.h"
#import "UIImageView+WebCache.h"
#import "UIView+Extension.h"
#import "SYWebViewController.h"
#import "SYZhihuTool.h"
#import "SYDetailStory.h"
#import "SYImageView.h"
#import "SYStoryNavigationView.h"
#import "SYShareView.h"
#import "SYCommentsTableController.h"
#import "UIView+Extension.h"
#import "Masonry.h"

@interface SYDetailController () <UIWebViewDelegate, SYStoryNavigationViewDelegate, UIScrollViewDelegate>


@property (nonatomic, strong) SYTopView   *topView;
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UILabel *footer;
@property (nonatomic, strong) UILabel *header;

@property (nonatomic, weak) UIImageView *upArrow;
@property (nonatomic, weak) UIImageView *downArrow;

@property (nonatomic, strong) SYStoryNavigationView *storyNav;

@property (nonatomic, assign) BOOL isChanging;


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
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.webView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.header];
    
    [self.webView.scrollView addSubview:self.footer];
    
    self.position = _position;
    

}
- (void)storyNavigationView:(SYStoryNavigationView *)navView didClicked:(NSInteger)index {
    switch (index) {
        case 0: // dismis
            [self.navigationController popViewControllerAnimated:YES];
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
            ctc.story = self.story;
            
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:ctc];
            
            //[self.navigationController pushViewController:ctc animated:ctc];
            
            [self presentViewController:navi animated:YES completion:nil];
            
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
        _topView.layer.anchorPoint = CGPointMake(0.5, 0);
        _topView.clipsToBounds = YES;
        _topView.frame = CGRectMake(0, -40, kScreenWidth, 220+40);
    }
    return _topView;
}

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] init];
        webView.frame = CGRectMake(0, 20, kScreenWidth, kScreenHeight-40-20);
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

        SYWebViewController *nav = [[SYWebViewController alloc] init];
        nav.request = request;
        [self.navigationController pushViewController:nav animated:YES];
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
    

    self.footer.center = CGPointMake(kScreenWidth*0.5, self.webView.scrollView.contentSize.height+25);
    self.header.center = CGPointMake(kScreenWidth*0.5, -40);
    
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -80) {
  
        if ([self.delegate respondsToSelector:@selector(prevStoryForDetailController:)]) {
            SYStory *story  = [self.delegate prevStoryForDetailController:self];
            // 加载上一篇
            if (story) {
                self.isChanging = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    self.topView.transform = CGAffineTransformMakeTranslation( 0, kScreenHeight);
                    self.webView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight);
                } completion:^(BOOL finished) {
                    self.story = story;
                    self.isChanging = NO;
                }];
            }
        }
    
    } else if (scrollView.contentSize.height - scrollView.contentOffset.y-kScreenHeight < -120) {

            if ([self.delegate respondsToSelector:@selector(nextStoryForDetailController:)]) {
                SYStory *story  = [self.delegate nextStoryForDetailController:self];
                
                if (story) {
                    self.isChanging = YES;
                    [UIView animateWithDuration:.3 animations:^{
                        self.webView.transform = CGAffineTransformMakeTranslation(0, -kScreenHeight);
                    } completion:^(BOOL finished) {
                        self.story = story;
                        self.isChanging = NO;
                    }];
                }

            }
    }
}

- (UILabel *)footer {
    if (!_footer) {
        UILabel *footer = [[UILabel alloc] init];
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
        
        header.textColor = [UIColor whiteColor];
        header.textAlignment = NSTextAlignmentCenter;
        header.text = @"载入上一篇";
        header.center = CGPointMake(kScreenWidth*0.5, -40);
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

- (SYStoryNavigationView *)storyNav {
    if (!_storyNav) {
        _storyNav = [[[NSBundle mainBundle] loadNibNamed:@"SYStoryNavigationView" owner:self options:nil] firstObject];
        _storyNav.frame = CGRectMake(0, kScreenHeight-40, kScreenWidth, 40);
        [self.view addSubview:_storyNav];
        _storyNav.delegate = self;
    }
    return _storyNav;
}



- (void)setStory:(SYStory *)story {
    if (!story) return;
    _story = story;
    
    NSLog(@"story id: %lld", story.id);
    
    self.topView.transform = CGAffineTransformIdentity;
    self.webView.transform = CGAffineTransformIdentity;
    
    [SYZhihuTool getDetailWithId:self.story.id completed:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SYDetailStory *ds = (SYDetailStory *)obj;
            [self.webView loadHTMLString:ds.htmlStr baseURL:nil];
            self.topView.story = ds;
        });
    }];
    
    // 设置 extraStory
    [SYZhihuTool getExtraWithId:self.story.id completed:^(id obj) {
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
        
        if (!self.isChanging) {
            if (yoffset < 0) {
                self.topView.transform = CGAffineTransformMakeScale(1, -yoffset/self.topView.height+1);
            } else {
                self.topView.transform = CGAffineTransformMakeTranslation(0, -yoffset);
            }
        }
        
        self.header.transform = CGAffineTransformMakeTranslation(0, -yoffset);
        
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
