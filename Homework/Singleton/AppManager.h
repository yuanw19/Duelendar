//
//  AppManager.h
//  Homework
//
//  Created by 牛晨雨 on 2020/8/19.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppManager : NSObject
@property (nonatomic, strong) DatabaseManager *dbManager;
@property (nonatomic, strong) NSMutableArray *allSubjectInfo;
@property (nonatomic, assign) BOOL addSubjectFlag;
@property (nonatomic, strong) NSArray *colorArr;
@property (nonatomic, assign) BOOL changeBackgroundImg;
@property (nonatomic, assign) BOOL changeSchoolName;
@property (nonatomic, assign) BOOL changeUserAvatar;
@property (nonatomic, assign) BOOL changeNickname;
@property (nonatomic, assign) BOOL addNewMission;

+ (AppManager *)defualtManager;
UIColor * RGB (CGFloat r, CGFloat g, CGFloat b, CGFloat a);
- (BOOL)addNewSubject:(NSDictionary *)info;
- (BOOL)checkSubjectNameValid:(NSString *)name;
- (void)requestLocalNotificationAuthorization;
- (void)sendLocalNotification:(NSInteger)timeInternal missionInfo:(NSDictionary *)info parentVC:(UIViewController *)parentVC;
- (void)sendLocalNotification:(NSInteger)timeInternal missionInfo:(NSDictionary *)info parentVC:(UIViewController *)parentVC completeHandle:(void (^)(UIAlertAction *action))handler;
- (void)cancelLocalNotificationWithID:(NSString *)notificationID;
@end

NS_ASSUME_NONNULL_END
