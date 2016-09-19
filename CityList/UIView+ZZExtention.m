//
//  UIView+ZZExtention.m
//  CityList
//
//  Created by wangZL on 16/9/14.
//  Copyright © 2016年 WangZeLin. All rights reserved.
//

#import "UIView+ZZExtention.h"

@implementation UIView (ZZExtention)
-(void)setLayerBoderColor:(UIColor *)color{
    [self setLayerBoderWidth:1 WithColor:color andCornerRadius:0];
}

-(void)setLayerBoderWidth:(CGFloat)width WithColor:(UIColor *)color andCornerRadius:(CGFloat)radius{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;
}
@end
