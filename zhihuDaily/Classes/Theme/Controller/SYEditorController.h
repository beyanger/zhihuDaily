//
//  SYEditorController.h
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYEditor.h"
#import "SYBaseViewController.h"
#import "SYEditorCell.h"
#import "SYEditorDetailController.h"

@interface SYEditorController : SYBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *editors;

@end
