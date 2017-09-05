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
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet UITableView *HomeTableView;
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSMutableArray *arr2;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    _arr2 = [NSMutableArray new];
    [self naviConfig];
    // Do any additional setup after loading the view.
    //创建菊花膜
    _avi = [Utilities getCoverOnView:self.view];
    [self networkRequest];
    
    
    
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
//执行网络请求
- (void)networkRequest{
    NSDictionary *para = @{@"city":@"无锡", @"jing":@"31.568",@"wei":@"120.299",@"page" : @1,@"perPage":@3};
        [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        //NSLog(@"%@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSLog(@"%@",responseObject);
            NSDictionary *result =responseObject[@"result"];
            NSArray *models =result [@"models"];
            [_arr removeAllObjects];
            for (NSDictionary *dict in models) {
                //用ActivityModel类中定义的初始化方法initWithDictionary：将遍历得来的字典dict转换为ActivityModel对象
                ShouYe *models = [[ShouYe alloc]initWithDictionary:dict];
                //将上述实例化好的Model对象插入_arr数组中
                [_arr addObject:models];
//                break;
            }
//            NSArray *experience =responseObject[@"result"][@"models"][@"experience"];
//            for (NSDictionary *Adict in experience) {
//                //用ActivityModel类中定义的初始化方法initWithDictionary：将遍历得来的字典dict转换为ActivityModel对象
//                ShouYe *experience = [[ShouYe alloc]initWithDetialDictionary:Adict];
//                //将上述实例化好的activityModel对象插入_arr数组中
//                [_arr2 addObject:experience];
//            }
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
    if (_arr2.count !=0) {
        return 2;
    }else{
        return 1;
    }
}
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arr2.count !=0) {
        return _arr2.count;
    }
    return _arr.count;
}
//每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}
//设置每一组中每一行的cell（细胞）长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YeMianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YeMianCell" forIndexPath:indexPath];
    //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
    
    ShouYe *hotel = _arr[indexPath.row];

    //将http请求的字符串转换为NSURL
    NSURL *url = [NSURL URLWithString:hotel.image];
    [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
    cell.name.text =hotel.name;
    cell.address.text =hotel.address;
    cell.distance.text =hotel.distance;
//    if (hotel.experience>0) {
//        experienceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"experienceCell" forIndexPath:indexPath];
//        //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
//        
//        
//        ShouYe *hotels = _arr2[indexPath.row];
//        //将http请求的字符串转换为NSURL
//        NSURL *url = [NSURL URLWithString:hotels.image];
//        [cell.logo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
//        cell.name.text =hotels.name;
//        cell.categoryName.text =hotels.categoryName;
//        cell.price.text =hotels.price;
//    }
    return cell;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShouYe2Detail"]) {
        //当从列表页到详情页的这个跳转要发生的时候
        //获取要传递到下一页的数据
        NSIndexPath *indexPath=[_HomeTableView indexPathForSelectedRow];
        ShouYe *activity=_arr[indexPath.row];
        //获取下一页的这个实例
        DetailViewController *detailVC= segue.destinationViewController;
        //把数据给下一页预备好的接收容器
        detailVC.detailA=activity;
    }
}

@end
