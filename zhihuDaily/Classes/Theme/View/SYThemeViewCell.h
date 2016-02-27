//
//  SYChannelViewCell.h
//  zhihuDaily
//
//  Created by yang on 16/2/22.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYStory.h"

@interface  SYThemeViewCell: UITableViewCell


- (instancetype)cellWithTableView:(UITableView *)tableView story:(SYStory *)story;

@end
