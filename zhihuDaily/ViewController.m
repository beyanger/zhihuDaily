//
//  ViewController.m
//  zhihuDaily
//
//  Created by yang on 16/2/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "ViewController.h"
#import "SYMainToolBox.h"
#import "SYMenuItem.h"
#import "SYHomeController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SYMainToolBoxDelegate>
@property (nonatomic, weak) SYMainToolBox *toolBox;
@property (nonatomic, weak) UIView *currentView;


@property (nonatomic, strong) NSArray<SYMenuItem *> *dataSource;

@end

@implementation ViewController

- (NSArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *mutableArray = [@[] mutableCopy];
        // 先从沙箱中获取数据
        NSString *pathStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *fullPath = [pathStr stringByAppendingPathComponent:@"menu.plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:fullPath];
        
        if (!array) {
            //若沙箱中没有数据，则从bundle中获取
            NSString *path = [[NSBundle mainBundle] pathForResource:@"menu.plist" ofType:nil];
            array = [NSArray arrayWithContentsOfFile:path];
        }
        
        for (NSDictionary *dict in array) {
            SYMenuItem *item = [SYMenuItem itemWithDictionary:dict];
            [mutableArray addObject:item];
        }
        _dataSource = [mutableArray copy];
    }
    return _dataSource;
}
// 保存数据到沙箱中
- (void)saveData {
    NSString *pathStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fullPath = [pathStr stringByAppendingPathComponent:@"menu.plist"];
    NSMutableArray *mutableArray = [@[] mutableCopy];
    for (SYMenuItem *item in self.dataSource) {
        NSDictionary *dict = @{@"title":item.title, @"collected":@(item.collected)};
        [mutableArray addObject:dict];
        
    }
    [mutableArray writeToFile:fullPath atomically:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置 toolBox 面板
    SYMainToolBox *toolBox = [[[NSBundle mainBundle] loadNibNamed:@"SYMainToolBox" owner:nil options:nil] firstObject];
    toolBox.frame = CGRectMake(-kScreenWidth*0.6, 0, kScreenWidth*0.6, kScreenHeight);
    [self.view addSubview:toolBox];
    toolBox.delegate = self;
    toolBox.dataSource = self;
    toolBox.toolBoxDelegate = self;
    self.toolBox = toolBox;
    
    
    UITableViewController *tvc = [[SYHomeController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tvc];
    
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    self.currentView = nav.view;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressNoti:) name:@"menuAction" object:nil];
}




#pragma mark 处理通知事件
- (void)progressNoti:(NSNotification *)noti {
    // menu 没有被弹出， 需要弹出
    if (self.currentView.frame.origin.x == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.toolBox.frame = CGRectMake(0, 0, kScreenWidth*0.6, kScreenHeight);
            self.currentView.frame = CGRectMake(CGRectGetMaxX(self.toolBox.frame), 0, kScreenWidth, kScreenHeight);
        }];
        
    } else {
    // menu 已经被弹出，需要被收回
        [UIView animateWithDuration:0.25 animations:^{
            self.toolBox.frame = CGRectMake(-kScreenWidth*0.6, 0, kScreenWidth*0.6, kScreenHeight);
            self.currentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }];
    }

}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}



#pragma mark toolBox中tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuse_id = @"reuse_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse_id];
    }
    cell.textLabel.text = self.dataSource[indexPath.row].title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}



#pragma mark toolBox的按钮的代理方法
- (void)toolBox:(SYMainToolBox *)toolBox didClickedTitle:(NSString *)title {
    NSLog(@"%@", title);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
