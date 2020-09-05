//
//  BaseFlowLayout.m
//  topScrollHeader
//
//  Created by wsk on 15/12/22.
//  Copyright © 2015年 wsk. All rights reserved.
//

//  // 创建布局
//  BaseFlowLayout *layout = [[BaseFlowLayout alloc] init];
//  UICollectionView *contentScrollView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

#import "BaseFlowLayout.h"
static const NSInteger column = 4;
static const NSInteger itemSpace = 4;
@implementation BaseFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    self.minimumInteritemSpacing = 4;
    self.minimumLineSpacing = 4;
    self.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4);
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat itemWidth = (width - (itemSpace*(column+1)))/column;
    self.itemSize = CGSizeMake(itemWidth, itemWidth*16/9);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.headerReferenceSize = CGSizeMake(self.itemSize.width, 20);
//    self.headerReferenceSize = CGSizeZero;
}
@end
