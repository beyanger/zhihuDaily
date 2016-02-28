//
//  SYHomeHeaderView.m
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYHomeHeaderView.h"
#import "UIView+Extension.h"
static NSString *header_reuseid = @"header_reuseid";

@interface SYHomeHeaderView ()

@property (nonatomic, weak) UILabel *dateLabel;

@end


@implementation SYHomeHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    SYHomeHeaderView  *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header_reuseid];
    if (!header) {
        header = [[SYHomeHeaderView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        [header.contentView addSubview:label];
        label.textColor = kWhiteColor;
        [header.contentView addSubview:label];
        label.font = [UIFont boldSystemFontOfSize:18.];
        header.dateLabel = label;
        header.contentView.backgroundColor = SYColor(23, 144, 211, 1.);
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
    
    self.dateLabel.text = _date;
    [self.dateLabel sizeToFit];
//    NSDictionary *attr = @{
//            NSFontAttributeName: [UIFont systemFontOfSize:38.] ,
//            NSForegroundColorAttributeName: [UIColor whiteColor]};
//    
//    self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:_date attributes:attr];


    
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    self.dateLabel.center = self.contentView.center;
}

@end
