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
@property (nonatomic) NSInteger i;
@property (strong,nonatomic) NSString *sellNumber;

@property (nonatomic) NSString *nameId;
- (id)initWithDictionary: (NSDictionary *)dict;
- (id)initWithDetialDictionary: (NSDictionary *)dict;
- (id)initWithExDictionary: (NSDictionary *)dict;
@end
