//
//  FindViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/5.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "FindViewController.h"
#import "PhotoCollectionViewCell.h"
#import "FindModel.h"
#import "ScreeningTableViewCell.h"
@interface FindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
{
    NSInteger fiag;
    NSInteger totalPage;
    NSInteger PageNum;
    NSInteger pageSize;
    BOOL isLast;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIButton *distanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *classificationBtn;
@property (weak,nonatomic) IBOutlet UIView *brightView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightConstraint;

- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)distanceAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)classificationAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong,nonatomic)UIActivityIndicatorView *avi;
@property (strong,nonatomic)NSArray *cityArr;
@property (strong,nonatomic)NSArray *distanceArr;
@property (strong,nonatomic)NSMutableArray *ClubArr;
@property (strong,nonatomic)NSMutableArray *classificationArr;
@property (strong,nonatomic)NSMutableArray *Type;
@property (strong,nonatomic)NSString *distance;
@property (strong,nonatomic)NSString *classificationId;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ClubArr = [NSMutableArray new];
    _Type=[NSMutableArray new];
    _classificationArr=[[NSMutableArray alloc] initWithObjects:@"全部分类", nil];
    _cityArr=[[NSArray alloc] initWithObjects:@"全城",@"1千米",@"2千米",@"3千米",@"4千米", nil];
    _distanceArr=[[NSArray alloc] initWithObjects:@"按距离",@"按人气", nil];
    PageNum=1;
    pageSize =10;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)];
    tapGesture.delegate = self;
    [self.brightView addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view.
    [self naviConfig];
    _collectionView.allowsSelection = NO;
    [self dataInitialize];
    //[self uiLayout];
    
}
- (void)viewWillAppear:(BOOL)animated{
    // [self dataInitialize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)naviConfig{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationItem.title = @"发现";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(20, 124, 236);
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否被隐藏
    self.navigationController.navigationBar.hidden = NO;
    
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent = NO;
}
-(void)clickView{
    _brightView.hidden = YES;
    //NSLog(@"view 被点击了");
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.tableView]) {
        //  NSLog(@"手势被中断了");
        return NO;
        
    }
    return YES;
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(fiag == 1){
        return _cityArr.count;
    }
    if(fiag == 2){
        return _cityArr.count;
    }
    if(fiag == 3){
        return _distanceArr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScreeningTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    if(fiag == 1){
        cell.Label.text = _cityArr[indexPath.row];
    }
    if(fiag == 2){
        cell.Label.text = _cityArr[indexPath.row];
        
    }
    if(fiag == 3){
        cell.Label.text = _distanceArr[indexPath.row];
    }
    return cell;
    
}
//设置每一组中每一行被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(fiag == 1){
        if(indexPath.row == 0){
            [self ClubRequest];//默认按距离请求
        }
        if(indexPath.row == 1){
            _distance = @"1000";
            [self qianmiTypeRequest];
        }
        if(indexPath.row == 2){
            _distance = @"2000";
            [self qianmiTypeRequest];
        }
        if(indexPath.row == 3){
            _distance = @"3000";
            [self qianmiTypeRequest];
        }
        if(indexPath.row == 4){
            _distance = @"4000";
            [self qianmiTypeRequest];
        }
        
        
    }
    if(fiag == 2){
        
        if(indexPath.row == 0){
            [self ClubRequest];
        }
        if(indexPath.row == 1){
            _classificationId = @"1";
            [self classificationClubRequest];
        }
        if(indexPath.row == 2){
            _classificationId = @"2";
            [self classificationClubRequest];
        }
        if(indexPath.row == 3){
            _classificationId = @"3";
            [self classificationClubRequest];
        }
        if(indexPath.row == 4){
            _classificationId = @"4";
            [self classificationClubRequest];
        }
        
    }
    if(fiag == 3){
        if(indexPath.row == 0){
            [self ClubRequest];
        }
        if(indexPath.row == 1){
            [self TypeClubRequest];
        }
        
        
    }
    
}

#pragma mark - request
-(void)dataInitialize{
    // [self hotRequest];
    [self ClubRequest];
}
- (void)ClubRequest{
    
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@"1",@"perPage":@"6"};
    [RequestAPI requestURL:@"/homepage/choice" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSArray *result = responseObject[@"result"][@"models"];
            for(NSDictionary *dict in result){
                FindModel *model = [[FindModel alloc]initWithClub:dict];
                [_ClubArr  addObject: model];
                
                NSLog(@"数组里的是：%@",model.clubName);
            }
            [_collectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//每组有多少个细胞（item）
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _ClubArr.count;
}
//每个items长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    FindModel *model = _ClubArr[indexPath.item];
    cell.clubName.text = model.clubName;
    cell.clubaddress.text = model.address;
    //NSLog(@"%@",model.address);
    cell.clubdistance.text = [NSString stringWithFormat:@"%@米",model.distance];
    NSURL *URL = [NSURL URLWithString:model.Image];
    [cell.clubImage sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"默认"]];
    //cell.clubImage.image=[UIImage imageNamed:@"Default"];
    return cell;
}
//设置每个cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((UI_SCREEN_W - 5)/2,185);
}
//最小的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
-(void)qianmiTypeRequest{
    
}
-(void)classificationClubRequest{
    
}
-(void)TypeClubRequest{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //写跳转语句
    
    
}
- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    fiag = 1;
    self.HeightConstraint.constant = _cityArr.count *40 ;
    _brightView.hidden = NO;
    [_tableView reloadData];
    
}

- (IBAction)distanceAction:(UIButton *)sender forEvent:(UIEvent *)event {
}

- (IBAction)classificationAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
