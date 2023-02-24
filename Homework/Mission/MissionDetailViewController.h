//
//  MissionDetailViewController.h
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum ShowState {
    ShowState_create,
    ShowState_edit,
    ShowState_view
}ShowState;
@interface MissionDetailViewController : UIViewController
@property (nonatomic, strong) NSString *subjectName;
@property (nonatomic, assign) ShowState showState;
@property (nonatomic, strong) NSDictionary *missionInfo;
@end

NS_ASSUME_NONNULL_END
