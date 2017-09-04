//
//  YeMianTableViewCell.h
//  HuiJu
//
//  Created by IMAC on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YeMianTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;//健身会所图片地址
@property (weak, nonatomic) IBOutlet UILabel *name;//健身会所名称
@property (weak, nonatomic) IBOutlet UILabel *address;//健身会所地址
@property (weak, nonatomic) IBOutlet UILabel *distance;//健身会所与用户距离

@end
