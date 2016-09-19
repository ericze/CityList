//
//  CityModel.h
//  CityList
//
//  Created by wangZL on 16/9/14.
//  Copyright © 2016年 WangZeLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
@property (nonatomic, copy) NSString *city_code;
@property (nonatomic, copy) NSString *city_name;
@property (nonatomic, copy) NSString *pinyin_headers;
@property (nonatomic, copy) NSString *full_pinyin;
@property (nonatomic, copy) NSString *pinyin_first;
@property (nonatomic, copy) NSString *pinji_hot_tag;
@property (nonatomic, copy) NSString *zone_code;
@property (nonatomic, copy) NSString *abroad;
@end
