//
//  CityListLocationCell.h
//  Apin
//
//  Created by wangZL on 16/9/7.
//  Copyright © 2016年 Apin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CityListLocationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationCityLabel;
@property(nonatomic,copy) void (^selectLoaction) (void);
@end
