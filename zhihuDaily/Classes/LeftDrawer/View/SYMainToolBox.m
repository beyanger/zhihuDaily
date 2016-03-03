//
//  SYMainToolBox.m
//  zhihuDaily
//
//  Created by yang on 16/2/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYMainToolBox.h"
#import "SYToolButton.h"

@interface SYMainToolBox ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;


@end

@implementation SYMainToolBox

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.avatarImage.layer.cornerRadius = 20.0;
    self.avatarImage.clipsToBounds = YES;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
}


- (IBAction)didClickedButton:(UIButton *)sender {
    if ([self.toolBoxDelegate respondsToSelector:@selector(toolBox:didClickedTitle:)]) {
        [self.toolBoxDelegate toolBox:self didClickedTitle:sender.currentTitle];
    }
}


- (void)setDataSource:(id<UITableViewDataSource>)dataSource {
    self.tableView.dataSource = dataSource;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate {
    self.tableView.delegate = delegate;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    
//    CALayer *layer = [CALayer layer];
//    layer.backgroundColor = [UIColor greenColor].CGColor;
//    layer.bounds = CGRectMake(0, 0, 20, 20);
//    layer.position = point;
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.path = [UIBezierPath bezierPathWithOvalInRect:layer.bounds].CGPath;
//    layer.mask = maskLayer;
//    
//    [self.layer addSublayer:layer];
//    
//    CABasicAnimation *ba = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
//    ba.fromValue = (__bridge id)SYColor(255, 255, 255, 0.9).CGColor;
//    ba.toValue = (__bridge id)SYColor(255, 0, 0, 0.1).CGColor;
//    ba.duration = 2.0;
//    [layer addAnimation:ba forKey:@"sdfasdf"];
//    [ba setValue:layer forKey:@"key"];
//    ba.delegate = self;

    return [super hitTest:point withEvent:event];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layer = [anim valueForKey:@"key"];
    NSLog(@"sdfasdfsdf --> %@", layer);
    
    [layer removeFromSuperlayer];
}



@end
