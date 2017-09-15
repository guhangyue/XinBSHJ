//
//  SafetyViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/7.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "SafetyViewController.h"

@interface SafetyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tiJiaoBtn;
- (IBAction)tiJiaoAction:(UIBarButtonItem *)sender;

@end

@implementation SafetyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
    //关掉自动调整scrollView的属性
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    self.navigationItem.title = @"意见反馈";
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(20, 124, 236);
    
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
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
-(void)netRequest{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:[[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"] forKey:@"memberId"];
    NSDictionary *para1 = @{@"memberId":@"para",@"message":_textView.text};
    [RequestAPI requestURL:@"/clubFeedback" withParameters:para1 andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"resposeObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            [Utilities popUpAlertViewWithMsg:@"感谢您的反馈" andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        NSLog(@"statusCode = %ld",(long)statusCode);
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
}
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tiJiaoAction:(UIBarButtonItem *)sender {
    [self netRequest];
}
@end
