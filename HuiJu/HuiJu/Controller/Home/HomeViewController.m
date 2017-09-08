//
//  HomeViewController.m
//  HuiJu
//
//  Created by IMAC on 2017/9/1.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "HomeViewController.h"
#import "YeMianTableViewCell.h"
#import "experienceCellTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "ShouYe.h"
#import "DetailViewController.h"
#import "ZLImageViewDisplayView.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>{
    NSInteger page;
    BOOL flag;
    BOOL isLoading;
    BOOL firstVisit;
}
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UITableView *HomeTableView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSMutableArray *arr3;
@property(strong,nonatomic) CLLocationManager *locMgr;
@property(strong,nonatomic) CLLocation *location;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    _arr3 = [NSMutableArray new];
    flag =YES;
    _cityBtn.titleLabel.text = @"无锡";
    [self naviConfig];
    // Do any additional setup after loading the view.
    //创建菊花膜
    //_avi = [Utilities getCoverOnView:self.view];
    [self locationConfig];
    [self dataInitialize];
    [self uiLayout];
    //监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkCityState:) name:@"ResetHome" object:nil];
    
    
}
//这个方法专门处理定位的基本设置
-(void)locationConfig{
    _locMgr=[CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //设置定位到的设备，位移多少距离进行一次识别
    _locMgr.distanceFilter = kCLDistanceFilterNone ;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy =  kCLLocationAccuracyBest;
}
//这个方法处理开始定位
-(void)locationStart{
    //判断用户有没有选择过是否使用定位
    if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        //询问用户是否愿意使用定位
#ifdef __IPHONE_8_0
        if([_locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            //使用“使用中打开定位”这个策略去运用定位功能
            [_locMgr requestWhenInUseAuthorization];
        }
#endif
    }
    //打开定位服务的开关（开始定位)
    [_locMgr startUpdatingLocation];
}

//这个方法专门做导航条的控制
- (void)naviConfig {
    // 设置导航条标题文字
    self.navigationItem.title = @"首页";
    //设置导航条颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    //设置导航条是否隐藏.
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)uiLayout {
    //为表格视图创建footer(该方法可以去除表格视图底部多余的下划线)
    _HomeTableView.tableFooterView = [UIView new];
}
-(void) addZLImageViewDisPlayView:(NSArray *)arr{
    CGRect frame = CGRectMake(0,0, UI_SCREEN_W, 150);
    //初始化控件
    ZLImageViewDisplayView *imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
    imageViewDisplay.imageViewArray = arr;
    imageViewDisplay.scrollInterval = 4;
    imageViewDisplay.animationInterVale = 1;
    [_adView addSubview:imageViewDisplay];
    
}

//这个方法专门做数据的处理
- (void)dataInitialize {
    BOOL appInit = NO;
    
    if ([[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        //说明是第一次打开APP
        appInit =  YES;
    }else{
        if ([Utilities getUserDefaults:@"UserCity"] ==nil) {
            //也说明是第一次打开APP
            appInit = YES;
        }
    }
    if (appInit) {
        //第一次来到APP将默认城市与记忆城市同步
        NSString *userCity = _cityBtn.titleLabel.text;
        [Utilities setUserDefaults:@"UserCity" content:userCity];
    }else{
        //不是第一次来到APP则将记忆城市与安宁上的城市名反向同步
        NSString *userCity =[Utilities getUserDefaults:@"UserCity"];
        [_cityBtn setTitle:userCity forState:UIControlStateNormal];
        
    }
    
    
    firstVisit = YES;
    isLoading = NO;
    _arr = [NSMutableArray new];
    //创建菊花膜
    _avi = [Utilities getCoverOnView:self.view];
    [self refreshPage];
}
- (void)refreshPage {
    page = 1;
    [self networkRequest];
}


//执行网络请求
- (void)networkRequest{
    NSDictionary *para = @{@"city":_cityBtn.titleLabel.text, @"jing":@"31.568",@"wei":@"120.299",@"page" : @(page),@"perPage":@10};
    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSLog(@"%@",responseObject);
            NSDictionary *result =responseObject[@"result"];
            NSArray *advertisement =   responseObject[@"advertisement"];
            NSArray *models =result [@"models"];
            [_arr removeAllObjects];
            [_arr3 removeAllObjects];
            for (NSDictionary *dict3 in advertisement) {
                ShouYe *TuP =[[ShouYe alloc] initWithDictionary:dict3];
                [_arr3 addObject:TuP.adView];
                NSLog(@"图片地址是：%@",TuP.adView);
                
            }
            //第一次来才加载广告图片
            if (flag) {
                flag = NO;
                [self addZLImageViewDisPlayView:_arr3];
            }
            for (NSDictionary *dict in models) {
                //用ActivityModel类中定义的初始化方法initWithDictionary：将遍历得来的字典dict转换为ActivityModel对象
                ShouYe *models = [[ShouYe alloc]initWithDictionary:dict];
                //将上述实例化好的Model对象插入_arr数组中
                [_arr addObject:models];
            }
            [_HomeTableView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    }failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络不稳定" andTitle:nil onView:self];
        
    }];
}

//NSLog(@"%@",responseObject);
//if (_adArr.count == 0) {
//    NSArray *advertising = responseObject[@"content"][@"advertising"];
//    for (NSDictionary *dict in advertising) {
//        HotelModel *ad = [[HotelModel alloc] initWithDictForAD:dict];
//        [_adArr addObject:ad];
//    }
//    [self setADImage];
//}
//NSArray *hotel = responseObject[@"content"][@"hotel"][@"list"];
//[_arr removeAllObjects];
//for (NSDictionary *dict in hotel) {
//    HotelModel *hotelModel = [[HotelModel alloc] initWithDictForHotelCell:dict];
//    //NSLog(@"%@",hotelModel.hotelName);
//    [_arr addObject:hotelModel];
//
//}
//NSLog(@"%ld",_arr.count);
//[_HotelTabView reloadData];
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//设置表格视图中有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //数组中项目会所的数量
    return _arr.count;
}
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //
    ShouYe *model = _arr[section];
    //当前正在渲染的细胞会所的体验券的数量加上一个会所的数量
    return model.i +1;
}
//每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150.f;
    }else{
        return 100.f;
    }
    
}
//设置每一组中每一行的cell（细胞）长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShouYe *model = _arr[indexPath.section];
    //判断当前正在渲染的行数是不是第一行
    if (indexPath.row == 0) {
        YeMianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YeMianCell" forIndexPath:indexPath];
        //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
        
        ShouYe *hotel = _arr[indexPath.section];
        
        //将http请求的字符串转换为NSURL
        NSURL *url = [NSURL URLWithString:hotel.image];
        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        cell.name.text = hotel.name;
        cell.address.text = hotel.address;
        cell.distance.text = hotel.distance;
        return cell;
    } else {
        experienceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"experienceCell" forIndexPath:indexPath];
        //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
        //NSArray *experiences = model.experience;
        //NSDictionary *experience = experiences[indexPath.row-1];
        
        //ShouYe *hotels = _arr[indexPath.row];
        //将http请求的字符串转换为NSURL
        //NSLog(@"图片网址：%@",model.experience[indexPath.row-1][0]);
        NSURL *url = [NSURL URLWithString:model.experience[indexPath.row-1][0]];
        [cell.logo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        
        cell.categoryName.text = model.experience[indexPath.row-1][1];
        cell.price.text = model.experience[indexPath.row-1][2];
        cell.name.text = model.experience[indexPath.row-1][3];
        cell.sellNumber.text = [NSString stringWithFormat:@"已售：%@",model.experience[indexPath.row-1][4]];
        return cell;
    }
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    DetailViewController *detailVC = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"Detail2"];
    //    [self.navigationController pushViewController:detailVC animated:YES];
    [self performSegueWithIdentifier:@"ShouYe2Detail" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShouYe2Detail"]) {
        //当从列表页到详情页的这个跳转要发生的时候
        //获取要传递到下一页的数据
        NSIndexPath *indexPath=[_HomeTableView indexPathForSelectedRow];
        ShouYe *activity=_arr[indexPath.section];
        ShouYe *activity2=_arr[indexPath.row];
        // NSLog(@"%@",_arr[indexPath.row]);
        //获取下一页的这个实例
        DetailViewController *detailVC= segue.destinationViewController;
        //把数据给下一页预备好的接收容器
        detailVC.detailA=activity;
        detailVC.detailB=activity2;
    }
}

//定位失败时
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    if(error){
        switch (error.code) {
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
                break;
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
                break;
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw" , nil) andTitle:nil onView:self];
                break;
            default:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError" , nil) andTitle:nil onView:self];
                break;
        }
    }
}
//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    // NSLog(@"维度：%f",newLocation.coordinate.latitude);
    //  NSLog(@"经度：%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿城市
    if(firstVisit){
        firstVisit = ! firstVisit;
        //根据定位拿城市
        [self getRegeoViaCoordinate];
        
    }
}

-(void)getRegeoViaCoordinate{
    //duration表示从now开始过3个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    //用duration这个设置好的策略去做某些事
    dispatch_after(duration, dispatch_get_main_queue(), ^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(!error){
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                NSLog(@"locDict = %@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"LocCity"];
                
                //将定位的城市保存进单例化全局变量
                [[StorageMgr singletonStorageMgr]addKey:@"LocCity" andValue:cityStr];
                if (![cityStr isEqualToString:_cityBtn.titleLabel.text]) {
                    //当定位到的城市和当前选择到的城市不一样的时候去弹窗询问用户是否切换城市
                    UIAlertController *alertView =[UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到城市为%@， 你是否要切换",cityStr] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //修改城市按钮标题
                        [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
                        //修改用户选择的城市记忆体
                        [Utilities removeUserDefaults:@"UserCity"];
                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
                        //重新执行网络请求
                        [self networkRequest];
                    }];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alertView addAction:yesAction];
                    [alertView addAction:noAction];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                    
                }
            }
        }];
        //关掉开关
        [_locMgr stopUpdatingLocation];
    });
}
-(void)checkCityState:(NSNotification *)note {
    NSString *cityStr=note.object;
    if (![cityStr isEqualToString:_cityBtn.titleLabel.text]) {
        
        //修改城市按钮标题
        [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
        //修改用户选择的城市记忆体
        [Utilities removeUserDefaults:@"UserCity"];
        [Utilities setUserDefaults:@"UserCity" content:cityStr];
        //重新执行网络请求
        [self networkRequest];
        
    }
}


@end
