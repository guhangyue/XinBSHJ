//
//  experienceCellTableViewCell.h
//  HuiJu
//
//  Created by IMAC on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface experienceCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
