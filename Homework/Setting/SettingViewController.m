//
//  SettingViewController.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "SettingViewController.h"
#import "BackgroundVC.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *zoneNames = [NSTimeZone knownTimeZoneNames];
    NSLog(@"name:%@",zoneNames);
    
}

- (IBAction)setupTimeZone:(UIButton *)sender {
    
}

- (IBAction)setBGView:(UIButton *)sender {
    BackgroundVC *backgroundVC = [[BackgroundVC alloc]init];
    [self.navigationController pushViewController:backgroundVC animated:YES];
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
