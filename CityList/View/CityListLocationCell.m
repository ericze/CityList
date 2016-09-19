//
//  CityListLocationCell.m
//  Apin
//
//  Created by wangZL on 16/9/7.
//  Copyright © 2016年 Apin. All rights reserved.
//

#import "CityListLocationCell.h"
#import "UIView+ZZExtention.h"
#import "SystemConfig.h"
@implementation CityListLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.locationCityLabel setLayerBoderColor:TextBlackColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
     self.locationCityLabel.frame = CGRectMake(20, 9, 90*KScale6S, 26);
    // Initialization code
//    CGSize titleSize = [titleLabel.text boundingRectWithSize:CGSizeMake(300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes1 context:nil].size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.selectLoaction) {
        self.selectLoaction();
    }
    // Configure the view for the selected state
}

@end
