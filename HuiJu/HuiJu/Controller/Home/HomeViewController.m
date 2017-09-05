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
    BOOL flag;
}
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UITableView *HomeTableView;
@property (strong, nonatomic) NSMutableArray *arr;
@property (strong, nonatomic) NSMutableArray *arr3;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    _arr3 = [NSMutableArray new];
    flag =YES;
    [self naviConfig];
    // Do any additional setup after loading the view.
    //创建菊花膜
    _avi = [Utilities getCoverOnView:self.view];
    [self networkRequest];
    [self uiLayout];
    
    
    
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



//执行网络请求
- (void)networkRequest{
    NSDictionary *para = @{@"city":@"无锡", @"jing":@"31.568",@"wei":@"120.299",@"page" : @1,@"perPage":@10};
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
    return model.experience.count +1;
}
//每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}
//设置每一组中每一行的cell（细胞）长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShouYe *model = _arr[indexPath.section];
    YeMianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YeMianCell" forIndexPath:indexPath];
    //判断当前正在渲染的行数是不是第一行
    if (indexPath.row == 0) {
        //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
        
        ShouYe *hotel = _arr[indexPath.row];
        
        //将http请求的字符串转换为NSURL
        NSURL *url = [NSURL URLWithString:hotel.image];
        [cell.image sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        cell.name.text =hotel.name;
        cell.address.text =hotel.address;
        cell.distance.text =hotel.distance;
    }else{
        if (indexPath.row>=1) {
            experienceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"experienceCell" forIndexPath:indexPath];
            //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
            NSArray *experiences = model.experience;
            NSDictionary *experience = experiences[indexPath.row-1];
            
            //ShouYe *hotels = _arr[indexPath.row];
            //将http请求的字符串转换为NSURL
            NSURL *url = [NSURL URLWithString:experience.image];
            [cell.logo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
            cell.name.text =experience.name;
            cell.categoryName.text =experience.categoryName;
            cell.price.text =experience.price;
            
        }
    }
    
    if (_arr2.count !=0) {
        experienceCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"experienceCell" forIndexPath:indexPath];
        //根据当前正在渲染的细胞的行号，从对应的数组中拿到这一行所匹配的活动字典
        
        
        ShouYe *hotels = _arr2[indexPath.row];
        //将http请求的字符串转换为NSURL
        NSURL *url = [NSURL URLWithString:hotels.image];
        [cell.logo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        cell.name.text =hotels.name;
        cell.categoryName.text =hotels.categoryName;
        cell.price.text =hotels.price;
    }
    return cell;
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
        ShouYe *activity=_arr[indexPath.row];
        // NSLog(@"%@",_arr[indexPath.row]);
        //获取下一页的这个实例
        DetailViewController *detailVC= segue.destinationViewController;
        //把数据给下一页预备好的接收容器
        detailVC.detailA=activity;
    }
}

@end
