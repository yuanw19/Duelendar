//
//  IconCollectionViewCell.h
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IconCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *selectState;

@end

NS_ASSUME_NONNULL_END
