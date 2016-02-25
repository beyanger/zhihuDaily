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

@interface SYPicturesView ()

@property (nonatomic, strong) NSMutableArray *allImages;

@end

@implementation SYPicturesView


- (void)setTopStroies:(NSArray<SYStory *> *)topStroies {
    _topStroies = topStroies;
    for (UIImageView *imageView in self.allImages) {
        [imageView removeFromSuperview];
    }
    [self.allImages removeAllObjects];
    
    for (NSUInteger i = 0; i < topStroies.count; i++) {
        SYStory *story = topStroies[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:story.image]];
        [self.allImages addObject:imageView];
        [self addSubview:imageView];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentSize = CGSizeMake(kScreenWidth*self.allImages.count, self.height);
    for (NSUInteger i = 0; i < self.allImages.count; i++) {
        UIImageView *imageVew = self.allImages[i];
        imageVew.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.height);
    }
    
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    

}




- (NSMutableArray *)allImages {
    if (!_allImages) {
        _allImages = [@[] mutableCopy];
    }
    return _allImages;
}



@end
