//
//  MissionDetailViewController.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "MissionDetailViewController.h"

@interface MissionDetailViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *nameBgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIView *deadlineBgView;
@property (weak, nonatomic) IBOutlet UIButton *deadLineButton;
@property (weak, nonatomic) IBOutlet UIView *remindBgView;
@property (weak, nonatomic) IBOutlet UIPickerView *dayPickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *countDownPicker;
@property (weak, nonatomic) IBOutlet UITextView *remarkTV;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (nonatomic, assign) BOOL isDeadlineDatePicker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *deadline;
@property (nonatomic, assign) NSTimeInterval countDownTime;

@end

@implementation MissionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    NSDictionary *tableKeys = @{@"subject":@0, @"name": @0, @"deadline": @3, @"remindDate": @3, @"createDate":@3, @"remark": @0, @"state": @4};
    [[AppManager defualtManager].dbManager createPathTable: @"Mission" WithKey: tableKeys];
    
    _nameTF.borderStyle = UITextBorderStyleNone;
    _remarkTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _remarkTV.layer.cornerRadius = 10.0;
    _nameBgView.layer.masksToBounds = YES;
    _nameBgView.layer.cornerRadius = 10;
    _deadlineBgView.layer.masksToBounds = YES;
    _deadlineBgView.layer.cornerRadius = 10;
    _remindBgView.layer.masksToBounds = YES;
    _remindBgView.layer.cornerRadius = 10;
    
    _dayPickerView.delegate = self;
    _dayPickerView.dataSource = self;
    NSString *titleStr;
    if (_showState == ShowState_create) {
        titleStr = @"添加作业";
    }
    else {
        _nameTF.text = _missionInfo[@"name"];
        NSDate *selDate = _missionInfo[@"deadline"];
        _deadline = selDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *dateStr = [formatter stringFromDate:selDate];
        [_deadLineButton setTitle:dateStr forState:(UIControlStateNormal)];
        _deadLineButton.selected = YES;
        NSTimeInterval interval = [_missionInfo[@"remindDate"] timeIntervalSinceDate:_missionInfo[@"deadline"]];
        int val = (fabs(interval));
        // 60*60*24 = 86400一天的秒数
        if (val > 86400) {
            [_dayPickerView selectRow:val/86400 inComponent:0 animated:YES];
        }
        _countDownPicker.countDownDuration = val%86400;
        _remarkTV.text = _missionInfo[@"remark"];
        if (_showState == ShowState_edit) {
            titleStr = @"编辑作业";
            [_createButton setTitle:@"确认修改" forState:(UIControlStateNormal)];
        }
        else {
            titleStr = @"查看作业";
            _nameTF.userInteractionEnabled = NO;
            _deadLineButton.userInteractionEnabled = NO;
            _dayPickerView.userInteractionEnabled = NO;
            _countDownPicker.userInteractionEnabled = NO;
            _remarkTV.editable = NO;
            _createButton.hidden = YES;
        }
    }
    self.title = titleStr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Button Action
- (IBAction)deadlineAction:(UIButton *)sender {
    [self hideKeyboard];
    _isDeadlineDatePicker = YES;
    [self popDatePicker];
}

- (IBAction)createButton:(UIButton *)sender {
    if (_nameTF.text.length == 0) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"创建失败" message:@"请输入作业名称" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    else if (!_deadline) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"创建失败" message:@"请输入截止时间" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
        return;
    }
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSArray *timeZoneInfo = [userDef objectForKey:@"TimeZone"];
    NSTimeZone *timeZone;
    if (timeZoneInfo.count > 1) {
        timeZone = [NSTimeZone timeZoneWithName:timeZoneInfo[1]];
    }
    else {
        timeZone = [NSTimeZone localTimeZone];
    }
    NSDate *fixDate = [NSDate dateWithTimeInterval:-[timeZone secondsFromGMT] sinceDate:_deadline];
    NSLog(@"%ld, 修正后的时间:%@",[timeZone secondsFromGMT], fixDate);
    _countDownTime = [_countDownPicker countDownDuration];
    _countDownTime += 24*3600*[_dayPickerView selectedRowInComponent:0];
    
    NSDate *createDate = [NSDate date];
    NSDate *remindDate = [NSDate dateWithTimeInterval:_countDownTime sinceDate:_deadline];
    NSDictionary *dict;
    BOOL ret;
    if (_showState == ShowState_create) {
        dict = @{@"subject":self.subjectName, @"name": _nameTF.text, @"deadline": _deadline, @"remindDate": remindDate, @"createDate":createDate, @"remark": _remarkTV.text, @"state": @NO};
        ret = [[AppManager defualtManager].dbManager insertInTable:@"Mission" WithKey:dict];
    }
    else {
        dict = @{@"subject":self.subjectName, @"name": _nameTF.text, @"deadline": _deadline, @"remindDate": remindDate, @"remark": _remarkTV.text};
        ret = [[AppManager defualtManager].dbManager updateInTable:@"Mission" WithKey:dict whereCondition:@{@"id": _missionInfo[@"id"]}];
    }
    if (ret) {
        [AppManager defualtManager].addNewMission = YES;
        NSString *info = @"距离作业提交还有";
        NSInteger day = [_dayPickerView selectedRowInComponent:0];
        int timeInterval = [_countDownPicker countDownDuration]/60;
        if (day > 0) {
            info = [NSString stringWithFormat:@"%@%ld天 %d时 %d分",info,day,timeInterval/60, timeInterval%60];
        }
        else if (_countDownTime > 60) {
            info = [NSString stringWithFormat:@"%@ %d时 %d分",info, timeInterval/60, timeInterval%60];
        }
        else {
            info = [NSString stringWithFormat:@"%@ %d分",info, timeInterval];
        }
        
        [[AppManager defualtManager]sendLocalNotification:[remindDate timeIntervalSinceNow] missionInfo:@{@"name": _nameTF.text, @"info": info, @"ID": [NSString stringWithFormat:@"%@-%ld",_nameTF.text,(NSInteger)[createDate timeIntervalSince1970]]}];
        // 设置本地通知
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
       UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"创建失败" message:@"作业保存失败" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alertC addAction:action];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)popDatePicker {
    UIView *bgMask = [[UIView alloc]initWithFrame:self.view.frame];
    bgMask.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.6];
    bgMask.tag = 107;
    [self.view addSubview:bgMask];
    
    CGRect tmpFrame = bgMask.frame;
    tmpFrame.size.height *= .5;
    tmpFrame.origin.y = tmpFrame.size.height;
    UIView *bgView = [[UIView alloc]initWithFrame:tmpFrame];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgMask addSubview:bgView];
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [cancel setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancel addTarget:self action:@selector(cancelAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [cancel setTitleColor:RGB(0x78, 0x78, 0x78, 1) forState:(UIControlStateNormal)];
    [bgView addSubview:cancel];
    
    UIButton *confirm = [[UIButton alloc]initWithFrame:CGRectMake(tmpFrame.size.width - 60, CGRectGetMinY(cancel.frame), 60, 40)];
    [confirm setTitle:@"确定" forState:(UIControlStateNormal)];
    [confirm addTarget:self action:@selector(confirmAct:) forControlEvents:(UIControlEventTouchUpInside)];
    [confirm setTitleColor:RGB(0xD0, 0x02, 0x1B, 1) forState:(UIControlStateNormal)];
    [bgView addSubview:confirm];
    
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(confirm.frame), tmpFrame.size.width, 1)];
    separator.backgroundColor = RGB(0x78, 0x78, 0x78, 1);
    [bgView addSubview:separator];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(separator.frame), tmpFrame.size.width, tmpFrame.size.height-CGRectGetMaxY(separator.frame))];
    [datePicker setDatePickerMode:_isDeadlineDatePicker ? UIDatePickerModeDateAndTime: UIDatePickerModeCountDownTimer];
    datePicker.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:datePicker];
    _datePicker = datePicker;
}

- (void)cancelAct:(UIButton *)sender {
    [[self.view viewWithTag:107]removeFromSuperview];
}

- (void)confirmAct:(UIButton *)sender {
    if (_isDeadlineDatePicker) {
        NSDate *selDate = [_datePicker date];
        _deadline = selDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *dateStr = [formatter stringFromDate:selDate];
        [_deadLineButton setTitle:dateStr forState:(UIControlStateNormal)];
        _deadLineButton.selected = YES;
    }
    else {
        _countDownTime = [_datePicker countDownDuration];
        int timeInterval = _countDownTime/60;
        NSString *timeStr = [NSString stringWithFormat:@"%d时 %2d分",timeInterval/60, timeInterval%60];
        NSLog(@"--:%@",timeStr);
//        [_remindButton setTitle:timeStr forState:(UIControlStateNormal)];
    }
    [[self.view viewWithTag:107]removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [_nameTF resignFirstResponder];
    [_remarkTV resignFirstResponder];
}

// UIPickerView delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [pickerLabel setTextColor: [UIColor blackColor]];
    }
    // Fill the label text here
    pickerLabel.text = [NSString stringWithFormat:@"%ld", row];
    return pickerLabel;
}

@end
