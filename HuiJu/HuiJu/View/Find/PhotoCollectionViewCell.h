//
//  PhotoCollectionViewCell.h
//  HuiJu
//
//  Created by IMAC on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *PhotoIV;
@property (weak, nonatomic) IBOutlet UILabel *NameLbl;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end
