//
//  MissionDetailViewController.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "MissionDetailViewController.h"

@interface MissionDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *missionNameTF;
@property (weak, nonatomic) IBOutlet UIButton *deadLineButton;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;
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
    self.title = self.subjectName;
    // Do any additional setup after loading the view from its nib.
    NSDictionary *tableKeys = @{@"subject":@0, @"name": @0, @"deadline": @3, @"remindDate": @3, @"remark": @0, @"state": @4};
    [[AppManager defualtManager].dbManager createPathTable: @"Mission" WithKey: tableKeys];
    
    UIColor *borderColor = [UIColor blueColor];
    CGFloat borderWidth = 2;
    _missionNameTF.layer.borderColor = borderColor.CGColor;
    _missionNameTF.layer.borderWidth = borderWidth;
    _deadLineButton.layer.borderColor = borderColor.CGColor;
    _deadLineButton.layer.borderWidth = borderWidth;
    _remindButton.layer.borderColor = borderColor.CGColor;
    _remindButton.layer.borderWidth = borderWidth;
    _remarkTV.layer.borderColor = borderColor.CGColor;
    _remarkTV.layer.borderWidth = borderWidth;
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

- (IBAction)remindAction:(UIButton *)sender {
    [self hideKeyboard];
    _isDeadlineDatePicker = NO;
    [self popDatePicker];
}

- (IBAction)createButton:(UIButton *)sender {
    if (_missionNameTF.text.length == 0) {
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
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    NSDate *fixDate = [NSDate dateWithTimeInterval:-[timeZone secondsFromGMT] sinceDate:_deadline];
    NSLog(@"%ld, 修正后的时间:%@",[timeZone secondsFromGMT], fixDate);

    NSDate *remindDate = [NSDate dateWithTimeInterval:_countDownTime sinceDate:_deadline];
    NSDictionary *dict = @{@"subject":self.subjectName, @"name": _missionNameTF.text, @"deadline": _deadline, @"remindDate": remindDate, @"remark": _remarkTV.text, @"state": @NO};
    BOOL ret = [[AppManager defualtManager].dbManager insertInTable:@"Mission" WithKey:dict];
    if (ret) {
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
//    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
//    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
//    [datePicker setCalendar:[NSCalendar currentCalendar]];
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
    }
    else {
        _countDownTime = [_datePicker countDownDuration];
        int timeInterval = _countDownTime/60;
        NSString *timeStr = [NSString stringWithFormat:@"%d时 %2d分",timeInterval/60, timeInterval%60];
        [_remindButton setTitle:timeStr forState:(UIControlStateNormal)];
    }
    [[self.view viewWithTag:107]removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [_missionNameTF resignFirstResponder];
    [_remarkTV resignFirstResponder];
}


@end
