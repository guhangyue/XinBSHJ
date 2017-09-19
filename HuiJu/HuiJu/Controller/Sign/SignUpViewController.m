//
//  SignUpViewController.m
//  HuiJu
//
//  Created by IMAC on 2017/9/2.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "SignUpViewController.h"
#import "UserModel.h"


@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)registrationBtn:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *registrationBtn;
@property(strong,nonatomic) UIActivityIndicatorView *aiv;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [_passWordTextField setSecureTextEntry:YES];
    [_confirmPwdTextField setSecureTextEntry:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uiLayout{
    //判断是否存在记忆体
    if (![[Utilities  getUserDefaults:@"userPhone"] isKindOfClass:[NSNull class]]) {
        if ([Utilities  getUserDefaults:@"userPhone"] != nil) {
            //将它显示在用户名输入框中
            _userNameTextField.text = [Utilities getUserDefaults:@"userPhone"];
        }
    }
    
}

//让根视图结束编辑状态，到达收起键盘的目的
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)readyForEncoding
{
    _aiv=[Utilities getCoverOnView:self.view];
    
    [RequestAPI requestURL:@"/login/getKey" withParameters:@{@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject)
     {
         //NSLog(@"responseObject":%@,responseObject);
         if ([responseObject[@"resultFlag"]integerValue]==8001)
         {
             [_aiv stopAnimating];
             NSDictionary *result=responseObject[@"result"];
             NSString *modulus = result[@"modulus"];
             NSString *exponent = result[@"exponent"];
             //对内容进行MD5加密
             NSString *md5Str=[_passWordTextField.text getMD5_32BitString];
             
             
             //用模数和指数对MD5密码进行加密过后的密码进行加密   categary
             NSString *rsaStr=[NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
             [self signInWithEncryptPwd:rsaStr];
         }else{
             //[_aiv stopAnimating];
             NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
             [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
         }
     }failure:^(NSInteger statusCode, NSError *error) {
        // [_aiv stopAnimating];
         //业务逻辑失败的情况下
         [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
     }];
    [_aiv stopAnimating];

}

- (void)naviConfig {
    //设置导航条标题文字
    self.navigationItem.title = @"注册";
    //设置导航条颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = [UIColor darkGrayColor];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏.
    self.navigationController.navigationBar.hidden = NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = YES;
}

-(void)signInWithEncryptPwd:(NSString *)encryptPwd
{
    NSDictionary *parameter = @{@"memberId" : _userNameTextField.text, @"userPwd" : _passWordTextField.text,@"nickname": _nickNameTextField.text};
    [RequestAPI requestURL:@"/register" withParameters:parameter andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_aiv stopAnimating];
        NSLog(@"responseObject=%@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            NSDictionary *result=responseObject[@"result"];
            UserModel *user=[[UserModel alloc]initWithDictionary:result];
            //将用户获取到的信息打包存储到单例化全局变量
            [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:user];
            //单独将用户的ID也存储进去单例化全局变量中来作为用户是否已经登录的判断依据，同时也方便其他所有的页面更快捷的使用用户ID这个参数
            [[StorageMgr singletonStorageMgr]addKey:@"memberId" andValue:user.memberId];
            //如果键盘还开着 就让他收回去
            [self.view endEditing:YES];
            //清空密码输入框的内容
            _passWordTextField.text=@"";
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:_userNameTextField.text];
            //用model的方式返回上一页
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
    }];
}




- (IBAction)registerAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSLog(@"111");
     [_aiv stopAnimating];
    if(_userNameTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的手机号" andTitle:nil onView:self];
        return;
    }
    if(_passWordTextField.text.length == 0){
        [Utilities popUpAlertViewWithMsg:@"请输入您的密码" andTitle:nil onView:self];
        return;
    }
    if(_passWordTextField.text.length < 6 || _passWordTextField.text.length > 18){
        [Utilities popUpAlertViewWithMsg:@"您的密码必须在6~18之间" andTitle:nil onView:self];
        return;
    }

    if (_confirmPwdTextField.text == _passWordTextField.text ) {
        [self readyForEncoding];
    }
    else {
        [Utilities popUpAlertViewWithMsg:@"两次输入密码不一致" andTitle:@"提示" onView:self];
    }
    //判断某个字符串中是否每个字符都是数字(invertedSet:反向设置，Digits：数字)
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if(_userNameTextField.text.length < 11 || [_userNameTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound){
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    //无输入异常的情况下，开始正式执行登录接口
    [self readyForEncoding];


}

#pragma mark - 收起键盘
//按键盘上的Return键收起键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//按键盘以外的任意部位收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

- (IBAction)registrationBtn:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
