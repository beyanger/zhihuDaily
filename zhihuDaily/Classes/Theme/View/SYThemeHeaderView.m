//
//  SYThemeHeaderView.m
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYThemeHeaderView.h"
#import "UIView+Extension.h"
#import "SYRefreshView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface SYThemeHeaderView ()

@property (nonatomic, weak)  UIImageView *backgroundImageView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) SYRefreshView *refreshView;

@property (nonatomic, weak) UIScrollView *scrollView;
@end


@implementation SYThemeHeaderView

- (instancetype)initWithAttachScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        UIImageView *back = [[UIImageView alloc] init];
        self.backgroundImageView = back;
        [self addSubview:back];
        
        
        UILabel *label = [[UILabel alloc] init];
        self.titleLabel = label;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = randomColor;
        [self addSubview:label];
        
        
        SYRefreshView *refresh = [SYRefreshView refreshViewWithScrollView:scrollView];
        self.refreshView = refresh;
        [self addSubview:refresh];
        
        self.scrollView = scrollView;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundImageView.frame = self.bounds;
    self.titleLabel.center = CGPointMake(self.width*0.5, self.height*0.5+10);
    self.refreshView.center = CGPointMake(self.titleLabel.x-20, self.titleLabel.centerY);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
   
}

- (void)setThemeItem:(SYThemeItem *)themeItem {
    _themeItem = themeItem;
    NSLog(@"--> %@", [NSThread currentThread]);
    self.titleLabel.text = themeItem.name;
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:themeItem.image]];
    [self.titleLabel sizeToFit];
}



@end
