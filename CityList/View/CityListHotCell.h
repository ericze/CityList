//
//  CityListHotCell.h
//  Apin
//
//  Created by wangZL on 16/9/8.
//  Copyright © 2016年 Apin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityListHotCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,copy) void (^selectHotCity) (NSInteger row);
-(CGFloat)getCellHeight:(NSMutableArray *)array;
@end
