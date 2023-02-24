//
//  SettingViewController.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "SettingViewController.h"
#import "SchoolViewController.h"
#import "BackgroundVC.h"
#import "SettingTVCell.h"
#import <Photos/Photos.h>

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    UIPickerView *typePV;
}
@property (weak, nonatomic) IBOutlet UIView *iconBgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UITableView *settingTV;
@property (nonatomic, strong) NSDictionary *tableConfigDict;
@property (nonatomic, strong) NSDictionary *timezoneDict;
@property (nonatomic, strong) NSMutableArray *detailInfoArr;
@end

@implementation SettingViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isMovingToParentViewController == NO) {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        if ([AppManager defualtManager].changeSchoolName == YES) {
            //            [AppManager defualtManager].changeSchoolName = NO;
            _detailInfoArr[0][1] = [userDef objectForKey:@"SchoolName"];
            [_settingTV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = RGB(17, 18, 28, 1);
    // Do any additional setup after loading the view from its nib.
    _iconBgView.layer.masksToBounds = YES;
    _iconBgView.layer.cornerRadius = 40;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openPhotos:)];
    [_iconBgView addGestureRecognizer:tapGes];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSData *imgData = [userDef objectForKey:@"UserAvatar"];
    _iconImgView.image = [UIImage imageWithData:imgData];
    
    NSString *nickname = [userDef objectForKey:@"Nickname"];
    NSString *schoolName = [userDef objectForKey:@"SchoolName"];
    NSString *timezone = [userDef objectForKey:@"TimeZone"];
    if ([timezone isKindOfClass:[NSArray class]]) {
        timezone = [(NSArray *)timezone objectAtIndex:0];
    }
    _detailInfoArr = @[@[nickname ? nickname:@"", schoolName ? schoolName:@""].mutableCopy,@[timezone ? timezone:@""].mutableCopy,@[@""]].mutableCopy;
    
    _settingTV.delegate = self;
    _settingTV.dataSource = self;
    _settingTV.backgroundColor = [UIColor clearColor];
    [_settingTV registerNib:[UINib nibWithNibName:@"SettingTVCell" bundle:nil] forCellReuseIdentifier:@"Setting"];
    
    _tableConfigDict = @{
        @"section0": @[@{@"icon":@"昵称", @"title":@"昵称"},@{@"icon":@"学校", @"title":@"学校"}],
        @"section1": @[@{@"icon":@"学校时区", @"title":@"学校所在时区"}],
        @"section2": @[@{@"icon":@"背景", @"title":@"背景"}],
    };
    
    _timezoneDict = @{
        @"美国东部时区（纽约）":@"America/New_York",
        @"美国太平洋时区（洛杉矶）":@"America/Los_Angeles",
        @"美国中部时区（芝加哥）":@"America/Chicago",
        @"美国山地时区（丹佛）":@"America/Denver",
        @"美国夏威夷时区（火奴鲁鲁）":@"Pacific/Honolulu",
        @"加拿大太平洋时区（温哥华）":@"America/Vancouver",
        @"加拿大山地时区（埃德蒙顿）":@"America/Edmonton",
        @"加拿大中部时区（温尼伯）":@"America/Winnipeg",
        @"加拿大东部时区（蒙特利尔）":@"America/Montreal",
        @"加拿大纽芬兰时区（圣约翰斯）":@"America/St_Johns",
        @"法国（巴黎）":@"Europe/Paris",
        @"意大利（罗马）":@"Europe/Rome",
        @"荷兰（阿姆斯特丹）":@"Europe/Amsterdam",
        @"德国（柏林）":@"Europe/Berlin",
        @"英国（伦敦）":@"Europe/London",
        @"希腊（雅典）":@"Europe/Athens",
        @"日本（东京）":@"Asia/Tokyo",
        @"中国（上海）":@"Asia/Shanghai",
        @"马来西亚（吉隆坡）":@"Asia/Kuala_Lumpur",
        @"韩国（首尔）":@"Asia/Seoul",
        @"新加坡": @"Asia/Singapore",
        @"澳大利亚东部时区": @"Australia/Sydney",
        @"澳大利亚中部时区": @"Australia/Darwin",
        @"澳大利亚西部时区": @"Australia/Perth",
        @"新西兰（奥克兰）": @"Pacific/Auckland",
        @"阿联酋（迪拜）":@"Asia/Dubai",
        @"埃及（开罗）":@"Africa/Cairo",
        @"南非（约翰内斯堡）":@"Africa/Johannesburg",
    };
    
}

// TableView dataSource, delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _tableConfigDict[[NSString stringWithFormat:@"section%ld",section]];
    return arr.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Setting" forIndexPath:indexPath];
    NSArray *arr = _tableConfigDict[[NSString stringWithFormat:@"section%ld",indexPath.section]];
    NSDictionary *dict = arr[indexPath.row];
    cell.iconImgV.image = [UIImage imageNamed:dict[@"icon"]];
    cell.titleL.text = dict[@"title"];
    cell.detailL.text = _detailInfoArr[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, view.frame.size.width, 20)];
    label.text = section == 0 ? @"账号": section == 1 ? @"时区设置" : @"个性化设置";
    label.textColor = [UIColor lightGrayColor];
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [self setBGView];
    } else if (indexPath.section == 1) {
        [self setupTimeZone];
    }
    else if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            SchoolViewController *schoolVC = [[SchoolViewController alloc]init];
            [self.navigationController pushViewController:schoolVC animated:YES];
        }
        else {
            __weak typeof(self) wSelf = self;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil  preferredStyle:UIAlertControllerStyleAlert];
            //增加取消按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];

            //增加确定按钮；
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //获取第1个输入框；
                UITextField *userNameTextField = alertController.textFields.firstObject;
                NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                NSString *name = userNameTextField.text;
                [userDef setObject:name forKey:@"Nickname"];
                [AppManager defualtManager].changeNickname = YES;
                wSelf.detailInfoArr[0][0] = name;
                [wSelf.settingTV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
            }]];
                        
            //定义第一个输入框；
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入昵称";
            }];
            
            [self presentViewController:alertController animated:true completion:nil];
            
        }
    }
}

- (void)openPhotos:(UITapGestureRecognizer *)sender {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIImagePickerController *pickerCtr = [[UIImagePickerController alloc] init];
                    pickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    pickerCtr.delegate = self;
                    pickerCtr.allowsEditing = YES;
                    [self presentViewController:pickerCtr animated:YES completion:nil];
                });
            }
        }];
    }
    else if (status == PHAuthorizationStatusAuthorized) {
        UIImagePickerController *pickerCtr = [[UIImagePickerController alloc] init];
        pickerCtr.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerCtr.delegate = self;
        pickerCtr.allowsEditing = YES;
        [self presentViewController:pickerCtr animated:YES completion:nil];
    }
    else {
        NSLog(@"无权访问");
    }
}

- (void)setupTimeZone {
    [self setupPicker];
}

- (void)setBGView {
    BackgroundVC *backgroundVC = [[BackgroundVC alloc]init];
    [self.navigationController pushViewController:backgroundVC animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type = info[@"UIImagePickerControllerMediaType"] ;
    // 获取点击的图片
    if (![type isEqualToString:@"public.image"]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    UIImage *img = info[UIImagePickerControllerEditedImage];
    _iconImgView.image = img;
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:UIImageJPEGRepresentation(img, 1) forKey:@"UserAvatar"];
    [AppManager defualtManager].changeUserAvatar = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// UIPickerView
- (void)setupPicker {
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
    
    typePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(separator.frame), tmpFrame.size.width, tmpFrame.size.height-CGRectGetMaxY(separator.frame))];
    typePV.delegate = self;
    typePV.dataSource = self;
    typePV.showsSelectionIndicator = NO;
    [bgView addSubview:typePV];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _timezoneDict.allKeys.count;
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
    pickerLabel.text = _timezoneDict.allKeys[row];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //    NSString *key = [NSString stringWithFormat:@"%@",_clubList[row]];
    //    [self setupDataInfoView:_clubData[key] clubType:[key intValue]];
}

- (void)cancelAct:(UIButton *)sender {
    [[self.view viewWithTag:107]removeFromSuperview];
}

- (void)confirmAct:(UIButton *)sender {
    NSInteger row = [typePV selectedRowInComponent:0];
    NSString *key = _timezoneDict.allKeys[row];
    NSString *timeZoneStr = _timezoneDict[key];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:@[key, timeZoneStr] forKey:@"TimeZone"];
    [[self.view viewWithTag:107]removeFromSuperview];
    _detailInfoArr[1][0] = key;
    [_settingTV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:(UITableViewRowAnimationNone)];
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
