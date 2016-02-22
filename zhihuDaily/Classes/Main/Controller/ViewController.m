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
#import "YSHttpTool.h"
#import "MJExtension.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, SYMainToolBoxDelegate>
@property (nonatomic, weak) SYMainToolBox *toolBox;
@property (nonatomic, weak) UIView *currentView;

@property (nonatomic, weak) UITapGestureRecognizer *tapGesture;


@property (nonatomic, strong) NSMutableArray<SYMenuItem *> *dataSource;

@property (nonatomic, strong) NSMutableArray *childVC;
@property (nonatomic, strong) NSMutableArray *childView;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //显示主界面
    [self showHomePage];
    
    // 设置 toolBox 面板
    [self setupToolBox];
    
    [self setupDataSource];
}


- (void)setupToolBox {
    SYMainToolBox *toolBox = [[[NSBundle mainBundle] loadNibNamed:@"SYMainToolBox" owner:nil options:nil] firstObject];
    toolBox.frame = CGRectMake(-kScreenWidth*0.6, 0, kScreenWidth*0.6, kScreenHeight);
    [self.view addSubview:toolBox];
    toolBox.delegate = self;
    toolBox.dataSource = self;
    toolBox.toolBoxDelegate = self;
    self.toolBox = toolBox;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progressNoti:) name:@"menuAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolBoxOpen) name:@"menuActionOpen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toolBoxClose) name:@"menuActionClose" object:nil];
}

- (void)setupDataSource {
    [YSHttpTool GETWithURL:@"http://news-at.zhihu.com/api/4/themes" params:nil success:^(id responseObject) {
        self.dataSource = [SYMenuItem mj_objectArrayWithKeyValuesArray:responseObject[@"others"]];
        SYMenuItem *home = [[SYMenuItem alloc] init];
        home.name = @"首页";
        home.id = 1;
        [self.dataSource insertObject:home atIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.toolBox reloadData];
        });
    } failure:^(NSError *error) {
        NSLog(@"获取主题出错： %@", error);
    }];

}


- (void)showHomePage {
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    UITableViewController *tvc = [[SYHomeController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tvc];
    
    if (self.currentView) {
        nav.view.frame = self.currentView.frame;
        [self.currentView removeFromSuperview];
    }
    self.currentView = nav.view;
    
    [self.view addSubview:nav.view];
    [self addChildViewController:nav];
}


#pragma mark 处理通知事件
- (void)progressNoti:(NSNotification *)noti {
    // menu 没有被弹出， 需要弹出
    if (self.currentView.frame.origin.x == 0) {
        [self toolBoxOpen];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.currentView addGestureRecognizer:tap];
        self.tapGesture = tap;
        
    } else {
    // menu 已经被弹出，需要被收回
        [self toolBoxClose];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    [self.currentView removeGestureRecognizer:self.tapGesture];
    [self menuClose];
}


#pragma mark 打开左侧面板
- (void)toolBoxOpen {
    if (self.currentView.frame.origin.x == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.toolBox.frame = CGRectMake(0, 0, kScreenWidth*0.6, kScreenHeight);
            self.currentView.frame = CGRectMake(CGRectGetMaxX(self.toolBox.frame), 0, kScreenWidth, kScreenHeight);
        }];
    }
}


#pragma mark 关闭左侧面板
- (void)toolBoxClose {
    if (self.currentView.frame.origin.x != 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.toolBox.frame = CGRectMake(-kScreenWidth*0.6, 0, kScreenWidth*0.6, kScreenHeight);
            self.currentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        }];
    }
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    cell.textLabel.text = self.dataSource[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self showHomePage];
    } else {
    
    
    }
    
    [self menuClose];
}



#pragma mark toolBox的按钮的代理方法
- (void)toolBox:(SYMainToolBox *)toolBox didClickedTitle:(NSString *)title {

    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    if ([title isEqualToString:@"设置"]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *setNav = [sb instantiateViewControllerWithIdentifier:@"setting"];
        if (self.currentView) {
            setNav.view.frame = self.currentView.frame;
            [self.currentView removeFromSuperview];
        }
        self.currentView = setNav.view;
        
        [self.view addSubview:setNav.view];
        [self addChildViewController:setNav];
    } else if ([title isEqualToString:@"消息"]) {
    
    } else if ([title isEqualToString:@"收藏"]) {
    
    }
    [self menuClose];
}

- (void)menuClose {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"menuActionClose" object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
