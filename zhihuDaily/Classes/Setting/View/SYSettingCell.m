//
//  SYSettingCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYSettingCell.h"
#import "SYSettingArrow.h"
#import "SYSettingSwitch.h"
#import "SYSettingText.h"
#import "SYCacheTool.h"

@interface SYSettingCell ()
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *labelView;
@property (nonatomic, strong) UIImageView *arrowView;
@end

@implementation SYSettingCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *reuse_id = @"setting_reuseid";
    SYSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id];
    
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse_id];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(4, 4, 32, 32)].CGPath;
        cell.imageView.layer.mask = layer;
    }
    return cell;
}


- (void)setItem:(SYSettingItem *)item {
    _item = item;
    self.textLabel.text = item.title;
    [self setupRightView];
    
}

- (void)setupRightView {
    if ([self.item isKindOfClass:[SYSettingArrow class]]) {
        self.accessoryView = self.arrowView;
    } else if ([self.item isKindOfClass:[SYSettingSwitch class]]){
        self.accessoryView = self.switchView;
    } else if ([self.item isKindOfClass:[SYSettingText class]]) {
        self.accessoryView = self.labelView;
        SYSettingText *item = (SYSettingText *)self.item;
        self.labelView.text = item.text;
    }
}


- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_icon_arrow"]];
    }
    return _arrowView;
}


- (UISwitch *)switchView {
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = kGroundColor;
        _switchView.on = [kUserDefaults boolForKey:self.item.title];
        [_switchView addTarget:self action:@selector(clickedSwitch:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}


- (void)clickedSwitch:(UISwitch *)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:sender.isOn forKey:self.item.title];
}

- (UILabel *)labelView {
    if (_labelView == nil) {
        _labelView = [[UILabel alloc] init];
        _labelView.font = [UIFont systemFontOfSize:14.];
        _labelView.textColor = [UIColor blackColor];
        _labelView.textAlignment = NSTextAlignmentRight;
        _labelView.frame = CGRectMake(0, 0, 80, 16);

    }
    return _labelView;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
