//
//  shezhiViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "shezhiViewController.h"
#import "shezhiTableViewCell.h"
#import "UserModel.h"
@interface shezhiViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property (weak, nonatomic) IBOutlet UIButton *xiugaiTX;
- (IBAction)xiugaiAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *shezhiTableview;
@property (strong, nonatomic) NSMutableArray *shezhiArr;
@property (strong, nonatomic) UIActivityIndicatorView *juhua;
@property (strong, nonatomic) UserModel *user;


@end

@implementation shezhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    
    // Do any additional setup after loading the view.
    //_shezhiArr= @[@{@"biaoti":@"昵称",@"neirong":@"name"},@{@"biaoti":@"昵称",@"neirong":@"name"},@{@"biaoti":@"昵称",@"neirong":@"name"},@{@"biaoti":@"昵称",@"neirong":@"name"}];
    if ([Utilities loginCheck]) {
        //已登录
        
        _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        _shezhiArr = [[NSMutableArray alloc]initWithObjects:@{@"biaoti":@"昵称",@"neirong":_user.nickname},@{@"biaoti":@"性别",@"neirong":_user.gender},@{@"biaoti":@"生日",@"neirong":_user.dob},@{@"biaoti":@"身份证号码",@"neirong":_user.idCardNo}, nil];
        [_touxiang sd_setImageWithURL:[NSURL URLWithString:_user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
    }else{
        _touxiang.image=[UIImage imageNamed:@"ic_user_head"];
        
    }
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

#pragma mark - table view

//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _shezhiArr.count;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    shezhiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shezhiTableViewCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _shezhiArr[indexPath.section];
    cell.biaoti.text = dict[@"biaoti"];
    cell.neirong.text = dict[@"neirong"];
    return cell;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
    return 1.f;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)naviConfig{
    
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 100, 255);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
}
//用Model的方式返回上一页
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //if([Utilities loginCheck]){
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"shezhitonichen" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"shezhitoxingbie" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"shezhitochusheng" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"shezhitoshenfen" sender:self];
            break;
    }
}
//-(void)networkRequest{
//    _juhua=[Utilities getCoverOnView:self.view];
//    
//    NSLog(@"%@",_user.nickname);
//    NSDictionary *para = @{@"memberId":_user.memberId,@"name":_user.nickname,@"birthday":_user.dob,@"gender":_user.gender,@"identificationcard":_user.idCardNo};
//    [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
//        [_juhua stopAnimating];
//        NSLog(@"responseObject:%@",responseObject);
//        if([responseObject[@"resultFlag"]integerValue] == 8001){
//            //         NSDictionary *result= responseObject[@"result"];
//            
//            
//            
//            
//            
//        }else{
//            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
//            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
//            
//        }
//    } failure:^(NSInteger statusCode, NSError *error) {
//        [_juhua stopAnimating];
//        //业务逻辑失败的情况下
//        [Utilities popUpAlertViewWithMsg:@"网络请求失败" andTitle:nil onView:self];
//    }];
//    
//}

- (IBAction)xiugaiAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
