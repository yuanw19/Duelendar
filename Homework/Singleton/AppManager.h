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
+ (AppManager *)defualtManager;
UIColor * RGB (CGFloat r, CGFloat g, CGFloat b, CGFloat a);
- (BOOL)addNewSubject:(NSDictionary *)info;
- (BOOL)checkSubjectNameValid:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
