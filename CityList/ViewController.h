//
//  ViewController.h
//  CityList
//
//  Created by wangZL on 16/9/12.
//  Copyright © 2016年 WangZeLin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CityModel;
typedef void (^CityPassBlock)(CityModel *);
@interface ViewController : UIViewController

@property(nonatomic,copy)CityPassBlock cityBlock;
@end

