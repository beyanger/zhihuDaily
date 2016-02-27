//
//  SYSettingCell.h
//  zhihuDaily
//
//  Created by yang on 16/2/27.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSettingItem.h"

@interface SYSettingCell : UITableViewCell

@property (nonatomic, strong) SYSettingItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
