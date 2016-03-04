//
//  SYMainViewCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYLeftDrawerCell.h"
#import "SYZhihuTool.h"

@interface SYLeftDrawerCell ()

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation SYLeftDrawerCell


+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *reuse_id = @"main_reuseid";
    SYLeftDrawerCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id];
    if (!cell) {
        cell = [[SYLeftDrawerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse_id];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        bgView.backgroundColor = SYColor(21, 26, 31, 1.0);
        cell.selectedBackgroundView = bgView;
        cell.backgroundColor = SYColor(26, 31, 36, 1.0);
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.accessoryView = cell.addButton;
    }
    return cell;
}


- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        _addButton.bounds = CGRectMake(0, 0, 30, 36);
        [_addButton addTarget:self action:@selector(didClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_addButton setImage:[UIImage imageNamed:@"Menu_Enter"] forState: UIControlStateDisabled];
        
        [_addButton setImage:[UIImage imageNamed:@"Menu_Follow"] forState:UIControlStateNormal];
    }
    return _addButton;
}

- (void)didClicked:(UIButton *)sender {
    [SYZhihuTool collectedWithTheme:self.theme];
    sender.enabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(didClickedLeftDrawerCell:)]) {
        [self.delegate didClickedLeftDrawerCell:self];
    }
    //TODO 这里需要通知leftDrawer做一个添加收藏的刷新动画效果....
}

- (void)setTheme:(SYTheme *)theme {
    _theme = theme;
    self.textLabel.text = theme.name;

    if ([theme.name isEqualToString:@"首页"]) {
        self.addButton.enabled = NO;
    } else {
        self.addButton.enabled = !theme.isCollected;
    }
}

@end
