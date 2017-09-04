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
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet UITableView *HomeTableView;
@property (strong, nonatomic) NSMutableArray *arr;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建菊花膜
    _avi = [Utilities getCoverOnView:self.view];
    [self networkRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//执行网络请求
- (void)networkRequest{
    NSDictionary *para = @{@"city":@"无锡", @"jing":@"31.568",@"wei":@"120.299",@"page" : @1,@"perPage":@3};
    NSLog(@"para = %@", para);
    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSLog(@"%@",responseObject);
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
////设置表格视图中有多少组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;
//}
//设置表格视图中每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
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
//    if (experience.text >0) {
//        experienceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"experienceCell" forIndexPath:indexPath];
//        //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
//        
//        ShouYe *hotel = _arr[indexPath.row];
//        //将http请求的字符串转换为NSURL
//        NSURL *url = [NSURL URLWithString:hotel.image];
//        [cell.logo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
//        cell.name.text =hotel.name;
//        cell.categoryName.text =hotel.categoryName;
//        cell.price.text =hotel.price;
//    }
    return cell;
}

@end
