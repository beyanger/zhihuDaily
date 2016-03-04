//
//  SYCommentCell.h
//  zhihuDaily
//
//  Created by yang on 16/2/23.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYComment.h"


@class SYCommentCell;

@protocol SYCommentCellDelegate <NSObject>

@optional
- (void)commentCelll:(SYCommentCell *)cell   actionType:(int)type;

@end

@interface SYCommentCell : UITableViewCell

@property (nonatomic, strong) SYComment *comment;


@property (nonatomic, weak) id<SYCommentCellDelegate> delegate;

@end
