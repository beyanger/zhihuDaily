//
//  SYEditorCell.h
//  zhihuDaily
//
//  Created by yang on 16/2/28.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SYEditor.h"
#import "SYRecommender.h"

@interface SYEditorCell : UITableViewCell

@property (nonatomic, strong) id editor;

+ (instancetype)editorCellWithTableView:(UITableView *)tableView;

+ (instancetype)recommenderCellWithTableView:(UITableView *)tableView;


@end
