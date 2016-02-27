//
//  SYEditorController.m
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYEditorController.h"

@interface SYEditorController () //<UITableViewDataSource, UITableViewDelegate>

@end

@implementation SYEditorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sy_header.backgroundColor = [UIColor blueColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"主编";    
}



- (void)setEditors:(NSArray<SYEditor *> *)editors {
    _editors = editors;
}


@end
