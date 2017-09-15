//
//  OrderModel.m
//  HuiJu
//
//  Created by admin1 on 2017/9/15.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.dingdan = [Utilities nullAndNilCheck:dict[@"orderNum"] replaceBy:0];
        self.tiYan = [Utilities nullAndNilCheck:dict[@"productName"] replaceBy:@""];
        self.image = [Utilities nullAndNilCheck:dict[@"imgUrl"] replaceBy:@""];
        self.dianMing = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
        self.money = [[Utilities nullAndNilCheck:dict[@"donepay"] replaceBy:0]integerValue];
    }
    return self;
    
}

@end
