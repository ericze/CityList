//
//  ViewController.m
//  CityList
//
//  Created by wangZL on 16/9/12.
//  Copyright © 2016年 WangZeLin. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ZZExtention.h"
#import "SystemConfig.h"
#import "CityListCell.h"
#import "CityListLocationCell.h"
#import "CityListHotCell.h"
#import "CityModel.h"
#import "MJExtension.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
@property (strong, nonatomic)  UITableView *domesticTable;
@property (strong, nonatomic)  UIScrollView *backScrollView;
@property (strong, nonatomic) UIButton *domesticButton;
@property (strong, nonatomic) UIButton *internationalButton;
@property (strong, nonatomic) UIView *secondView;
//索引相关
@property(nonatomic,strong)NSMutableArray *suoyinArray;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UIScrollView *scrollView;
@property (strong, nonatomic)  UITableView *internationalTable;

//搜索相关
@property(nonatomic,strong)NSMutableArray *searchArray;
@property(nonatomic,assign)BOOL isSearch;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UITableView *searchResultTableView;
/**存放经过处理之后的数据的二维数组*/
@property(nonatomic,strong)NSMutableArray *chinaArray;
@property(nonatomic,strong)NSMutableArray *nationArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:TextBlackColor];
    self.view.backgroundColor = UIColorFromHex(0xffffff);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self arrayAlloc];
    [self configIndexData];
    [self configScrollView];
    [self configTableView];
    [self configTopButtons];
    [self configSearch];
    [self InitializationData];
}
-(void)arrayAlloc{
    self.chinaArray = [NSMutableArray array];
    self.nationArray = [NSMutableArray array];
}
-(void)configScrollView{
    self.backScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.backScrollView];
    self.backScrollView.frame = CGRectMake(0, 126, KScreenW, KScreenH-126);
    self.backScrollView.backgroundColor = [UIColor redColor];
    self.backScrollView.contentSize = CGSizeMake(KScreenW*2, KScreenH-126);
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.scrollEnabled = NO;
    //self.backScrollView.backgroundColor = BackgrondGray;
    self.backScrollView.delegate = self;
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.delegate = self;
}
-(void)configTableView{
    self.domesticTable = [self initializationTableWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-126)];
    [self.backScrollView addSubview:self.domesticTable];
    self.internationalTable = [self initializationTableWithFrame:CGRectMake(KScreenW, 0, KScreenW, KScreenH-126)];
    [self.backScrollView addSubview:self.internationalTable];
}

-(void)configTopButtons{
    self.domesticButton = [self initializationButtonWithFrame:CGRectMake(20*KScale5S, 74, 140*KScale5S, 32)];
    self.internationalButton = [self initializationButtonWithFrame:CGRectMake(160*KScale5S, 74, 140*KScale5S, 32)];
    [self.domesticButton setBackgroundColor:TextBlackColor];
    [self.internationalButton setBackgroundColor:UIColorFromHex(0xffffff)];
    [self.view addSubview:self.domesticButton];
    [self.view addSubview:self.internationalButton];
    [self.domesticButton setTitle:@"国内" forState:UIControlStateNormal];
    [self.internationalButton setTitle:@"国际" forState:UIControlStateNormal];
    self.domesticButton.selected = YES;
    [self.domesticButton addTarget:self action:@selector(domestic:) forControlEvents:UIControlEventTouchUpInside];
    [self.internationalButton addTarget:self action:@selector(international:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)configSearch{
    self.searchArray = [[NSMutableArray alloc] init];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"  请输入国内 / 国际城市中英文或拼音";
    self.searchBar.showsCancelButton = YES;
   
    //删除searchBar的两条黑线
    for (UIView *obj in [self.searchBar subviews]) {
        for (UIView *objs in [obj subviews]) {
            if ([objs isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
                [objs removeFromSuperview];
            }
        }
        if ([obj isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            [obj removeFromSuperview];
        }
    }
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
 //   self.domesticTable.tableHeaderView = self.searchBar;
    [self.searchBar setImage:[UIImage imageNamed:@"citySearch"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarImage"] forState:UIControlStateNormal];

    self.searchResultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KScreenW, KScreenH-64) style:UITableViewStylePlain];
    self.searchResultTableView.delegate = self;
    self.searchResultTableView.dataSource = self;
    self.searchResultTableView.hidden = YES;
    [self.view addSubview:self.searchResultTableView];
    //self.searchResultTableView.tableHeaderView = self.searchBar;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self valueChanged:searchText];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearch = NO;
    self.searchBar.text = @"";
    self.searchResultTableView.hidden = YES;
    [self.searchBar endEditing:YES];
}
//搜索城市
-(void)valueChanged:(NSString *)searchString{
    
    NSLog(@"textField.text :%@",searchString);
    if ([searchString isEqualToString:@""]) {
        self.isSearch = NO;
        self.searchResultTableView.hidden = YES;
        return;
    }else{
        self.isSearch = YES;
        self.searchResultTableView.hidden = NO;
    }
    [self.searchArray removeAllObjects];
    //如果输入是一位,判断是否是中文的第一位,以及拼音首字母
    if (searchString.length==1) {
        for (CityModel *model in self.dataArray) {
            if ([model.city_name rangeOfString:searchString].location == 0) {
                [self.searchArray addObject:model];
                continue;
            }
            NSString *lowString = searchString.lowercaseString;
            NSString *uperSting = searchString.uppercaseString;
            if ([model.pinyin_first isEqualToString:lowString]|[model.pinyin_first isEqualToString:uperSting]) {
                [self.searchArray addObject:model];
                continue;
            }
        }
    }else{
        for (CityModel *model in self.dataArray) {
            if ([model.city_name rangeOfString:searchString].location != NSNotFound) {
                [self.searchArray addObject:model];
                continue;
            }
            if ([model.pinyin_headers rangeOfString:searchString].location != NSNotFound) {
                [self.searchArray addObject:model];
                continue;
            }
            if ([model.full_pinyin rangeOfString:searchString].location != NSNotFound) {
                [self.searchArray addObject:model];
                continue;
            }
        }
    }
    
    [self.searchResultTableView reloadData];
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    self.isSearch = NO;
    [self.domesticTable reloadData];
    return YES;
}
//初始化城市数据
-(void)InitializationData{
    NSError *error;
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"city"ofType:@"json"];
    
    //根据文件路径读取数据
    NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
    
    //格式化成json数据
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:&error];

    NSArray *tempArray = jsonObject[@"RECORDS"];
    NSLog(@"%@",tempArray[0]);
    self.dataArray = [CityModel objectArrayWithKeyValuesArray:tempArray];
    [self handleData];
}
-(void)handleData{
    //定位城市
    for (CityModel *model  in self.dataArray) {
        if ([model.city_name isEqualToString: @"杭州"]) {
            NSArray *arr = @[model];
            [self.chinaArray addObject:arr];
            [self.nationArray addObject:arr];
            break;
        }
    }
    //中国热门城市
    NSMutableArray *chinaHotArray = [[NSMutableArray alloc] init];
    for (CityModel *model in self.dataArray) {
        if ([model.abroad isEqualToString:@"0"]) {
            if ([model.pinji_hot_tag isEqualToString:@"1" ]) {
                [chinaHotArray addObject:model];
            }
        }
    }
    [self.chinaArray addObject:chinaHotArray];
    //国内其他城市
    for (NSInteger i=0;i<=25; i++) {
        char a = 'A'+i;
        NSString *tempA = [NSString stringWithFormat:@"%c",a];
        NSMutableArray *charArray = [[NSMutableArray alloc] init];
        for (CityModel *model in self.dataArray) {
            if ([model.abroad isEqualToString:@"0"]) {
                if ([model.pinyin_first isEqualToString:tempA]) {
                    [charArray addObject:model];
                }
            }
        }
        [self.chinaArray addObject:charArray];
    }
    [self.domesticTable reloadData];
    //国外热门城市
    NSMutableArray *nationHotArray = [[NSMutableArray alloc] init];
    for (CityModel *model in self.dataArray) {
        if ([model.abroad isEqualToString:@"1"]) {
            if ([model.pinji_hot_tag isEqualToString:@"1" ]) {
                [nationHotArray addObject:model];
            }
        }
    }
    [self.nationArray addObject:nationHotArray];
    //国外A->Z
    //其他城市
    for (NSInteger i=0;i<=25; i++) {
        char a = 'A'+i;
        NSString *tempA = [NSString stringWithFormat:@"%c",a];
        NSMutableArray *charArray = [[NSMutableArray alloc] init];
        for (CityModel *model in self.dataArray) {
            if ([model.abroad isEqualToString:@"1"]) {
                if ([model.pinyin_first isEqualToString:tempA]) {
                    [charArray addObject:model];
                }
            }
        }
        [self.nationArray addObject:charArray];
    }
    
    [self.internationalTable reloadData];
}
-(void)configIndexData{
    self.suoyinArray = [[NSMutableArray alloc] init];
    [self.suoyinArray addObject:@"!"];
    [self.suoyinArray addObject:@"#"];
    for (char c = 'A'; c<='Z'; c++) {
        [self.suoyinArray addObject:[NSString stringWithFormat:@"%c",c]];
    }
}

-(UIButton *)initializationButtonWithFrame:(CGRect )frame{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateSelected];
    [button setLayerBoderColor:TextBlackColor];
    [button setTitleColor:TextBlackColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    return button;
}
-(UITableView *)initializationTableWithFrame:(CGRect )frame{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = YES;
    tableView.showsVerticalScrollIndicator = NO;
    //设置索引列文本的颜色
    tableView.sectionIndexColor = TextBlackColor;
    tableView.sectionIndexBackgroundColor=[UIColor clearColor];
    [tableView registerNib:[UINib nibWithNibName:@"CityListCell" bundle:nil] forCellReuseIdentifier:@"cityCell"];
    [tableView registerNib:[UINib nibWithNibName:@"CityListLocationCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
    [tableView registerClass:[CityListHotCell class] forCellReuseIdentifier:@"hotCell"];
    return tableView;
}
#pragma mark - action
- (void)domestic:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
        sender.selected = YES;
        sender.backgroundColor = UIColorFromHex(0x141d2f);
        self.internationalButton.selected = NO;
        self.internationalButton.backgroundColor = UIColorFromHex(0xffffff);
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.backScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void)international:(UIButton *)sender {
    if (sender.selected) {
        return;
    }else{
        sender.selected = YES;
        sender.backgroundColor = UIColorFromHex(0x141d2f);
        self.domesticButton.selected = NO;
        self.domesticButton.backgroundColor = UIColorFromHex(0xffffff);
        [self.scrollView setContentOffset:CGPointMake(-KScreenW/2, 0) animated:YES];
        [self.backScrollView setContentOffset:CGPointMake(KScreenW, 0) animated:YES];
    }
}
#pragma mark-tableViewDataSource&Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CityModel *model;
    if (tableView==_domesticTable) {
        model = self.chinaArray[indexPath.section][indexPath.row];
    }else if (tableView==self.internationalTable){
        model = self.nationArray[indexPath.section][indexPath.row];
    }else if (tableView==self.searchResultTableView){
        model = self.searchArray[indexPath.row];
    }
    if (self.cityBlock) {
        self.cityBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CityModel *model;
    if (tableView==self.domesticTable) {
        model = self.chinaArray[indexPath.section][indexPath.row];
        if (indexPath.section==0) {
            //第一个section是定位城市
            CityListLocationCell *locationCell = [self.domesticTable dequeueReusableCellWithIdentifier:@"locationCell"];
            
            __weak ViewController *weakSelf = self;
            //选择当前定位城市的回调
            locationCell.selectLoaction = ^{
                CityModel *model;
                model = weakSelf.chinaArray[0][0];
                if (weakSelf.cityBlock) {
                    weakSelf.cityBlock(model);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            locationCell.locationCityLabel.text = model.city_name;
            return locationCell;
        }else if (indexPath.section==1){
            //第二个section是热门城市,在cell上放了一个collectionView
            CityListHotCell *hotCell = [self.internationalTable dequeueReusableCellWithIdentifier:@"hotCell"];
            __weak ViewController *weakSelf = self;
            hotCell.selectHotCity = ^(NSInteger collectRow){
                CityModel *model;
                model = weakSelf.chinaArray[1][collectRow];
                if (weakSelf.cityBlock) {
                    weakSelf.cityBlock(model);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
            };
            hotCell.dataArray = self.chinaArray[indexPath.section];
            return hotCell;
        }
    }else if (tableView==self.internationalTable){
        model = self.nationArray[indexPath.section][indexPath.row];
        if (indexPath.section==0) {
            //第一个section是定位城市
            CityListLocationCell *locationCell = [self.internationalTable dequeueReusableCellWithIdentifier:@"locationCell"];
            locationCell.locationCityLabel.text = model.city_name;
            __weak ViewController *weakSelf = self;
            //选择当前定位城市的回调
            locationCell.selectLoaction = ^{
                CityModel *model;
                model = weakSelf.chinaArray[0][0];
                if (weakSelf.cityBlock) {
                    weakSelf.cityBlock(model);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            return locationCell;
        }else if (indexPath.section==1){
            //第二个section是热门城市,在cell上放了一个collectionView
            CityListHotCell *hotCell = [self.internationalTable dequeueReusableCellWithIdentifier:@"hotCell"];
            __weak ViewController *weakSelf = self;
            hotCell.selectHotCity = ^(NSInteger collectRow){
                CityModel *model;
                model = weakSelf.nationArray[1][collectRow];
                if (weakSelf.cityBlock) {
                    weakSelf.cityBlock(model);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
            };
            hotCell.dataArray = self.nationArray[indexPath.section];
            return hotCell;
        }
    }else if (tableView==self.searchResultTableView){
        model = self.searchArray[indexPath.row];
    }
    
    CityListCell *cell = [self.internationalTable dequeueReusableCellWithIdentifier:@"cityCell"];
    cell.cityLabel.text = model.city_name;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.domesticTable) {
        NSArray *arr = self.chinaArray[section];
        if (section==1) {
            return 1;
        }
        return arr.count;
    }else if (tableView==self.internationalTable){
        NSArray *arr = self.nationArray[section];
        if (section==1) {
            return 1;
        }
        return arr.count;
    }else if (tableView==self.searchResultTableView){
        if (self.searchArray.count==0) {
            self.searchResultTableView.hidden = YES;
        }else{
            self.searchResultTableView.hidden = NO;
        }
        return self.searchArray.count;
    }
    return 0;
}
//返回索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView==self.domesticTable) {
        return self.suoyinArray;
    }else if (tableView==self.internationalTable){
        return self.suoyinArray;
    }
    return nil;
}
//索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    NSLog(@"%@-%ld",title,index);
    for (NSString *character in self.suoyinArray) {
        if ([character isEqualToString:title]) {
            return count;
        }
        count++;
    }
    return 0;
    //    //点击索引，列表跳转到对应索引的行
    //
    //    [tableView
    //     scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index+4]
    //     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //
    //
    //
    //    //弹出首字母提示
    //
    //    //[self showLetter:title ];
    //
    //    return index+4;
    
}
//返回section的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==self.domesticTable) {
        return self.chinaArray.count;
    }else if (tableView==self.internationalTable){
        return self.nationArray.count;
    }else if(tableView==self.searchResultTableView){
        return 1;
    }else{
        return 0;
    }
}
//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView==self.searchResultTableView) {
        return nil;
    }
    return self.suoyinArray[section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==self.domesticTable|tableView==self.internationalTable) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, 26)];
        headView.backgroundColor = UIColorFromHex(0xf8f8f8);
        //标题文字
        UILabel *lblBiaoti = [[UILabel alloc]init];
        lblBiaoti.backgroundColor = [UIColor clearColor];
        lblBiaoti.textAlignment = NSTextAlignmentLeft;
        lblBiaoti.font = [UIFont systemFontOfSize:12];
        lblBiaoti.textColor = TextBlackColor;
        
        lblBiaoti.frame = CGRectMake(20, 0, 200, 26);
        lblBiaoti.text = self.suoyinArray[section];
        if (section==0) {
            lblBiaoti.text = @"定位城市";
        }else if (section==1){
            lblBiaoti.text = @"热门城市";
        }
        [headView addSubview:lblBiaoti];
        
        //        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,  26-1,KScreenW, 1)];
        //        lineView.backgroundColor = LayerGray;
        //        [headView addSubview:lineView];
        return headView;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==self.searchResultTableView) {
        return 0;
    }
    return 26;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CityModel *model;
    if (tableView==self.domesticTable) {
        model = self.chinaArray[indexPath.section][indexPath.row];
        if (indexPath.section==0) {
            //第一个section是定位城市
            return 60;
        }else if (indexPath.section==1){
            CityListHotCell *hotCell = [self.internationalTable dequeueReusableCellWithIdentifier:@"hotCell"];
            return [hotCell getCellHeight:self.chinaArray[indexPath.section]];
        }
    }else if (tableView==self.internationalTable){
        model = self.nationArray[indexPath.section][indexPath.row];
        if (indexPath.section==0) {
            return 60;
        }else if (indexPath.section==1){
            //第二个section是热门城市,在cell上放了一个collectionView
            CityListHotCell *hotCell = [self.internationalTable dequeueReusableCellWithIdentifier:@"hotCell"];
            return [hotCell getCellHeight:self.nationArray[indexPath.section]];
        }
    }
    return 33*KScale5S;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar endEditing:YES];
    
    [self.searchBar resignFirstResponder];
}
@end
