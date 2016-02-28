//
//  SYEditorCell.m
//  zhihuDaily
//
//  Created by yang on 16/2/28.
//  Copyright © 2016年 yang. All rights reserved.
//

#import "SYEditorCell.h"
#import "UIImageView+WebCache.h"

@interface SYEditorCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@end

@implementation SYEditorCell


- (void)awakeFromNib {
    self.avatarImageView.layer.cornerRadius = 18;
    self.avatarImageView.clipsToBounds = YES;
}


- (void)setEditor:(SYEditor *)editor {
    _editor = editor;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:editor.avatar]];
    self.nameLabel.text = editor.name;
    self.bioLabel.text = editor.bio;
    
}


@end
