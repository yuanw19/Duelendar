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
@property (weak, nonatomic) IBOutlet UIButton *addMissionButton;
@property (nonatomic,strong) NSMutableArray *missionArr;

@end

@implementation MissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.missionTableView.delegate = self;
    self.missionTableView.dataSource = self;
    [self.missionTableView registerNib:[UINib nibWithNibName:@"MissionTableViewCell" bundle:nil] forCellReuseIdentifier:@"MissionCell"];
    NSDictionary *tableKeys = @{@"subject":@0, @"name": @0, @"deadline": @3, @"remindDate": @3, @"remark": @0, @"state": @4};

    _missionArr = [[AppManager defualtManager].dbManager selectInTable:@"Mission" WithKey:tableKeys whereCondition:@{@"subject":self.subjectName}];
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
    NSDate *date = dict[@"deadline"];
    NSInteger timeInterval = [date timeIntervalSinceDate:[NSDate date]] / 60;
    NSString *dateStr = timeInterval < 0 ? @"过时":@"还剩";
    timeInterval = labs(timeInterval);
    if (timeInterval > 1440) {
        dateStr = [NSString stringWithFormat:@"%@%ld天%ld时%ld分",dateStr, timeInterval/1440, timeInterval%1440/60,timeInterval%60];
    }
    else if (timeInterval > 60) {
        dateStr = [NSString stringWithFormat:@"%@%ld时%ld分",dateStr, timeInterval/60,timeInterval%60];
    }
    else {
        dateStr = [NSString stringWithFormat:@"%@%ld分",dateStr, timeInterval%60];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@:%@", dict[@"name"], dateStr];
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
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath:%@",indexPath);
}

// edit
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    // AVAILABLE AT iOS 8.0
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:LOC(@"已完成") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        weakSelf.missionTableView.editing = NO;
    }];
    editRowAction.backgroundColor = [UIColor colorWithRed:0 green:124/255.0 blue:223/255.0 alpha:1];
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LOC(@"删除") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

        weakSelf.missionTableView.editing = NO;
    }];
    return @[deleteRoWAction, editRowAction];
    
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

- (void)dealloc {
    NSLog(@"%s",__func__);
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
