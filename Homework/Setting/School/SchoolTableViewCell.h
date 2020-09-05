//
//  SchoolTableViewCell.h
//  Homework
//
//  Created by 牛晨雨 on 2020/9/5.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SchoolTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

NS_ASSUME_NONNULL_END
