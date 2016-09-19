//
//  CityListHotCell.m
//  Apin
//
//  Created by wangZL on 16/9/8.
//  Copyright © 2016年 Apin. All rights reserved.
//

#import "CityListHotCell.h"
#import "HotCollectionViewCell.h"
#import "CityModel.h"
#import "SystemConfig.h"
@implementation CityListHotCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self initCollectionView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(CGFloat)getCellHeight:(NSMutableArray *)array{
    return (1+array.count/3)*26 + 15*array.count/3 + 9 + 25;
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    self.mainCollectionView.frame = CGRectMake(0, 0, KScreenW-10, (1+self.dataArray.count/3)*26 + 15*self.dataArray.count/3 + 9 + 15);
    [self.mainCollectionView reloadData];
}
-(void)initCollectionView{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.itemSize = CGSizeMake(90*KScale6S, 26);
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 27;
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenW-10, (1+self.dataArray.count/3)*26 + 15*self.dataArray.count/3 + 9 + 15) collectionViewLayout:layout];
    self.mainCollectionView.backgroundColor = [UIColor clearColor];
    [self.mainCollectionView registerClass:[HotCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    self.mainCollectionView.delegate= self;
    self.mainCollectionView.dataSource = self;
    self.mainCollectionView.showsVerticalScrollIndicator = NO;
    self.mainCollectionView.scrollEnabled = NO;
    [self.contentView addSubview:self.mainCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%ld",_dataArray.count);
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HotCollectionViewCell *cell = (HotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    //cell.botlabel.text = [NSString stringWithFormat:@"{%ld,%ld}",(long)indexPath.section,(long)indexPath.row];
    //cell.backgroundColor = [UIColor yellowColor];
    CityModel *model = _dataArray[indexPath.row];
    cell.cityLabel.text = model.city_name;
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(9, 20, 25, 20);
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90*KScale6S, 26);
}
//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectHotCity) {
        self.selectHotCity(indexPath.row);
    }
    NSLog(@"%ld",indexPath.row);
}
@end
