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
#import <SDWebImage/UIImageView+WebCache.h>
#import "SignInViewController.h"
@interface shezhiViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property (weak, nonatomic) IBOutlet UIButton *xiugaiTX;
- (IBAction)xiugaiAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *shezhiTableview;
@property (strong, nonatomic) NSMutableArray *shezhiArr;
@property (strong, nonatomic) UIActivityIndicatorView *juhua;
@property (strong, nonatomic) UserModel *user;
@property (weak, nonatomic) IBOutlet UIButton *tuichu;
- (IBAction)tuichuAction:(UIButton *)sender forEvent:(UIEvent *)event;


@end

@implementation shezhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
     
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"refresh" object:nil];
    [self dengluzhihou];
    
}
-(void)dengluzhihou
{
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
//-(void)refresh{
//    
//}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)shuaxin
{
    [self request];
}
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
    //取消细胞的选中状态
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




- (void)request{
    NSString *str = [Utilities uniqueVendor];
    //_juhua = [Utilities getCoverOnView:self.view];
    NSDictionary *prarmeter = @{@"deviceType" : @7001, @"deviceId" : str};
    //开始请求
    [RequestAPI requestURL:@"/login/getKey" withParameters:prarmeter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //成功以后要做的事情
        //NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            //[_juhua stopAnimating];
            NSDictionary *result = responseObject[@"result"];
            NSString *exponent = result[@"exponent"];
            NSString *modulus = result[@"modulus"];
            NSString *string = [[StorageMgr singletonStorageMgr]objectForKey:@"pwd"];
            //对内容进行MD5加密
            NSString *md5Str = [string getMD5_32BitString];
            //用模数与指数对MD5加密过后的密码进行加密
            NSString *rsaStr = [NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
            //加密完成执行接口
            [self signInWithEncryptPwd:rsaStr];
        }else{
            //[_juhua stopAnimating];
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //[_juhua stopAnimating];
        //失败以后要做的事情
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}



-(void)signInWithEncryptPwd:(NSString *)encryptPwd
{
    NSString *userName = [[StorageMgr singletonStorageMgr]objectForKey:@"userName"];
    [RequestAPI requestURL:@"/login" withParameters:@{@"userName":userName, @"password":encryptPwd,@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject){
        //[_aiv stopAnimating];
        NSLog(@"responseObject=%@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            NSDictionary *result=responseObject[@"result"];
            UserModel*user=[[UserModel alloc]initWithDictionary:result];
            //将用户获取到的信息打包存储到单例化全局变量
            [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:user];
            [[StorageMgr singletonStorageMgr]addKey:@"MemberId" andValue:user.memberId];
            //让根视图结束编辑状态达到收起键盘的目的
            [self.view endEditing:YES];
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:userName];
            [self dengluzhihou];
            [_shezhiTableview reloadData];
            
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //[_aiv stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
    }];
}

- (IBAction)xiugaiAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)tuichuAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionA=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exit];
    }];
    UIAlertAction *actionB=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)exit{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[StorageMgr singletonStorageMgr]removeObjectForKey:@"MemberId"];
    NSNotification *note = [NSNotification notificationWithName:@"LeftSwitch" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
}



@end
