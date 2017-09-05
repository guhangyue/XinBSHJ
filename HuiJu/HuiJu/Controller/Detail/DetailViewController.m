//
//  DetailViewController.m
//  HuiJu
//
//  Created by IMAC on 2017/9/1.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "DetailViewController.h"
#import "ShouYe.h"
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
- (IBAction)addressAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *clubNameLbl;
@property (weak, nonatomic) IBOutlet UIButton *callingBtn;
- (IBAction)callingAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *clubIntroduceLbl;
@property (weak, nonatomic) IBOutlet UILabel *clubTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *clubMemberLbl;
@property (weak, nonatomic) IBOutlet UILabel *clubSiteLbl;
@property (weak, nonatomic) IBOutlet UILabel *clubPersonLbl;
@property (weak, nonatomic) IBOutlet UILabel *eNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLbl;
@property (weak, nonatomic) IBOutlet UIImageView *eLogoImage;
@property (weak, nonatomic) IBOutlet UIView *TiYanJuanView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Action:)];
    [_TiYanJuanView addGestureRecognizer:tap];
    [self HotelDetailRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置导航栏样式
-(void)setNavigationItem{
    self.navigationItem.title = @"会所详情";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 100, 255);
   
}
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
-(void)Action:(id)sender{
    [self performSegueWithIdentifier:@"detailToTiyanjuan" sender:nil];

}
- (void)HotelDetailRequest{
    //菊花膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    //NSLog(@"%@",_hotelid);
    // HotelModel *user=[ HotelModel alloc];
    NSDictionary *para1 = @{@"clubKeyId":@123};
    // NSLog(@"%@",user.hotelId);
    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:para1 andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"result:%@",responseObject);
        if([responseObject[@"resultFlag"]integerValue]==8001){
            NSDictionary *result = responseObject[@"result"];
           // NSDictionary *models =result [@"models"];
            ShouYe *detail = [[ ShouYe alloc]initWithDetialDictionary:result];
            _clubNameLbl.text =detail.TName;
            
           // [_addressBtn setTitle:@"detail.addressB" forState:UIControlStateNormal];
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

- (IBAction)addressAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"detailToMap" sender:nil];
}
- (IBAction)callingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
}
@end
