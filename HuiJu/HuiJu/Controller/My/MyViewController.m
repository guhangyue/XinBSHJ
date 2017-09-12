//
//  MyViewController.m
//  HuiJu
//
//  Created by IMAC on 2017/9/1.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "MyViewController.h"
#import "myinfoTableViewCell.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *myNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingBtn;
- (IBAction)settingAction:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSArray *myInfoArr;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myInfoArr = @[@{@"title":@"我的订单"},@{@"title":@"我的推广"},@{@"title":@"积分中心"},@{@"title":@"意见反馈"},@{@"title":@"关于我们"}];
    [self naviConfig];
    _myTableView.tableFooterView = [UIView new];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    if ([Utilities loginCheck]) {
        //已登录
        _loginBtn.hidden=YES;
        _myNameLabel.hidden=NO;
        UserModel *user=[[StorageMgr singletonStorageMgr]objectForKey:@"Myinfo"];
        [_headImage sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
        _myNameLabel.text= user.nickname;
        
    }else{
        //未登录
        _loginBtn.hidden=NO;
        _myNameLabel.hidden=YES;
        _headImage.image=[UIImage imageNamed:@"ic_user_head"];
        _myNameLabel.text=@"游客";
    }
    
}
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    //self.navigationItem.title = @"我的列表";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(24, 124, 236);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
    //为导航条左上角创建一个按钮
    //UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    // self.navigationItem.leftBarButtonItem = left;
}
//有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myInfoArr.count;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    myinfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myInfoArr[indexPath.section];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
    return 1.f;
}

//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([Utilities loginCheck]) {
        switch (indexPath.section)
        {
            case 0:
                [self performSegueWithIdentifier:@"AAA" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"BBB" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"CCC" sender:self];
                break;
            case 3:
                [self performSegueWithIdentifier:@"DDD" sender:self];
                break;
            default:
                [self performSegueWithIdentifier:@"EEE" sender:self];
                break;
        }
    }else{
        UINavigationController *signnavi=[Utilities getStoryboardInstance:@"Sign" byIdentity:@"SignNavi"];
        [self presentViewController:signnavi animated:YES completion:nil];
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

- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"HHH" sender:self];

}
- (IBAction)settingAction:(UIBarButtonItem *)sender {
    if ([Utilities loginCheck]) {
        //[self.navigationController setNavigationBarHidden:NO];
        [self performSegueWithIdentifier:@"LLL" sender:self];
    }else{
        
        UINavigationController *shezhiww=[Utilities getStoryboardInstance:@"SheZhi" byIdentity:@"SheZhiNavi"];
        [self presentViewController:shezhiww animated:YES completion:nil];    }
}
@end
