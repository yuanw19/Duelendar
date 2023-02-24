//
//  SubjectTableView.h
//  Homework
//
//  Created by 牛晨雨 on 2020/8/20.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubjectTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) MainViewController *mainVC;
@end

NS_ASSUME_NONNULL_END
