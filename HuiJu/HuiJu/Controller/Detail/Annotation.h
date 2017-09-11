//
//  Annotation.h
//  HuiJu
//
//  Created by admin1 on 2017/9/11.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Annotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


@end
