//
//  OrderModel.m
//  HuiJu
//
//  Created by admin1 on 2017/9/15.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
- (instancetype)initWithOrder:(NSDictionary *)dict{
    self = [super self];
    if(self){
        _dingdan = [Utilities nullAndNilCheck:dict[@"orderNum"] replaceBy:@""];
        _tiYan = [Utilities nullAndNilCheck:dict[@"productName"] replaceBy:@""];
        _image = [Utilities nullAndNilCheck:dict[@"imgUrl"] replaceBy:@"结婚"];
        _dianMing = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@"1234"];
        _money = [Utilities nullAndNilCheck:dict[@"shouldpay"] replaceBy:@"12345"];
    }
    return self;
    
}

@end
