//
//  ShouYe.h
//  HuiJu
//
//  Created by IMAC on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShouYe : NSObject
@property (strong,nonatomic) NSString *image;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *addressB;
@property (strong,nonatomic) NSString *distance;
@property (strong,nonatomic) NSMutableArray *experience;
@property (strong,nonatomic) NSMutableArray *experienceInfos;
@property (strong,nonatomic) NSString *logo;
@property (strong,nonatomic) NSString *TName;
@property (strong,nonatomic) NSString *categoryName;
@property (strong,nonatomic) NSString *price;
@property (strong,nonatomic) NSString *clubLogo;
@property (strong,nonatomic) NSString *clubTime;
@property (strong,nonatomic) NSString *clubMember;
@property (strong,nonatomic) NSString *clubSite;
@property (strong,nonatomic) NSString *clubPerson;
@property (strong,nonatomic) NSString *clubIntroduce;
@property (strong,nonatomic) NSString *adView;
@property (strong,nonatomic) NSString *cardLogo;
@property (strong,nonatomic) NSString *eLogo;
@property (strong,nonatomic) NSString *eName;
@property (strong,nonatomic) NSString *saleCount;
@property (strong,nonatomic) NSString *price2;
@property (nonatomic) NSString *eId;
@property (nonatomic) NSString *beginDate;
@property (nonatomic) NSString *currentPrice;
@property (nonatomic) NSString *eAddress;
@property (nonatomic) NSString *eClubName;
@property (nonatomic) NSString *eFeature;
@property (nonatomic) NSString *eLogo2;
@property (nonatomic) NSString *eName2;
@property (nonatomic) NSString *endDate;
@property (nonatomic) NSString *orginPrice;
@property (nonatomic) NSString *rules;
@property (nonatomic) NSString *useDate;
@property(strong,nonatomic)NSString *fId;//健身类型id
@property(strong,nonatomic)NSString *fName;//健身类型名称
@property(strong,nonatomic)NSString *total;//包含该健身类型的健身会所数量
@property(strong,nonatomic)NSString *clubID;//会所id
@property(strong,nonatomic)NSString *Image2;//会所图片地址
@property(strong,nonatomic)NSString *clubName;//会所名字
@property(strong,nonatomic)NSString *clubLogo2;//会所图片地址
@property(strong,nonatomic)NSString *id2;


@property (nonatomic) NSInteger i;
@property (strong,nonatomic) NSString *sellNumber;
@property (nonatomic) NSInteger nameId2;
@property (nonatomic) NSString *nameId;
- (id)initWithDictionary: (NSDictionary *)dict;
- (id)initWithDetialDictionary: (NSDictionary *)dict;
- (id)initWithExDictionary: (NSDictionary *)dict;
- (id)initWithExDictionary2: (NSDictionary *)dict;
- (id)initWithExDictionary3: (NSDictionary *)dict;
-(instancetype)initWithType:(NSDictionary *)dict;
-(instancetype)initWithClub:(NSDictionary *)dict;
@end
