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
@property (strong,nonatomic) NSArray *experience;
@property (strong,nonatomic) NSString *logo;
@property (strong,nonatomic) NSString *TName;
@property (strong,nonatomic) NSString *categoryName;
@property (strong,nonatomic) NSString *price;
- (id)initWithDictionary: (NSDictionary *)dict;
- (id)initWithDetialDictionary: (NSDictionary *)dict;
@end
