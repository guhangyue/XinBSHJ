//
//  TiYanJuanTableViewCell.h
//  HuiJu
//
//  Created by admin1 on 2017/9/7.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiYanJuanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLbl;
@property (weak, nonatomic) IBOutlet UIImageView *eLogoImage;

@end
