//
//  SYPicturesView.m
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYPicturesView.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "UIView+Extension.h"
#import "SYTopImageView.h"


@interface SYPicturesView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *allImages;
@property (nonatomic, weak) UIScrollView *scrollerView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SYPicturesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        UIScrollView *scrollerView = [[UIScrollView alloc] init];
        [self addSubview:scrollerView];
        scrollerView.pagingEnabled = YES;
        scrollerView.bounces = NO;
        scrollerView.delegate = self;
        scrollerView.showsHorizontalScrollIndicator = NO;
        self.scrollerView = scrollerView;
        [scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(ws);
        }];
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 16));
            make.centerX.mas_equalTo(ws);
            make.bottom.mas_equalTo(ws).offset(-14);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClicked)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //[[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    [self.timer invalidate];
}

- (void)didClicked {
    if ([self.delegate respondsToSelector:@selector(pictureView:clickedIndex:)]) {
        [self.delegate pictureView:self clickedIndex:self.pageControl.currentPage];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat xoffset = scrollView.contentOffset.x;
    int currentPage  = (int)(xoffset / kScreenWidth + 0.5);
    self.pageControl.currentPage = currentPage;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat x = self.pageControl.currentPage*kScreenWidth;
    [self.scrollerView setContentOffset:CGPointMake(x, 0) animated:YES];
    [self addTimer];
}



- (void)nextImage {
    NSInteger page = (self.pageControl.currentPage+1)%self.pageControl.numberOfPages;
    
    CGFloat x = page *kScreenWidth;
    [self.scrollerView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)setTopStroies:(NSArray<SYStory *> *)topStroies {
    _topStroies = topStroies;
    for (SYTopImageView *topImage in self.allImages) {
        [topImage removeFromSuperview];
    }
    [self.allImages removeAllObjects];
    
    self.pageControl.numberOfPages = topStroies.count;
    
    for (NSUInteger i = 0; i < topStroies.count; i++) {
        SYStory *story = topStroies[i];
        SYTopImageView *imageView = [SYTopImageView topImageView];
        imageView.story = story;
        [self.allImages addObject:imageView];
        [self.scrollerView addSubview:imageView];
    }
 
    !self.timer? : [self removeTimer];
    
    [self addTimer];
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollerView.contentSize = CGSizeMake(kScreenWidth*self.allImages.count, self.height);
    for (NSUInteger i = 0; i < self.allImages.count; i++) {
        UIImageView *imageVew = self.allImages[i];
        imageVew.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.height);
    }
}



- (NSMutableArray *)allImages {
    if (!_allImages) {
        _allImages = [@[] mutableCopy];
    }
    return _allImages;
}

@end
