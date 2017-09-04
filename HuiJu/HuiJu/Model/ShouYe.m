//
//  ShouYe.m
//  HuiJu
//
//  Created by IMAC on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "ShouYe.h"

@implementation ShouYe

- (instancetype)initWithDictForHotelCell: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@"暂无"];
        self.name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@"未知"];
        self.address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@"未知"];
        self.distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"未知"];
        self.experience = [Utilities nullAndNilCheck:dict[@"experience"] replaceBy:@"未知"];
    }
    return self;
}
@end
