//
//  BackgroundVC.m
//  Homework
//
//  Created by 牛晨雨 on 2020/8/22.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "BackgroundVC.h"
#import "BaseFlowLayout.h"
#import "BackgoundCViewCell.h"
#import "CollectionHeader.h"

@interface BackgroundVC () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (nonatomic,copy) NSArray *keys;
@property (nonatomic,copy) NSDictionary *backgroundDict;
@property (nonatomic, strong) NSIndexPath *selIndexPath;

@end

@implementation BackgroundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _selIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self setupNavigationBar];
    
    // Do any additional setup after loading the view from its nib.
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = [BaseFlowLayout new];
    CGFloat width = _collectionView.frame.size.width;
    CGFloat itemWidth = (width - (4*(3+1)))/3;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    layout.headerReferenceSize = CGSizeMake(layout.itemSize.width, 20);

//    layout.
    _collectionView.collectionViewLayout = layout;
    [_collectionView registerNib:[UINib nibWithNibName:@"BackgoundCViewCell" bundle:nil] forCellWithReuseIdentifier:@"Background"];
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BackgroundHeader"];
    _backgroundDict = @{
        @"City": @[@"city01",@"city02",@"city03",@"city04",@"city05"],
        @"Nature":@[@"nature01",@"nature02",@"nature03",@"nature06",@"nature13",@"nature14",@"nature15"],
        @"Pure":@[@"pure01",@"pure02",@"pure03",@"pure04"],
        @"Scene":@[@"scene01",@"scene02",@"scene03",@"scene04",@"scene07"],
        @"Star":@[@"star03",@"star05",@"star08",@"star11",@"star12"]};
}

- (void)setupNavigationBar {
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:(@"确认修改") style:(UIBarButtonItemStyleDone) target:self action:@selector(changeBackgroundViewConfirm:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)changeBackgroundViewConfirm:(UIBarButtonItem *)sender {
    NSArray *arr = _backgroundDict.allKeys;
    NSString *bgImgName = _backgroundDict[arr[_selIndexPath.section]][_selIndexPath.row];
    NSLog(@"修改为:%@",bgImgName);
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:bgImgName forKey:@"BackgroundImg"];
    [user setBool:YES forKey:@"ChangeBackgrounImg"];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _backgroundDict.allKeys.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arr = _backgroundDict.allKeys;
    return [_backgroundDict[arr[section]]count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BackgoundCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Background" forIndexPath:indexPath];
    cell.selectStateImgV.hidden = (_selIndexPath.row != indexPath.row || _selIndexPath.section != indexPath.section);
    NSArray *arr = _backgroundDict.allKeys;
    cell.imgView.image = [UIImage imageNamed:_backgroundDict[arr[indexPath.section]][indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    CollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BackgroundHeader" forIndexPath:indexPath];
    header.categoryL.text = _backgroundDict.allKeys[indexPath.section];
    header.backgroundColor = [UIColor lightGrayColor];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selIndexPath.row != indexPath.row || _selIndexPath.section != indexPath.section) {
        NSArray *arr = @[indexPath, _selIndexPath.copy];
        _selIndexPath = indexPath;
        [collectionView reloadItemsAtIndexPaths:arr];
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
