//
//  SYEditorController.m
//  zhihuDaily
//
//  Created by yang on 16/2/26.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYEditorController.h"
#import "SYEditorCell.h"
#import "SYEditorDetailController.h"

static NSString *editor_reuseid = @"editor_reuseid";

@interface SYEditorController ()

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SYEditorController

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self.view addSubview:self.tableView];
    self.title = @"主编";    
}

#pragma mark tableView delegate and data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.editors.count;
}

- (SYEditorCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYEditorCell *cell;
    if ([self.editors[indexPath.row] isKindOfClass:[SYEditor class]]) {
        cell = [SYEditorCell editorCellWithTableView:tableView];
    } else {
        cell = [SYEditorCell recommenderCellWithTableView:tableView];
    }

    cell.editor = self.editors[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SYEditorDetailController *edvc = [[SYEditorDetailController alloc] init];
    edvc.editor = self.editors[indexPath.row];
    
    [self.navigationController pushViewController:edvc animated:YES];
}


#pragma mark setter & getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        [_tableView registerNib:[UINib nibWithNibName:@"SYEditorCell" bundle:nil] forCellReuseIdentifier:editor_reuseid];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 60;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)setEditors:(NSArray<SYEditor *> *)editors {
    _editors = editors;
}


@end
