//
//  ShouYe.m
//  HuiJu
//
//  Created by IMAC on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "ShouYe.h"

@implementation ShouYe

- (id)initWithDictionary: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@"暂无"];
        self.name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@"未知"];
        self.address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@"未知"];
        
        self.distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"未知"];
        self.experience =[dict[@"experience"] isKindOfClass:[NSNull class]] ?@[ ]:      dict[@"experience"];
        _adView = [Utilities nullAndNilCheck:dict[@"imgurl"] replaceBy:@""];
        _logo=[Utilities nullAndNilCheck:dict[@"Logo"] replaceBy:@""];
        _categoryName=[Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@""];
        _price=[Utilities nullAndNilCheck:dict[@"price"] replaceBy:@""];
        _TName=[Utilities nullAndNilCheck:dict[@"experiencename"] replaceBy:@""];
    }
    return self;
}
- (id)initWithDetialDictionary: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.nameId=[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""] ;
        _logo=[Utilities nullAndNilCheck:dict[@"clubLogo"] replaceBy:@""];
        self.TName=[Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
        _categoryName=[Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@""];
        _price=[Utilities nullAndNilCheck:dict[@"price"] replaceBy:@""];
        self.addressB = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@"未知"];
        self.clubTime= [Utilities nullAndNilCheck:dict[@"clubTime"] replaceBy:@"未知"];
        self.clubMember= [Utilities nullAndNilCheck:dict[@"clubMember"] replaceBy:@"未知"];
        self.clubSite= [Utilities nullAndNilCheck:dict[@"clubSite"] replaceBy:@"未知"];
        self.clubPerson= [Utilities nullAndNilCheck:dict[@"clubPerson"] replaceBy:@"未知"];
        

    }
    return self;
}
@end
