//
//  TiYanViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "TiYanViewController.h"
#import "DetailViewController.h"
#import "ShouYe.h"

@interface TiYanViewController ()
@property (weak, nonatomic) IBOutlet UILabel *clubNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *clubAddressbBtn;
- (IBAction)clubAddressbAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *callingBtn;
- (IBAction)callingAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *eNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *orginPriceLbl;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *endDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *useDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *rulesLbl;
@property (weak, nonatomic) IBOutlet UIImageView *eLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *eFeatureLbl;

@end

@implementation TiYanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self Club2DetailRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置导航栏样式
-(void)setNavigationItem{
    self.navigationItem.title = @"体验劵详情";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 100, 255);

}
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
- (void)Club2DetailRequest{
    //菊花膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    //NSLog(@"%@",_hotelid);
    // HotelModel *user=[ HotelModel alloc];
    NSInteger  s=[_eid intValue];
    NSDictionary *para1 = @{@"experienceId":@(s)};
    
    NSLog(@"又是什么东西啊%ld",(long)s);
    //NSLog(@"反馈：%ld",(long)_detailA.nameId);
    [RequestAPI requestURL:@"/clubController/experienceDetail" withParameters:para1 andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"result2:%@",responseObject);
        if([responseObject[@"resultFlag"]integerValue]==8001){
            NSDictionary *result = responseObject[@"result"];
            // NSDictionary *models =result [@"models"];
            ShouYe *detail3 = [[ ShouYe alloc]initWithExDictionary3:result];
            _beginDateLbl.text=detail3.beginDate;
            _endDateLbl.text=[NSString stringWithFormat:@"至%@",detail3.endDate];
            NSURL *url = [NSURL URLWithString:detail3.eLogo2];
           [_eLogoImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            [_clubAddressbBtn setTitle:detail3.eAddress forState:UIControlStateNormal];
            _eNameLbl.text=detail3.eName2;
            _clubNameLbl.text=detail3.eClubName;
            _orginPriceLbl.text=[NSString stringWithFormat:@"原价：%@元",detail3.orginPrice];
            _rulesLbl.text=detail3.rules;
            _saleCountLbl.text=[NSString stringWithFormat:@"已售：%@",detail3.saleCount ];
            _useDateLbl.text=detail3.useDate;
            _eFeatureLbl.text=detail3.eFeature;
            
           // _priceLbl.text = [NSString stringWithFormat:@"¥ %@",detail.hotelMoney];
            // [_arr5 addObject:detail];
//            _clubNameLbl.text =detail.TName;
//            _clubIntroduceLbl.text=detail.clubIntroduce;
//            _clubTimeLbl.text=detail.clubTime;
//            _clubMemberLbl.text=detail.clubMember;
//            _clubSiteLbl.text=detail.clubSite;
//            _clubPersonLbl.text=detail.clubPerson;
            //          ShouYe *detail2 = [[ ShouYe alloc]initWithExDictionary2:result];
            //            NSURL *url = [NSURL URLWithString:detail2.eLogo];
            //            [_eLogoImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            //            _eNameLbl.text=detail2.eName;
            //            _priceLbl.text=detail2.price2;
            //            _saleCountLbl.text=detail2.saleCount;
//            [_clubPic sd_setImageWithURL:[NSURL URLWithString:detail.clubLogo] placeholderImage:[UIImage imageNamed:@"11"]];
//            
//            [_addressBtn setTitle:detail.addressB forState:UIControlStateNormal];
            
            //NSLog(@"333:%@",detail.addressB);
            // _addressLbl.text = detail.hotelLocation;
            //_priceLbl.text = [NSString stringWithFormat:@"¥ %@",detail.hotelMoney];
            
            // [_smallPictureImgView sd_setImageWithURL:[NSURL URLWithString:detail.hotelImg] placeholderImage:[UIImage imageNamed:@"11"]];设置默认图片
            
            
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self ];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"该功能需要登录才会开放，请您登录" andTitle:@"提示" onView:self];
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clubAddressbAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"TiYanJuanToMap" sender:nil];
}
- (IBAction)callingAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)payAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"TiYanJuanToPay" sender:nil];
}
@end
