//
//  SYRecommendController.m
//  zhihuDaily
//
//  Created by yang on 16/3/1.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYRecommendController.h"

@interface SYRecommendController ()

@end

@implementation SYRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐者";
}

#pragma mark tableView delegate
- (SYEditorCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYEditorCell *cell = [SYEditorCell recommenderCellWithTableView:tableView];
    cell.editor = self.editors[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
