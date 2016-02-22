//
//  SYMainToolBox.h
//  zhihuDaily
//
//  Created by yang on 16/2/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYMainToolBox;

@protocol SYMainToolBoxDelegate <NSObject>

- (void)toolBox:(SYMainToolBox *)toolBox didClickedTitle:(NSString *)title;

@end


@interface SYMainToolBox : UIView

@property (nonatomic, weak) id<UITableViewDataSource> dataSource;
@property (nonatomic, weak) id<UITableViewDelegate> delegate;
@property (nonatomic, weak) id<SYMainToolBoxDelegate> toolBoxDelegate;

- (void)reloadData;


@end
