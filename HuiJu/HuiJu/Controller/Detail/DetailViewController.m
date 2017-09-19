//
//  DetailViewController.m
//  HuiJu
//
//  Created by IMAC on 2017/9/1.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "DetailViewController.h"
#import "ShouYe.h"
#import "TiYanJuanTableViewCell.h"
#import "TiYanViewController.h"
@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    ShouYe *detail;

}
@property (weak, nonatomic) IBOutlet UIScrollView *huisouscrollView;
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
@property (weak, nonatomic) IBOutlet UIImageView *clubPic;
@property (strong, nonatomic) NSMutableArray *arr5;
@property (weak, nonatomic) IBOutlet UITableView *TiYanJuanTableView;
@property (strong,nonatomic)NSArray *arr1;
//@property (weak, nonatomic) IBOutlet UIView *TiYanJuanView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    _arr5 = [NSMutableArray new];
    [super viewDidLoad];
    [self setNavigationItem];
    [self uiLayout];
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Action:)];
//    [_TiYanJuanView addGestureRecognizer:tap];//视图单击手势的创建
    
    [self ClubDetailRequest];
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
- (void)uiLayout {
    //为表格视图创建footer(该方法可以去除表格视图底部多余的下划线)
   // _huisouscrollView.
    //创建下拉刷新器
    [self refreshConfiguration];
}
- (void)refreshConfiguration{
    //初始化一个下拉刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    refreshControl.tag = 10001;
    //设置标题
    NSString *title = @"刷新中...";
    
    //创建属性字典
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : [UIColor redColor],NSBackgroundColorAttributeName : [UIColor yellowColor]};
    
    
    //将文字和属性字典包裹成一个带属性的字符串
    NSAttributedString *attriTitle = [[NSAttributedString alloc]initWithString:title attributes:attrDict];
    
    refreshControl.attributedTitle = attriTitle;
    //设置风格颜色为黑色（风格颜色：刷新指示器的颜色）
    refreshControl.tintColor = [UIColor blueColor];
    
    //设置背景色
    refreshControl.backgroundColor = [UIColor whiteColor];
    //定义用户触发下拉事件时执行的方法
    [refreshControl addTarget:self action:@selector(ClubDetailRequest) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到tableView中(在tableView中，下拉刷新控件会自动放置在表格视图顶部后侧位置)
    [self.huisouscrollView addSubview:refreshControl];
    
}
- (void)end{
    //在activityTableView中，根据下标为10001获得其子视图：下拉刷新控件
    UIRefreshControl *refresh = (UIRefreshControl *)[self.huisouscrollView viewWithTag:10001];
    //结束刷新
    [refresh endRefreshing];
}

//-(void)Action:(id)sender{
//    [self performSegueWithIdentifier:@"detailToTiyanjuan" sender:nil];
//
//}
- (void)ClubDetailRequest{
    //菊花膜
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    //NSLog(@"%@",_hotelid);
    // HotelModel *user=[ HotelModel alloc];
    NSString *Id = [[StorageMgr singletonStorageMgr]objectForKey:@"clubId"];
    NSDictionary *para1 = @{@"clubKeyId":Id};
    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:para1 andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"result:%@",responseObject);
        if([responseObject[@"resultFlag"]integerValue]==8001){
            NSDictionary *result = responseObject[@"result"];
           // NSDictionary *models =result [@"models"];
           
                detail = [[ ShouYe alloc]initWithDetialDictionary:result];
                _clubNameLbl.text =detail.TName;
                _clubIntroduceLbl.text=detail.clubIntroduce;
                _clubTimeLbl.text=detail.clubTime;
                _clubMemberLbl.text=detail.clubMember;
                _clubSiteLbl.text=detail.clubSite;
                _clubPersonLbl.text=detail.clubPerson;
            
            
            
            
           // [_arr5 addObject:detail];
            
 //          ShouYe *detail2 = [[ ShouYe alloc]initWithExDictionary2:result];
//            NSURL *url = [NSURL URLWithString:detail2.eLogo];
//            [_eLogoImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
//            _eNameLbl.text=detail2.eName;
//            _priceLbl.text=detail2.price2;
//            _saleCountLbl.text=detail2.saleCount;
            [_clubPic sd_setImageWithURL:[NSURL URLWithString:detail.clubLogo] placeholderImage:[UIImage imageNamed:@"11"]];
            
            [_addressBtn setTitle:detail.addressB forState:UIControlStateNormal];
            
            //NSLog(@"333:%@",detail.addressB);
           // _addressLbl.text = detail.hotelLocation;
            //_priceLbl.text = [NSString stringWithFormat:@"¥ %@",detail.hotelMoney];
            
           // [_smallPictureImgView sd_setImageWithURL:[NSURL URLWithString:detail.hotelImg] placeholderImage:[UIImage imageNamed:@"11"]];设置默认图片
            [self end];
            [_TiYanJuanTableView reloadData];
           
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self ];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"该功能需要登录才会开放，请您登录" andTitle:@"提示" onView:self];
    }];
}
//设置表格视图中有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //数组中项目会所的数量
    return 1;
}
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // NSInteger s=_suliang;
    //ShouYe *model = _detailA;
    //当前正在渲染的细胞会所的体验券的数量加上一个会所的数量
    return detail.experienceInfos.count ;
    //NSLog(@"ggggggg%ld",(long)s);
}
//每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return 100.f;
    
    
}
//设置每一组中每一行的cell（细胞）长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    //判断当前正在渲染的行数是不是第一行
//    if (indexPath.row == 0) {
//        YeMianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YeMianCell" forIndexPath:indexPath];
//        //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
//        
//        ShouYe *hotel = _arr[indexPath.section];
//        
//        //将http请求的字符串转换为NSURL
//        NSURL *url = [NSURL URLWithString:hotel.image];
//        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
//        cell.name.text = hotel.name;
//        cell.address.text = hotel.address;
//        cell.distance.text = hotel.distance;
//        return cell;
//    } else {
//        experienceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"experienceCell" forIndexPath:indexPath];
        //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
        //NSArray *experiences = model.experience;
        //NSDictionary *experience = experiences[indexPath.row-1];
        
        //ShouYe *hotels = _arr[indexPath.row];
        //将http请求的字符串转换为NSURL
        //NSLog(@"图片网址：%@",model.experience[indexPath.row-1][0]);
//        NSURL *url = [NSURL URLWithString:model.experience[indexPath.row-1][0]];
//        [cell.logo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
//        
//        cell.categoryName.text = model.experience[indexPath.row-1][1];
//        cell.price.text = model.experience[indexPath.row-1][2];
//        cell.name.text = model.experience[indexPath.row-1][3];
//        cell.sellNumber.text = [NSString stringWithFormat:@"已售：%@",model.experience[indexPath.row-1][4]];
   TiYanJuanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TiyanJuanCell" forIndexPath:indexPath];
    
//    NSLog(@"%@",_arr5[3]);
    NSURL *url = [NSURL URLWithString:detail.experienceInfos[indexPath.row][1]];
                [cell.eLogoImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Home"]];
    cell.eNameLbl.text=detail.experienceInfos[indexPath.row][0];
    
                cell.priceLbl.text=detail.experienceInfos[indexPath.row][2];
                cell.saleCountLbl.text=[NSString stringWithFormat:@"已售：%@",detail.experienceInfos[indexPath.row][3]];
   
    
        return cell;
   // }
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    DetailViewController *detailVC = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"Detail2"];
    //    [self.navigationController pushViewController:detailVC animated:YES];
    [self performSegueWithIdentifier:@"detailToTiyanjuan" sender:nil];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"detailToTiyanjuan"]) {
        //当从列表页到详情页的这个跳转要发生的时候
        //获取要传递到下一页的数据
        NSIndexPath *indexPath=[_TiYanJuanTableView indexPathForSelectedRow];
        
        NSString *club=detail.experienceInfos[indexPath.row][4];
        [[StorageMgr singletonStorageMgr] addKey:@"eId" andValue:club];
//        TiYanViewController *detailVC= segue.destinationViewController;
//        detailVC.eid=club;
       // NSLog(@"传的什么鬼%@",detailVC.detailC);
        //        ShouYe *activity=_arr[indexPath.section];
//        ShouYe *activity2=_arr[indexPath.row];
//        // NSLog(@"%@",_arr[indexPath.row]);
//        //获取下一页的这个实例
//        DetailViewController *detailVC= segue.destinationViewController;
//        //把数据给下一页预备好的接收容器
//        detailVC.detailA=activity;
//        detailVC.detailB=activity2;
    }
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
    NSString *jing=detail.clubJing;
    [[StorageMgr singletonStorageMgr] addKey:@"clubJing" andValue:jing];
    NSString *wei=detail.clubWei;
    [[StorageMgr singletonStorageMgr] addKey:@"clubWei" andValue:wei];
    [self performSegueWithIdentifier:@"detailToMap" sender:nil];
}
- (IBAction)callingAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //配置电话APP的路径，并将要拨打的号码组合到路径中
    NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",detail.clubTel];
    NSString *string = detail.clubTel;
    //按逗号截取字符串
    _arr1 = [string componentsSeparatedByString:@","];
    //创建一个从底部弹出的弹窗
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //遍历判断数组中有几个值
    for (int i = 0; i < _arr1.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:_arr1[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:action];
    }
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:actionA];
    [self presentViewController:alert animated:YES completion:nil];
    UIWebView *callWebview =[[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];

}
@end
