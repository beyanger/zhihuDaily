//
//  SYHomeHeaderView.h
//  zhihuDaily
//
//  Created by yang on 16/2/24.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYHomeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *date;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
