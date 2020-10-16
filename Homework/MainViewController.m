//
//  MainViewController.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/19.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "MainViewController.h"
#import "SubjectTableView.h"
#import "NewSubjectViewController.h"
#import "SettingViewController.h"
#import "UIButton+EnlargeTouchArea.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameL;
@property (weak, nonatomic) IBOutlet SubjectTableView *subjectTV;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *schoolLogoImgV;
@property (weak, nonatomic) IBOutlet UILabel *schoolNameL;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Duelendar";
    [self setupNavigationBar];
    _subjectTV.mainVC = self;
    [_settingButton setEnlargeEdgeWithTop:15 right:15 bottom:15 left:15];
    
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    NSData *imgData = [userDef objectForKey:@"UserAvatar"];
    _iconView.image = [UIImage imageWithData:imgData];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 20;
    
    NSString *name = [userDef objectForKey:@"SchoolName"];
    _schoolNameL.text = name;
    _schoolLogoImgV.image = [UIImage imageNamed:name];
    _nicknameL.text = [userDef objectForKey:@"Nickname"];
    
    NSString *bgImgName = [userDef objectForKey:@"BackgroundImg"];
    if (!bgImgName) {
        bgImgName = @"city01";
    }
    _bgImgView.image = [UIImage imageNamed:bgImgName];
    
    NSString *appVersion = [userDef objectForKey:@"AppVersion"];
    NSString *curVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    if ([appVersion isEqualToString:curVersion] == NO) {
        [userDef setObject:curVersion forKey:@"AppVersion"];
        __weak typeof(self) wself = self;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Duelendar" message:@"欢迎使用Duelendar,请前往设置界面,设置您的个人信息" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            SettingViewController *settingVC = [[SettingViewController alloc]init];
            [wself.navigationController pushViewController:settingVC animated:YES];
        }];
        [alertC addAction:action];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [wself presentViewController:alertC animated:YES completion:nil];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([AppManager defualtManager].changeBackgroundImg == YES) {
        [AppManager defualtManager].changeBackgroundImg = NO;
        NSString *bgImgName = [user objectForKey:@"BackgroundImg"];
        _bgImgView.image = [UIImage imageNamed:bgImgName];
    }
    if ([AppManager defualtManager].addSubjectFlag) {
        [AppManager defualtManager].addSubjectFlag = NO;
        [_subjectTV reloadData];
    }
    if ([AppManager defualtManager].changeSchoolName == YES) {
        [AppManager defualtManager].changeSchoolName = NO;
        NSString *name = [user objectForKey:@"SchoolName"];
        _schoolNameL.text = name;
        _schoolLogoImgV.image = [UIImage imageNamed:name];
    }
    if ([AppManager defualtManager].changeUserAvatar == YES) {
        [AppManager defualtManager].changeUserAvatar = NO;
        NSData *imgData = [user objectForKey:@"UserAvatar"];
        _iconView.image = [UIImage imageWithData:imgData];
    }
    if ([AppManager defualtManager].changeNickname == YES) {
        [AppManager defualtManager].changeNickname = NO;
        _nicknameL.text = [user objectForKey:@"Nickname"];
    }
}

- (void)setupNavigationBar {
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [moreBtn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(addSubjectAction:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *moreBarBtn = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = moreBarBtn;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]}];
}

- (IBAction)settingAction:(UIButton *)sender {
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

/*
- (void)setupView {
//    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize size = self.view.frame.size;
    // header view
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height * .3)];
    headerView.backgroundColor = RGB(46, 37, 28, 1);
    [self.view addSubview:headerView];
    
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    iconView.frame = CGRectMake(30, WD_TopHeight + 30, 80, 80);
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 40;
    [self.view addSubview:iconView];
    
    UILabel *userNameL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 20, 0, size.width - CGRectGetMaxX(iconView.frame) - 20, iconView.frame.size.height)];
    userNameL.text = @"Tilly Liu";
    [self.view addSubview:userNameL];
    userNameL.center = CGPointMake(userNameL.center.x, iconView.center.y);
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + 40, size.width*.8, 100)];
    middleView.backgroundColor = RGB(238, 228, 210, 1);
    middleView.layer.masksToBounds = YES;
    middleView.layer.cornerRadius = 30;
    [self.view addSubview:middleView];
    middleView.center = CGPointMake(self.view.center.x, middleView.center.y);
    
//    UILabel *titleL = [UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(iconView.frame), CGRectGetMaxY(middleView.frame) + 20, <#CGFloat width#>, <#CGFloat height#>)
    
    NSString *bgImgName = [[NSUserDefaults standardUserDefaults] objectForKey:@"BackgroundImg"];
    if (!bgImgName) {
        bgImgName = @"city01";
    }
    _bgImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:bgImgName]];
    _bgImgView.frame = self.view.frame;
    [self.view addSubview:_bgImgView];
        
    CGFloat height = WD_TopHeight + 100;
    // table view
    _subjectTV = [[SubjectTableView alloc]initWithFrame:CGRectMake(0, height, CGRectGetWidth(self.view.frame), self.view.frame.size.height - height - 64) style:(UITableViewStyleGrouped)];
    _subjectTV.mainVC = self;
    _subjectTV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_subjectTV];
    
    UIButton *addSubjectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(subjectTV.frame), CGRectGetWidth(self.view.frame), self.view.frame.size.height - CGRectGetMaxY(subjectTV.frame))];
    addSubjectBtn.backgroundColor = [UIColor whiteColor];
    [addSubjectBtn setTitle:@"添加学科" forState:(UIControlStateNormal)];
    [addSubjectBtn setTitleColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    [addSubjectBtn addTarget:self action:@selector(addSubjectAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addSubjectBtn];
}
 */

- (void)addSubjectAction:(UIButton *)sender {
    NewSubjectViewController *newSubjectVC = [[NewSubjectViewController alloc]init];
    [self.navigationController pushViewController:newSubjectVC animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
