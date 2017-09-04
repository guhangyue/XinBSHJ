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
@property (strong,nonatomic) NSString *distance;
@property (strong,nonatomic) NSString *experience;
- (instancetype)initWithDictForHotelCell: (NSDictionary *)dict;
@end
