//
//  HotCollectionViewCell.m
//  Apin
//
//  Created by wangZL on 16/9/8.
//  Copyright © 2016年 Apin. All rights reserved.
//

#import "HotCollectionViewCell.h"
#import "SystemConfig.h"
#import "UIView+ZZExtention.h"
@implementation HotCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self layoutUI];
    }
    return self;
}
-(void)layoutUI{
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90*KScale6S, 26)];
    [self.cityLabel setLayerBoderColor:TextBlackColor];
    self.cityLabel.font = [UIFont systemFontOfSize:13];
    self.cityLabel.textColor = TextBlackColor;
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.cityLabel];
}
@end
