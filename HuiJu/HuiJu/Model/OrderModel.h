//
//  OrderModel.h
//  HuiJu
//
//  Created by admin1 on 2017/9/15.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property (strong,nonatomic) NSString *dingdan;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *tiYan;
@property (strong, nonatomic) NSString *dianMing;
@property (nonatomic) NSString *money;

- (instancetype)initWithOrder: (NSDictionary *)dict;
@end
