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
    _experience = [NSMutableArray new];
    
    self = [super init];
    if (self) {
        self.nameId2=[[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0] integerValue] ;
        self.image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@"暂无"];
        self.name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@"未知"];
        self.address = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@"未知"];
        
        self.distance = [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@"未知"];
        
        
        if (![dict[@"experience"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *experience in dict[@"experience"]) {
                ShouYe *shouye =[[ShouYe alloc] initWithExDictionary:experience];
                NSMutableArray *experiences = [NSMutableArray new];
                [experiences addObject:shouye.logo];
                [experiences addObject:shouye.categoryName];
                [experiences addObject:shouye.price];
                [experiences addObject:shouye.TName];
                [experiences addObject:shouye.sellNumber];
                self.i++;
                [self.experience addObject:experiences];
                
            }
            //self.experience = experiences;
            
        } else {
            self.experience = NULL;
        }
        //self.experience = [dict[@"experience"] isKindOfClass:[NSNull class]] ?@[] : dict[@"experience"];
        _adView = [Utilities nullAndNilCheck:dict[@"imgurl"] replaceBy:@""];
        //        _logo=[Utilities nullAndNilCheck:dict[@"Logo"] replaceBy:@""];
        //        _categoryName=[Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@""];
        //        _price=[Utilities nullAndNilCheck:dict[@"price"] replaceBy:@""];
        //        _TName=[Utilities nullAndNilCheck:dict[@"experiencename"] replaceBy:@""];
    }
    return self;
}
- (id)initWithDetialDictionary: (NSDictionary *)dict{
    self = [super init];
    _experienceInfos = [NSMutableArray new];
    if (self) {
        self.nameId2=[[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0] integerValue] ;
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
        self.clubIntroduce= [Utilities nullAndNilCheck:dict[@"clubIntroduce"] replaceBy:@"未知"];
        self.clubLogo= [Utilities nullAndNilCheck:dict[@"clubLogo"] replaceBy:@"未知"];
        
       // self.eName= [Utilities nullAndNilCheck:dict[@"eName"] replaceBy:@"未知"];
        if (![dict[@"experienceInfos"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *experienceInfos in dict[@"experienceInfos"]) {
                ShouYe *shouye1 =[[ShouYe alloc] initWithExDictionary2:experienceInfos];
                NSMutableArray *Infos = [NSMutableArray new];
                [Infos addObject:shouye1.eName];
                [Infos addObject:shouye1.eLogo];
                [Infos addObject:shouye1.price2];
                [Infos addObject:shouye1.saleCount];
                [Infos addObject:shouye1.eId];

                self.i++;
                [self.experienceInfos addObject:Infos];
                NSLog(@"111%@",self.experienceInfos);
                
            }
            //self.experience = experiences;
            
        } else {
            self.experienceInfos = NULL;
        }
        
    }
    return self;
}
- (id)initWithExDictionary: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.nameId2=[[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0] integerValue] ;
        _logo=[Utilities nullAndNilCheck:dict[@"logo"] replaceBy:@""];
        _categoryName=[Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@"综合卷"];
        //[experience[@"categoryName"] isKindOfClass:[NSNull class]] ?@"综合卷" :experience[@"categoryName"];
        _price=[Utilities nullAndNilCheck:dict[@"price"] replaceBy:@"111"];
        _TName=[Utilities nullAndNilCheck:dict[@"name"] replaceBy:@"000"];
        _sellNumber=[Utilities nullAndNilCheck:dict[@"sellNumber"] replaceBy:@"000"];
    }
    return self;
}
- (id)initWithExDictionary2:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.eName= [Utilities nullAndNilCheck:dict[@"eName"] replaceBy:@"未知"];
        self.eLogo= [Utilities nullAndNilCheck:dict[@"eLogo"] replaceBy:@"未知"];
        self.price2= [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@"未知"];
        self.saleCount= [Utilities nullAndNilCheck:dict[@"saleCount"] replaceBy:@"未知"];
        self.eId= [Utilities nullAndNilCheck:dict[@"eId"] replaceBy:@"gg"] ;
    }
    return self;
}
- (id)initWithExDictionary3: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.beginDate= [Utilities nullAndNilCheck:dict[@"beginDate"] replaceBy:@"未知"];
        self.endDate= [Utilities nullAndNilCheck:dict[@"endDate"] replaceBy:@"未知"];
        self.currentPrice= [Utilities nullAndNilCheck:dict[@"currentPrice"] replaceBy:@"未知"];
        self.eAddress= [Utilities nullAndNilCheck:dict[@"eAddress"] replaceBy:@"未知"];
        self.eClubName= [Utilities nullAndNilCheck:dict[@"eClubName"] replaceBy:@"未知"];
        self.eFeature= [Utilities nullAndNilCheck:dict[@"eFeature"] replaceBy:@"未知"];
        self.eLogo2= [Utilities nullAndNilCheck:dict[@"eLogo"] replaceBy:@"未知"];
        self.eName2= [Utilities nullAndNilCheck:dict[@"eName"] replaceBy:@"未知"];
        self.orginPrice= [Utilities nullAndNilCheck:dict[@"orginPrice"] replaceBy:@"未知"];
        self.rules= [Utilities nullAndNilCheck:dict[@"rules"] replaceBy:@"未知"];
        self.saleCount= [Utilities nullAndNilCheck:dict[@"saleCount"] replaceBy:@"未知"];
        self.useDate= [Utilities nullAndNilCheck:dict[@"useDate"] replaceBy:@"未知"];
        
        
       
    }
    return self;
}
-(instancetype)initWithType:(NSDictionary *)dict{
    self = [super init];
    if(self){
        _fId = [Utilities nullAndNilCheck:dict[@"fId"] replaceBy:@""];
        _fName = [Utilities nullAndNilCheck:dict[@"fName"] replaceBy:@""];
        _total = [Utilities nullAndNilCheck:dict[@"total"] replaceBy:@""];
        
    }
    
    return self;
}
-(instancetype)initWithClub:(NSDictionary *)dict{
self = [super init];
if(self){
    _clubID = [Utilities nullAndNilCheck:dict[@"clubId"] replaceBy:@""];
    _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
    _Image2 = [Utilities nullAndNilCheck:dict[@"clubLogo"] replaceBy:@""];
    _address = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@""];
    _distance= [Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
}
return self;
}

@end
