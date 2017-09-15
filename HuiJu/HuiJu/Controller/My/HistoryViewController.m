//
//  HistoryViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/7.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "OrderModel.h"
@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *arr;
@property(strong,nonatomic)UIActivityIndicatorView *avi;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//设置导航栏样式
- (void)setNavigationItem{
    //设置标题文字
    self.navigationItem.title = @"我的订单";
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 124, 236);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;

    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    //[self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
/*-(void)request{
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para = @{@"memberId":[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"],@"type":@0};
    [RequestAPI requestURL:@"/orderController/orderList" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"responseObject:%@",responseObject);
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSArray *array = responseObject[@"result"][@"orderList"];
            for(NSDictionary *dict in array){
               //OrderModel *model = [[OrderModel alloc]initWithOrder:dict];
                //[_arr addObject:model];
            }
            [_tableView reloadData];
        }
        
        else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
    }];
    
    
    
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;//_arr.count;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    header.textLabel.textColor = [UIColor darkGrayColor];
    header.textLabel.font = [UIFont systemFontOfSize:13];
    header.contentView.backgroundColor = UIColorFromRGB(240, 239, 245);
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    OrderModel *Model = _arr[section];
   // NSString *upper = [OrderModel.orderNum uppercaseString];
    //NSString *string = [NSString stringWithFormat:@"订单号:%@",upper];
   // return string;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"forIndexPath:indexPath];
    OrderModel *Model = _arr[indexPath.section];
    //NSURL *url = [NSURL URLWithString: Model.imgUrl];
    //[cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"默认"]];
   // cell.OrderName.text = Model.productName;
    //cell.dianMing.text = Model.dianMing;
   // cell.moneyLabel.text = [NSString stringWithFormat:@"%@元",OrderModel.shouldpay];
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
