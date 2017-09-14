//
//  xingbieViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/6.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "xingbieViewController.h"
#import "UserModel.h"
@interface xingbieViewController ()
@property (weak, nonatomic) IBOutlet UIButton *xingbieBtn;
- (IBAction)xingbieAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIToolbar *Toolbar;
- (IBAction)quxiao:(UIBarButtonItem *)sender;
- (IBAction)queding:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;
@property (weak, nonatomic) UserModel*user;
@property (strong, nonatomic) NSArray*pickerArr;
@end

@implementation xingbieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    _pickerArr = @[@"男", @"女"];
    // Do any additional setup after loading the view.
    _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    _xingbieBtn.titleLabel.text=_user.gender;
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
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    
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
#pragma mark - Picker View Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerArr[row];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)xingbieAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _Toolbar.hidden =NO;
    _datePicker.hidden =NO;
}
- (IBAction)quxiao:(UIBarButtonItem *)sender {
}

- (IBAction)queding:(UIBarButtonItem *)sender {
}
@end
