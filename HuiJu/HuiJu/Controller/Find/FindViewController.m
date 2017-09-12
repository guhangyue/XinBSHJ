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
    NSInteger flag;
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
@property (weak, nonatomic) IBOutlet UIView *brightView;
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
@property (strong,nonatomic)NSMutableArray *TypeArr;
@property (strong,nonatomic)NSString *distance;
@property (strong,nonatomic)NSString *classificationId;
@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ClubArr = [NSMutableArray new];
    _TypeArr=[NSMutableArray new];
    //_classificationArr=[[NSMutableArray alloc] initWithObjects:@"全部分类", nil];
    _cityArr=[[NSArray alloc] initWithObjects:@"全城",@"1qianmi",@"2qianmi",@"3qianmi",@"4qianmi", nil];
    _distanceArr=[[NSArray alloc] initWithObjects:@"按距离",@"按人气", nil];
    PageNum=1;
    pageSize =10;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView)];
    tapGesture.delegate = self;
    [self.brightView addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view.
    //_collectionView.allowsSelection = NO;
    [self setRefreshControl];
    [self naviConfig];
    //[self uiLayout];
}
- (void)viewWillAppear:(BOOL)animated{
    [self dataInitialize];
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
    if(flag == 1){
        return _cityArr.count;
    }
    if(flag == 2){
        return _classificationArr.count;
    }
    if(flag == 3){
        return _distanceArr.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScreeningTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    if(flag == 1){
        cell.Label.text = _cityArr[indexPath.row];
    }
    if(flag == 2){
        cell.Label.text = _classificationArr[indexPath.row];
        
    }
    if(flag == 3){
        cell.Label.text = _distanceArr[indexPath.row];
    }
    return cell;
    
}
//设置每一组中每一行被点击以后要做的事情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(flag == 1){
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
    if(flag == 2){
        
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
    if(flag == 3){
        if(indexPath.row == 0){
            [self ClubRequest];
        }
        if(indexPath.row == 1){
            [self TypeClubRequest];
        }
        
        
    }
    
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
    UIView *tgp = [UIView new];
    tgp.backgroundColor = UIColorFromRGB(192, 192, 192);
    cell.selectedBackgroundView = tgp;
    return cell;
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
- (void)setRefreshControl{
    
    UIRefreshControl *acquireRef = [UIRefreshControl new];
    [acquireRef addTarget:self action:@selector(acquireRef) forControlEvents:UIControlEventValueChanged];
    acquireRef.tag = 10001;
    [_collectionView addSubview:acquireRef];
    
}
//会所列表下拉刷新事件
- (void)acquireRef{
    PageNum = 1;
    if(flag == 1){
        // _distance = @"5000";
        //_avi = [Utilities getCoverOnView:self.view];
        [self qianmiTypeRequest];
        return;
    }
    if(flag == 2){
        [self classificationClubRequest];
        return;
    }
    if(flag == 3){
        [self TypeClubRequest];
        return;
    }else{
        [self ClubRequest];
    }
}
//细胞将要出现时调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(indexPath.row == _ClubArr.count -1){
        if(PageNum != totalPage){
            PageNum ++;
            if(flag == 1){
                [self qianmiTypeRequest];
                return;
            }
            if(flag == 2){
                [self classificationClubRequest];
                return;
            }
            if(flag == 3){
                [self TypeClubRequest];
                return;
            }
            else{
                [self ClubRequest];
                NSLog(@"不是最后一页");
            }

    }
    }
}


#pragma mark - request
-(void)dataInitialize{
    // [self hotRequest];
    [self ClubRequest];
}
//请求健身类型ID
-(void)TypeRequest{
        
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡"};
    [RequestAPI requestURL:@"/clubController/getNearInfos" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
            // NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *features = responseObject[@"result"][@"features"];
            NSArray *featureForm = features[@"featureForm"];
            for(NSDictionary *dict in featureForm){
                    FindModel *model = [[FindModel alloc]initWithType:dict];
                    [_TypeArr addObject:model];
                    //    NSLog(@"数组里的是：%@",model.fName);
                }
            [_TypeArr removeAllObjects];
            _classificationArr  = [[NSMutableArray alloc]initWithObjects:@"全部分类", nil];
            for(int i = 0; i < 4;i++){
                    FindModel *model = _TypeArr[i];
                    [_classificationArr addObject:model.fName];
                }
                
                //[_tableView reloadData];
            [self ClubRequest];
                
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
- (void)ClubRequest{
    _brightView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(PageNum),@"perPage":@(pageSize),@"Type":@0};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        // NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            
            if(PageNum == 1){
                [_ClubArr removeAllObjects];
            }
            for(NSDictionary *dict in array){
                FindModel *model = [[FindModel alloc]initWithClub:dict];
                [_ClubArr addObject:model];
                
            }
            
            [_collectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}
//距离
-(void)qianmiTypeRequest{
    _brightView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(PageNum),@"perPage":@(pageSize),@"Type":@0,@"distance":_distance};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //  NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            NSDictionary  *pageDict =result[@"pagingInfo"];
            totalPage = [pageDict[@"totalPage"]integerValue];
            
            if(PageNum == 1){
                [_ClubArr removeAllObjects];
            }
            
            for(NSDictionary *dict in array){
                FindModel *model = [[FindModel alloc]initWithClub:dict];
                
                [_ClubArr addObject:model];
                // NSLog(@"数组里的是%@",model);
                
            }
            NSLog(@"按%@米请求",_distance);
            [_collectionView reloadData];
            
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
 
}
//种类
-(void)classificationClubRequest{
    _brightView.hidden = YES;
    _avi = [Utilities getCoverOnView:self.view];
    NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(PageNum),@"perPage":@(pageSize),@"Type":@0,@"featureId":_classificationId};
    [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        //  NSLog(@"responseObject:%@", responseObject);
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        if([responseObject[@"resultFlag"] integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *array = result[@"models"];
            if(PageNum == 1){
                [_ClubArr removeAllObjects];
            }
            
            for(NSDictionary *dict in array){
                FindModel *model = [[FindModel alloc]initWithClub:dict];
                
                [_ClubArr addObject:model];
                
            }
            [_collectionView reloadData];
        }else{
            //业务逻辑失败的情况下
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"result"] integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
        [ref endRefreshing];
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
 
}
//按人气
- (void)TypeClubRequest{
        _brightView.hidden = YES;
        _avi = [Utilities getCoverOnView:self.view];
        NSDictionary *para =  @{@"city":@"无锡",@"jing":@"120.300000",@"wei":@"31.570000",@"page":@(PageNum),@"perPage":@(pageSize),@"Type":@1};
        [RequestAPI requestURL:@"/clubController/nearSearchClub" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
            //  NSLog(@"responseObject:%@", responseObject);
            [_avi stopAnimating];
            UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
            [ref endRefreshing];
            if([responseObject[@"resultFlag"] integerValue] == 8001){
                NSDictionary *result = responseObject[@"result"];
                NSArray *array = result[@"models"];
                [_ClubArr removeAllObjects];
                for(NSDictionary *dict in array){
                    FindModel *model = [[FindModel alloc]initWithClub:dict];
                    
                    [_ClubArr addObject:model];
                    
                }
                [_collectionView reloadData];
            }else{
                //业务逻辑失败的情况下
                NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"] integerValue]];
                [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            }
            
        } failure:^(NSInteger statusCode, NSError *error) {
            [_avi stopAnimating];
            UIRefreshControl *ref = (UIRefreshControl *)[_collectionView viewWithTag:10001];
            [ref endRefreshing];
            [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
        }];
        
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
    flag = 1;
    self.HeightConstraint.constant = _cityArr.count *40 ;
    _brightView.hidden = NO;
    [_tableView reloadData];
    
}

- (IBAction)distanceAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 2;
    self.HeightConstraint.constant = _cityArr.count *40 ;
    _brightView.hidden = NO;
    [_tableView reloadData];
}

- (IBAction)classificationAction:(UIButton *)sender forEvent:(UIEvent *)event {
    flag = 3;
    self.HeightConstraint.constant = _distanceArr.count *40;
    _brightView.hidden = NO;
    [_tableView reloadData];
}
@end
