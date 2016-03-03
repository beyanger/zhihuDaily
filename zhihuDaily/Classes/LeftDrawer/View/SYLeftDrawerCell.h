//
//  SYMainViewCell.h
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYTheme.h"

@class SYLeftDrawerCell;

@protocol SYLeftDrawerCellDelegate <NSObject>

@optional
- (void)didClickedLeftDrawerCell:(SYLeftDrawerCell *)cell;

@end

@interface SYLeftDrawerCell : UITableViewCell
@property (nonatomic, strong) SYTheme *theme;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<SYLeftDrawerCellDelegate> delegate;

@end
