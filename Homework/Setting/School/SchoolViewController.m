//
//  SchoolViewController.m
//  Homework
//
//  Created by 牛晨雨 on 2020/9/5.
//  Copyright © 2020 牛晨雨. All rights reserved.
//

#import "SchoolViewController.h"
#import "SchoolTableViewCell.h"

@interface SchoolViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *schoolList;
@property (weak, nonatomic) IBOutlet UITableView *schoolTableView;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation SchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择大学";
    [self setupNavigationBar];
    // Do any additional setup after loading the view from its nib.
    _schoolList = @[@"美国阿姆斯特丹大学",@"美国埃隆大学",@"美国埃默里大学",@"美国爱荷华大学",@"美国鲍登学院",@"美国北卡罗来纳大学教堂山分校",@"美国北卡罗来纳州立大学",@"美国贝勒大学",@"美国宾夕法尼亚大学",@"美国宾夕法尼亚州立大学",@"美国波莫纳学院",@"美国波士顿大学",@"美国波士顿学院",@"美国伯克利音乐学院",@"美国布兰迪斯大学",@"美国布朗大学",@"美国达特茅斯学院",@"美国戴维森学院",@"美国丹佛大学",@"美国德克萨斯大学奥斯汀分校",@"美国德克萨斯基督教大学",@"美国德州农工大学",@"美国东北大学",@"美国杜克大学",@"美国杜兰大学",@"美国俄亥俄州立大学哥伦布分校",@"美国范德堡大学",@"美国弗吉尼亚大学",@"美国弗吉尼亚理工学院",@"美国佛罗里达大学",@"美国佛罗里达州立大学",@"美国哥伦比亚大学",@"美国贡萨加大学",@"美国哈佛大学",@"美国华盛顿大学",@"美国华盛顿大学圣路易斯分校",@"美国加州大学伯克利分校",@"美国加州大学戴维斯分校",@"美国加州大学尔湾分校",@"美国加州大学河滨分校",@"美国加州大学洛杉矶分校",@"美国加州大学圣芭芭拉分校",@"美国加州大学圣地亚哥分校",@"美国加州大学圣克鲁兹分校",@"美国加州理工大学",@"美国旧金山音乐学院",@"美国卡尔顿学院",@"美国卡耐基梅隆大学",@"美国凯斯西储大学",@"美国康奈尔大学",@"美国康涅狄格大学",@"美国柯蒂斯音乐学院",@"美国科罗拉多矿业大学",@"美国克拉克大学",@"美国克莱蒙特麦肯纳学院",@"美国克莱姆森大学",@"美国莱斯大学",@"美国理海大学",@"美国伦斯勒理工学院",@"美国罗彻斯特大学",@"美国罗格斯大学",@"美国麻省理工学院",@"美国马凯特大学",@"美国马里兰大学帕克分校",@"美国马萨诸塞大学安姆斯特分校",@"美国迈阿密大学",@"美国迈阿密大学牛津分校",@"美国曼哈顿音乐学院",@"美国美利坚大学",@"美国密歇根大学安娜堡分校",@"美国密歇根州立大学",@"美国明德学院",@"美国明尼苏达大学双城校区",@"美国南加州大学",@"美国南卫理公会大学",@"美国纽约大学",@"美国纽约大学水牛城分校",@"美国纽约州立大学宾汉姆顿分校",@"美国纽约州立大学石溪分校",@"美国佩珀代因大学",@"美国匹兹堡大学",@"美国普渡大学",@"美国普林斯顿大学",@"美国乔治城大学",@"美国乔治华盛顿大学",@"美国圣地亚哥大学",@"美国圣母大学",@"美国圣塔克拉拉大学",@"美国斯坦福大学",@"美国斯沃斯莫尔大学",@"美国塔夫茨大学",@"美国特拉华大学",@"美国威廉玛丽学院",@"美国威廉姆斯学院",@"美国威斯康星大学麦迪逊分校",@"美国维克森林大学",@"美国维拉诺瓦大学",@"美国维斯里学院",@"美国伍斯特理工学院",@"美国西北大学",@"美国新英格兰音乐学院",@"美国新泽西理工学院",@"美国雪城大学",@"美国杨百翰大学",@"美国耶鲁大学",@"美国叶史瓦大学",@"美国伊利诺伊大学香槟分校",@"美国印第安纳大学布卢明顿分校",@"美国约翰霍普金斯大学",@"美国芝加哥大学",@"美国茱莉亚学院",@"美国佐治亚理工学院",@"英国爱丁堡大学",@"英国布里斯托尔大学",@"英国华威大学",@"英国皇家音乐学院",@"英国剑桥大学",@"英国伦敦大学学院",@"英国伦敦帝国学院",@"英国伦敦国王学院",@"英国伦敦政治经济学院",@"英国曼彻斯特大学",@"英国牛津大学",@"加拿大不列颠哥伦比亚大学",@"加拿大多伦多大学",@"加拿大麦吉尔大学",@"阿根廷布宜诺斯艾利斯大学",@"丹麦哥本哈根大学",@"瑞士洛桑联邦理工学院",@"瑞士苏黎世大学",@"新加坡国立大学",@"新加坡南洋理工大学",@"荷兰代尔夫特理工大学",@"马来西亚马来亚大学",@"澳大利亚国立大学",@"澳大利亚昆士兰大学",@"澳大利亚蒙纳士大学",@"澳大利亚墨尔本大学",@"澳大利亚悉尼大学",@"澳大利亚新南威尔士大学",@"日本大阪大学",@"日本东京大学",@"日本东京理科大学",@"日本京都大学",@"韩国高丽大学",@"韩国科学技术院",@"韩国浦项科技大学",@"韩国首尔大学",@"俄罗斯莫斯科国立大学",@"法国巴黎科学艺术人文大学",@"法国巴黎综合理工学院",@"德国海德堡大学",@"德国慕尼黑大学",@"德国慕尼黑工业大学"];
    
    _schoolTableView.delegate = self;
    _schoolTableView.dataSource = self;
    [_schoolTableView registerNib:[UINib nibWithNibName:@"SchoolTableViewCell" bundle:nil] forCellReuseIdentifier:@"School"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *schoolName = [user objectForKey:@"SchoolName"];
    NSInteger ret = [_schoolList indexOfObject:schoolName];
    if (ret != NSNotFound) {
        _selectedIndex = ret;
    }
}

- (void)setupNavigationBar {
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:(@"确认修改") style:(UIBarButtonItemStyleDone) target:self action:@selector(changeBackgroundViewConfirm:)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

- (void)changeBackgroundViewConfirm:(UIBarButtonItem *)sender {
    NSString *name = _schoolList[_selectedIndex];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:name forKey:@"SchoolName"];
    [AppManager defualtManager].changeSchoolName = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _schoolList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"School" forIndexPath:indexPath];
    cell.accessoryType = _selectedIndex == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    NSString *name = _schoolList[indexPath.row];
    cell.nameL.text = name;
    cell.iconImgView.image = [UIImage imageNamed:name];
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
    if (_selectedIndex != indexPath.row) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
        _selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:@[lastIndexPath, indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    }
//    NSLog(@"indexPath:%@",indexPath);
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
