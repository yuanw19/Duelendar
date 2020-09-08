//
//  SubjectTVCell.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/20.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "SubjectTVCell.h"

@implementation SubjectTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.iconBgView.layer.masksToBounds = YES;
    self.iconBgView.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
