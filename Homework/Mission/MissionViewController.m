//
//  MissionViewController.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "MissionViewController.h"
#import "MissionTableViewCell.h"
#import "MissionDetailViewController.h"

@interface MissionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *missionTableView;
@property (nonatomic, strong) NSMutableArray *missionArr;
@property (weak, nonatomic) IBOutlet UIView *iconBgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIButton *addMissionBtn;
@property (weak, nonatomic) IBOutlet UIButton *incompleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *completedBtn;

@end

@implementation MissionViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isMovingToParentViewController == NO) {
        if ([AppManager defualtManager].addNewMission == YES) {
            [AppManager defualtManager].addNewMission = NO;
            [self queryDataFromDatabase];
            [_missionTableView reloadData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.subjectName;
//    _iconImgView.image = []
    self.iconImgView.image = [UIImage imageWithData:_subjectInfo[@"icon"]];
    self.iconBgView.backgroundColor = [AppManager defualtManager].colorArr[[_subjectInfo[@"iconUndertone"] intValue]];
    
    // Do any additional setup after loading the view from its nib.
    self.missionTableView.delegate = self;
    self.missionTableView.dataSource = self;
    [self.missionTableView registerNib:[UINib nibWithNibName:@"MissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MissionCell"];

    _iconBgView.layer.masksToBounds = YES;
    _iconBgView.layer.cornerRadius = 10;
    _addMissionBtn.layer.masksToBounds = YES;
    _addMissionBtn.layer.cornerRadius = 10;
    _incompleteBtn.selected = YES;
    [self queryDataFromDatabase];
}

- (void)queryDataFromDatabase {
    NSDictionary *tableKeys = @{@"id":@1, @"subject":@0, @"name": @0, @"deadline": @3, @"remindDate": @3, @"createDate":@3 ,@"remark": @0, @"state": @4};
    _missionArr = [[AppManager defualtManager].dbManager selectInTable:@"Mission" WithKey:tableKeys whereCondition:@{@"subject":self.subjectName, @"state": @(_completedBtn.selected)}];
}

#pragma mark - tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _missionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MissionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MissionCell" forIndexPath:indexPath];
    NSDictionary *dict = _missionArr[indexPath.row];
    cell.nameL.text = dict[@"name"];
    cell.nameL.textColor = _completedBtn.selected ? RGB(133, 204, 255, 1) : RGB(255, 0, 73, 1);
    cell.remarkL.text = [NSString stringWithFormat:@"备注:%@",dict[@"remark"]];

    NSDate *date = dict[@"deadline"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSArray *timeZoneInfo = [userDef objectForKey:@"TimeZone"];
    NSTimeZone *timeZone;
    if (timeZoneInfo.count > 1) {
        timeZone = [NSTimeZone timeZoneWithName:timeZoneInfo[1]];
    }
    else {
        timeZone = [NSTimeZone localTimeZone];
    }
    NSDate *fixDate = [NSDate dateWithTimeInterval:NSTimeZone.localTimeZone.secondsFromGMT - timeZone.secondsFromGMT sinceDate:date];
    NSInteger timeInterval = [fixDate timeIntervalSinceDate:[NSDate date]] / 60;
    cell.timeStateL.text = timeInterval < 0 ? @"过时":@"距离截止还有";
    timeInterval = labs(timeInterval);
    NSString *timeStr, *unitStr;
    if (timeInterval > 1440) {
        unitStr = @"天";
        timeStr = [NSString stringWithFormat:@"%.1f", timeInterval/1440.0];
    }
    else if (timeInterval > 60) {
        unitStr = @"时";
        timeStr = [NSString stringWithFormat:@"%.1f", timeInterval/60.0];
    }
    else {
        unitStr = @"分";
        timeStr = [NSString stringWithFormat:@"%ld", timeInterval%60];
    }
    
    cell.unitL.text = unitStr;
    cell.dayL.text = timeStr;
    cell.dayL.backgroundColor = _completedBtn.selected ? RGB(44, 112, 255, 1) : RGB(255, 0, 73, 1);
    return cell;
}

// TableView Header, Footer
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath:%@",indexPath);
    MissionDetailViewController *missionDetailVC = [[MissionDetailViewController alloc]init];
    missionDetailVC.subjectName = self.subjectName;
    missionDetailVC.showState = _completedBtn.selected ? ShowState_view : ShowState_edit;
    missionDetailVC.missionInfo = _missionArr[indexPath.row];
    [self.navigationController pushViewController:missionDetailVC animated:YES];
}

// edit
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // AVAILABLE AT iOS 8.0
    __weak typeof(self) weakSelf = self;
    
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LOC(@"删除") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSDictionary *dict = weakSelf.missionArr[indexPath.row];
        BOOL ret = [[AppManager defualtManager].dbManager deleteInTable:@"Mission" WithKey:@{@"id": dict[@"id"]}];
        if (ret) {
            NSString *notificationID = [NSString stringWithFormat:@"%@-%ld",dict[@"name"],(NSInteger)[dict[@"createDate"] timeIntervalSince1970]];
            [[AppManager defualtManager]cancelLocalNotificationWithID:notificationID];
            [weakSelf.missionArr removeObjectAtIndex:indexPath.row];
            [weakSelf.missionTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        }
        weakSelf.missionTableView.editing = NO;
    }];
    if (_incompleteBtn.selected) {
        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:LOC(@"已完成") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSDictionary *dict = weakSelf.missionArr[indexPath.row];
            BOOL ret = [[AppManager defualtManager].dbManager updateInTable:@"Mission" WithKey:@{@"state": @(YES)} whereCondition:@{@"id": dict[@"id"]}];
            if (ret) {
                NSString *notificationID = [NSString stringWithFormat:@"%@-%ld",dict[@"name"],(NSInteger)[dict[@"createDate"] timeIntervalSince1970]];
                [[AppManager defualtManager]cancelLocalNotificationWithID:notificationID];
                [weakSelf.missionArr removeObjectAtIndex:indexPath.row];
                [weakSelf.missionTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
            }
            weakSelf.missionTableView.editing = NO;
        }];
        editRowAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:223/255.0 alpha:1];
        return @[deleteRoWAction, editRowAction];
    }
    else {
        UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:LOC(@"未完成") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            NSDictionary *dict = weakSelf.missionArr[indexPath.row];
            BOOL ret = [[AppManager defualtManager].dbManager updateInTable:@"Mission" WithKey:@{@"state": @(NO)} whereCondition:@{@"id": dict[@"id"]}];
            if (ret) {
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                NSArray *timeZoneInfo = [userDef objectForKey:@"TimeZone"];
                NSTimeZone *timeZone;
                if (timeZoneInfo.count > 1) {
                    timeZone = [NSTimeZone timeZoneWithName:timeZoneInfo[1]];
                }
                else {
                    timeZone = [NSTimeZone localTimeZone];
                }                
                int timeInterval = [dict[@"deadline"] timeIntervalSinceDate:dict[@"remindDate"]] / 60;
                if (timeInterval > 0) {
                    NSString *info = @"距离作业提交还有";
                    if (timeInterval > 1440) {
                        info = [NSString stringWithFormat:@"%@%d天 %d时 %d分",info,timeInterval/1440,timeInterval/60, timeInterval%60];
                    }
                    else if (timeInterval > 60) {
                        info = [NSString stringWithFormat:@"%@ %d时 %d分",info, timeInterval/60, timeInterval%60];
                    }
                    else {
                        info = [NSString stringWithFormat:@"%@ %d分",info, timeInterval];
                    }
                    NSDate *fixDate = [NSDate dateWithTimeInterval:NSTimeZone.localTimeZone.secondsFromGMT - timeZone.secondsFromGMT sinceDate:dict[@"deadline"]];

                    [[AppManager defualtManager]sendLocalNotification:[[NSDate dateWithTimeInterval:-timeInterval sinceDate:fixDate] timeIntervalSinceNow] missionInfo:@{@"name": dict[@"name"], @"info": info} parentVC:self];
                }
                
                [weakSelf.missionArr removeObjectAtIndex:indexPath.row];
                [weakSelf.missionTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
            }
            weakSelf.missionTableView.editing = NO;
        }];
        editRowAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:223/255.0 alpha:1];
        return @[deleteRoWAction, editRowAction];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",indexPath);
}

// button action
- (IBAction)addNewMission:(UIButton *)sender {
    MissionDetailViewController *missionDetailVC = [[MissionDetailViewController alloc]init];
    missionDetailVC.subjectName = self.subjectName;
    [self.navigationController pushViewController:missionDetailVC animated:YES];
}

- (IBAction)incompleteAction:(UIButton *)sender {
    if (_incompleteBtn.selected == NO) {
        _incompleteBtn.selected = YES;
        _completedBtn.selected = NO;
        [self queryDataFromDatabase];
        [_missionTableView reloadData];
    }
}

- (IBAction)completedAction:(UIButton *)sender {
    if (_completedBtn.selected == NO) {
        _completedBtn.selected = YES;
        _incompleteBtn.selected = NO;
        [self queryDataFromDatabase];
        [_missionTableView reloadData];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
