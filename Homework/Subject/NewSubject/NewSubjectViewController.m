//
//  NewSubjectViewController.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "NewSubjectViewController.h"
#import "BaseFlowLayout.h"
#import "IconCollectionViewCell.h"

@interface NewSubjectViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *subjectNameTF;
@property (weak, nonatomic) IBOutlet UICollectionView *subjectIconCV;
@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (nonatomic,assign) NSInteger iconIndex;
@property (nonatomic,strong) NSArray *iconArr;
@end

@implementation NewSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加学科";
    _iconIndex = 0;
    // Do any additional setup after loading the view from its nib.
    _subjectNameTF.layer.borderColor = [UIColor blueColor].CGColor;
    _subjectNameTF.layer.borderWidth = 2;
    
    _subjectIconCV.delegate = self;
    _subjectIconCV.dataSource = self;
    _subjectIconCV.collectionViewLayout = [BaseFlowLayout new];
    [_subjectIconCV registerNib:[UINib nibWithNibName:@"IconCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Icon"];
    
    _iconArr = @[@"agriculture",@"animal_science",@"animation_design",@"anteater",@"arabia",@"architecture",@"art_design",@"art",@"astronomy",@"automobile_driving_and_engineering",@"biology",@"business",@"chemistry",@"computer",@"culture_study",@"database_design_and_application",@"drawing_and_painting",@"economy",@"education",@"engineering",@"english",@"environmental_science",@"film",@"finance",@"food_science",@"health",@"history",@"horticulture",@"investment",@"language",@"law",@"literature",@"management",@"math",@"medical_science",@"music",@"news_and_media",@"performance",@"philosophy",@"photography",@"physics",@"politic",@"psychology",@"social_science",@"speaking",@"statistics",@"theater_and_drama",@"trading",@"urban_planning",@"webpage_design",@"writing"];
}

- (IBAction)createAction:(UIButton *)sender {
    NSString *msg = @"";
    if (!_subjectNameTF.text.length) {
        msg = @"请输入科学名称";
    }
    if ([[AppManager defualtManager]checkSubjectNameValid:_subjectNameTF.text] == NO) {
        msg = @"学科名称不能重复,请重新输入";
    }
    NSData *iconData = UIImagePNGRepresentation([UIImage imageNamed:_iconArr[_iconIndex]]);
    BOOL ret = [[AppManager defualtManager]addNewSubject:@{@"name":_subjectNameTF.text, @"icon": iconData, @"createTime": [NSDate date]}];
    if (ret) {
        [self.navigationController popViewControllerAnimated:YES];

        return;
    } else {
        msg = nil;
    }
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"创建失败" message:msg preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _iconArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Icon" forIndexPath:indexPath];
    cell.selectState.hidden = _iconIndex != indexPath.row;
    cell.iconView.image = [UIImage imageNamed:_iconArr[indexPath.row]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ClassHeader" forIndexPath:indexPath];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_iconIndex != indexPath.row) {
        NSArray *arr = @[indexPath, [NSIndexPath indexPathForItem:_iconIndex inSection:0]];
        _iconIndex = indexPath.row;
        [collectionView reloadItemsAtIndexPaths:arr];
    }
    [self hideKeyboard];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [_subjectNameTF resignFirstResponder];
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
