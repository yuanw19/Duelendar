//
//  AppManager.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/19.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "AppManager.h"
#import <UserNotifications/UserNotifications.h>

NSString * const DB_NAME = @"UserInfo.sqlite";
NSString * const TABLE_NAME = @"Subject";
#define LocalNotiReqIdentifer    @"LocalNotiReqIdentifer"

@implementation AppManager

+ (AppManager *)defualtManager {
    static AppManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AppManager alloc]init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initDatabase];
        [self selectSubjectList];
        _colorArr = @[RGB(255, 0, 73, 1),RGB(44, 112, 255, 1),RGB(255, 195, 0, 1),RGB(170, 44, 246, 1),RGB(0, 190, 68, 1)];
    }
    return self;
}

- (void)initDatabase {
    _dbManager = [[DatabaseManager alloc] init];
    [_dbManager DatabaseWithDBName: DB_NAME];
    NSDictionary *tableKeys = @{@"name": @0, @"icon": @2, @"iconUndertone": @1, @"createTime": @3};
    [_dbManager createPathTable: TABLE_NAME WithKey: tableKeys];
}

- (void)selectSubjectList {
    NSArray *SDArr = [_dbManager selectAllInTable:TABLE_NAME WithKey:@{@"name": @0, @"icon": @2, @"iconUndertone": @1, @"createTime": @3}];
    _allSubjectInfo = SDArr.mutableCopy;
    NSLog(@"%@",SDArr);
}

- (BOOL)addNewSubject:(NSDictionary *)info {
    BOOL ret = [_dbManager insertInTable:TABLE_NAME WithKey:info];
    if (ret) {
        _addSubjectFlag = YES;
        [_allSubjectInfo insertObject:info atIndex:0];
    }
    return ret;
}

- (BOOL)checkSubjectNameValid:(NSString *)name {
    BOOL valid = YES;
    for (NSDictionary *dict in _allSubjectInfo) {
        if ([dict[@"name"] isEqualToString:name]) {
            valid = NO;
            break;
        }
    }
    return valid;
}

- (void)requestLocalNotificationAuthorization {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

// Notification
- (void)sendLocalNotification:(NSInteger)timeInternal missionInfo:(NSDictionary *)info parentVC:(UIViewController *)parentVC {
    if (timeInternal < 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"截止时间设置异常" message:@"您所选的截止日期是过去时间，我们将无法按时提醒您" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertC addAction:action];
        [parentVC presentViewController:alertC animated:YES completion:nil];
        return;
    }
    NSString *notificationID = [NSString stringWithFormat:@"%@-%ld",info[@"name"],(NSInteger)[info[@"createDate"] timeIntervalSince1970]];
    [self cancelLocalNotificationWithID:notificationID];
        
    NSString *title = info[@"name"];
    NSString *subtitle = info[@"info"];
    NSDictionary *userInfo = @{@"ID":notificationID};
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted) {
                // 1.创建通知内容
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.sound = [UNNotificationSound defaultSound];
                content.title = title;
                content.subtitle = subtitle;    
                content.userInfo = userInfo;
                
                // 3.触发模式
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInternal repeats:NO];
                
                // 4.设置UNNotificationRequest
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notificationID content:content trigger:trigger];
                
                // 5.把通知加到UNUserNotificationCenter, 到指定触发点会被触发
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    NSLog(@"通知:%@",error);
                }];
            }
        }];
    }
    else {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        // 1.设置触发时间（如果要立即触发，无需设置）
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.fireDate = info[@"remindDate"];
        
        // 2.设置通知标题
        localNotification.alertBody = title;
        
        // 3.设置通知动作按钮的标题
        localNotification.alertAction = @"查看";
        
        // 4.设置提醒的声音
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        // 5.设置通知的 传递的userInfo
        localNotification.userInfo = userInfo;
        
        // 6.在规定的日期触发通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        // 6.立即触发一个通知
        //[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    }
}

- (void)cancelLocalNotificaitons {
    
    // 取消一个特定的通知
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    // 获取当前所有的本地通知
    if (!notificaitons || notificaitons.count <= 0) { return; }
    for (UILocalNotification *notify in notificaitons) {
        if ([[notify.userInfo objectForKey:@"id"] isEqualToString:@"LOCAL_NOTIFY_SCHEDULE_ID"]) {
            if (@available(iOS 10.0, *)) {
                [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[LocalNotiReqIdentifer]];
            } else {
                [[UIApplication sharedApplication] cancelLocalNotification:notify];
            }
            break;
        }
    }
    // 取消所有的本地通知
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

UIColor * RGB (CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255 blue:b/255 alpha:a];
    return color;
}

- (void)cancelLocalNotificationWithID:(NSString *)notificationID {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *loc in localNotifications) {
        if ([loc.userInfo[@"ID"] isEqualToString:notificationID]) {
            if (@available(iOS 10.0, *)) {
                [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[loc.userInfo[@"ID"]]];
            } else {
                [[UIApplication sharedApplication] cancelLocalNotification:loc];
            }
        }
    }
}

@end
