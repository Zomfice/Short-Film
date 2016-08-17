//
//  StoryCell.m
//  Vision
//
//  Created by QianFeng on 16/6/13.
//  Copyright © 2016年 Zomfice. All rights reserved.
//

#import "StoryCell.h"

@interface StoryCell ()

@property (weak, nonatomic) IBOutlet UIImageView *head_pic_url;

@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *summary;

@property (weak, nonatomic) IBOutlet UIImageView *cover_url;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation StoryCell

- (void)refreshUI:(ArticalModel *)model{
    [self.head_pic_url sd_setImageWithURL:[NSURL URLWithString:model.head_pic_url]];
    self.nickname.text = model.nickname;
    self.summary.text = model.content;
    self.content.text = model.summary;
    [self.cover_url sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
    if (self.cover_url.image == nil) {
        self.cover_url.frame = CGRectZero;
    }
    self.title.text = model.title;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
