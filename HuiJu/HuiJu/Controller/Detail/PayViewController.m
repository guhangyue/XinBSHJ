//
//  PayViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger  selected;
    NSInteger  numst;
}
@property (weak, nonatomic) IBOutlet UILabel *eNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *ClubNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *PirceLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UILabel *zhongPirceLbl;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
- (IBAction)stepperAction:(UIStepper *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *payBtn;
- (IBAction)payAction:(UIBarButtonItem *)sender;
@property (strong,nonatomic)NSArray *arr;

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self uiLayout];
    [self dataInitialize];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置导航栏样式
-(void)setNavigationItem{
    self.navigationItem.title = @"支付";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0, 100, 255);
  
}
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
// 设置最大最小值 初始值
- (void)setStepper:(UIStepper *)stepper {
    // 初始值
    stepper.value = 1;
    // 最大值
    stepper.maximumValue = 100;
    // 最小值
    stepper.minimumValue = 1;
    // 点击增减值
    stepper.stepValue = 1;
}
-(void)uiLayout{
    _eNameLbl.text=_payModel.eName2;
    _ClubNameLbl.text=[NSString stringWithFormat:@"用于 %@",_payModel.eClubName];
    _PirceLbl.text=[NSString stringWithFormat:@"单价：%@元",_payModel.currentPrice];
    _zhongPirceLbl.text=[NSString stringWithFormat:@"%@元",_payModel.currentPrice];
    // _nameLabel.text= _activity.name;
    // _contenLabel.text= _activity.content;
    // _priceLabel.text=[NSString stringWithFormat:@"%@元",_activity.applyFee];
    
       self.tableView.tableFooterView=[UIView new];
    //将表格视图设置为“细胞中”
    self.tableView.editing=YES;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    //用代码来选中表格视图中的某个细胞
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
}
-(void)dataInitialize{
    _arr=@[@"支付宝支付",@"微信支付",@"银联支付"];
    selected=0;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCell" forIndexPath:indexPath];
    cell.textLabel.text=_arr[indexPath.row];
    // Configure the cell...
    
    return cell;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
//设置组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"支付方式";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != selected) {
        selected = indexPath.row;
        //遍历表格视图中所有选中状态下的细胞
        for(NSIndexPath *eachIP in tableView.indexPathsForSelectedRows){
            //当选中的细胞不是当前正在按的这个细胞情况下
            if(eachIP != indexPath){
                //将细胞从选中状态改为不选中状态
                [tableView deselectRowAtIndexPath:eachIP animated:YES];
            }else{
                //[tableView deselectRowAtIndexPath:eachIP animated:YES];
            }
        }
    }
    if (indexPath.row == 0) {
        numst=1;
       // [self performSegueWithIdentifier:@"1" sender:nil];
    }else if (indexPath.row ==1){
        numst=2;
       // [self performSegueWithIdentifier:@"2" sender:nil];
    }else{
        numst=3;
       // [self performSegueWithIdentifier:@"3" sender:nil];
    }
    
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == selected) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)stepperAction:(UIStepper *)sender forEvent:(UIEvent *)event {
    int i = sender.value ;
    //NSInteger  s=[_payModel.currentPrice intValue];
    double s=[[NSString stringWithFormat:@"%.1f",[_payModel.currentPrice doubleValue]]doubleValue];
    NSLog(@"%f",s);
    _numLbl.text =[NSString stringWithFormat:@"%d",i];
    
    _zhongPirceLbl.text=[NSString stringWithFormat:@"%.1f元",i*s];
}
- (IBAction)payAction:(UIBarButtonItem *)sender {
    if (numst==1) {
       
        [self performSegueWithIdentifier:@"1" sender:nil];
    }else if (numst==2){
        
        [self performSegueWithIdentifier:@"2" sender:nil];
    }else{
        
        [self performSegueWithIdentifier:@"3" sender:nil];
    }

}
@end
