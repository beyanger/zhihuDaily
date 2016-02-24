//
//  SYHomeHeaderView.m
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYHomeHeaderView.h"

static NSString *header_reuseid = @"header_reuseid";

@implementation SYHomeHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    SYHomeHeaderView  *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header_reuseid];
    if (!header) {
        header = [[SYHomeHeaderView alloc] init];
        header.contentView.backgroundColor = SYColor(23, 144, 211, 1);
    }
    return header;
}


- (void)setDate:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    dateFormatter.dateFormat = @"yyyyMMdd";
    NSDate *da = [dateFormatter dateFromString:date];
    dateFormatter.dateFormat = @"MM月dd日 EEEE";
    _date = [dateFormatter stringFromDate:da];
    
    NSDictionary *attr = @{
            NSFontAttributeName: [UIFont systemFontOfSize:18] ,
            NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:_date attributes:attr];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = self.textLabel.center;
    center.x = self.center.x;
    self.textLabel.center = center;
}

@end
