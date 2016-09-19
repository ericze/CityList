//
//  SystemConfig.h
//  CityList
//
//  Created by wangZL on 16/9/14.
//  Copyright © 2016年 WangZeLin. All rights reserved.
//

#ifndef SystemConfig_h
#define SystemConfig_h

#define KScreenH  ([[UIScreen mainScreen] bounds].size.height)
#define KScreenW  ([[UIScreen mainScreen] bounds].size.width)

#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
//通用字体颜色(黑色)
#define TextBlackColor UIColorFromHex(0x141d2f)

#define KScale5S  (KScreenW/320)
#define KScale6S (KScreenW/375)
#endif /* SystemConfig_h */
