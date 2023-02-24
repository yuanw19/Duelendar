//
//  MissionTableViewCell.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "MissionTableViewCell.h"

@implementation MissionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _leftView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
