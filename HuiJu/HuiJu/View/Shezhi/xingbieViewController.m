//
//  xingbieViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/6.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "xingbieViewController.h"
#import "UserModel.h"
//#import "Utilities.h"
#import "shezhiTableViewCell.h"
#import "shezhiViewController.h"
@interface xingbieViewController ()

@property (weak, nonatomic) IBOutlet UIToolbar *Toolbar;
- (IBAction)quxiao:(UIBarButtonItem *)sender;
- (IBAction)queding:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *datePicker;

@property (weak, nonatomic) IBOutlet UITextField *xbtextfiled;
- (IBAction)xbAction:(UITextField *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) UserModel*user;
@property (strong, nonatomic) NSArray*pickerArr;
@property (strong,nonatomic) UIActivityIndicatorView *avi;

@end

@implementation xingbieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    _pickerArr = @[@"男", @"女"];
    // Do any additional setup after loading the view.
    _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    _xbtextfiled.text=_user.gender;
    NSLog(@"性别：%@", @[_user.gender]);
    
    //设置_pickerView选中行
    [_datePicker selectRow:2 inComponent:0 animated:NO];
    //刷新第一列
    [_datePicker reloadComponent:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
////当前页面将要显示的时候，显示导航栏
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}
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

-(void)XB
{
    NSString *xb=_xbtextfiled.text;
    NSNumber *gender;
    if ([xb isEqualToString:@"男"])
    {
        gender=@1;
    }
    else
    {
        gender=@2;
    }
    _avi=[Utilities getCoverOnView:self.view];
    NSDictionary *para=@{@"memberId":_user.memberId,@"gender":gender};
    [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject)
    {
        [_avi stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"responseObject"]integerValue]==8001)
        {
            NSNotification *note = [NSNotification notificationWithName:@"refresh" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
            
        }
        
        
    } failure:^(NSInteger statusCode, NSError *error)
    {
        [_avi stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络请求失败😂" andTitle:nil onView:self];
    }];
}




//#pragma mark - Picker View Delegates
// 多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
// 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerArr.count;
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerArr[row];
}
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    return _datePicker.frame.size.width/4;
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//#pragma mark - Picker View Delegates
//
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    return _pickerArr.count;
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return _pickerArr[row];
//}




- (IBAction)quxiao:(UIBarButtonItem *)sender {
    
    _Toolbar.hidden =YES;
    _datePicker.hidden =YES;
}

- (IBAction)queding:(UIBarButtonItem *)sender
{
    //拿到某一种中选中的行号
    NSInteger row1=[_datePicker selectedRowInComponent:0];
    //根据上面拿到的行号。找到对应的数据（选中行的标题）
    NSString *title1=_pickerArr[row1];
    _xbtextfiled.text = title1;
    //把拿到的按钮显示在按钮上
    // [_XBTextField setTitle:[NSString stringWithFormat:@"%@",title1] forState:(UIControlStateNormal)];
    //[_xbtextfiled setTitle:[NSString stringWithFormat:@"%@",title1]  forState:UIControlStateNormal];
    _Toolbar.hidden=YES;
    _datePicker.hidden=YES;
    [self XB];
    
//    NSDate *date = _datePicker.date;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    NSString *theDate = [formatter stringFromDate:date];
//    //followUpTime = [date timeIntervalSince1970];
//    followUpTime = [Utilities cTimestampFromString:theDate format:@"yyyy-MM-dd HH:mm"];
//    
//    [_chooseTimeBtn setTitle:theDate forState:UIControlStateNormal];
//    _Toolbar.hidden = YES;
//    _datePicker.hidden = YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)xbtextfiled
{
    _Toolbar.hidden =NO;
    _datePicker.hidden =NO;
    return NO;
}


- (IBAction)xbAction:(UITextField *)sender forEvent:(UIEvent *)event {
    _Toolbar.hidden =NO;
    _datePicker.hidden =NO;
}
@end
