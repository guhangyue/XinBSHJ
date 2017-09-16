//
//  CitilesViewController.m
//  HuiJu
//
//  Created by IMAC on 2017/9/7.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "CitilesViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface CitilesViewController ()<CLLocationManagerDelegate>{
    BOOL firstVisit;
}
@property (strong,nonatomic) NSDictionary *cities;
@property (strong,nonatomic) NSArray *keys;
@property(strong,nonatomic) CLLocationManager *locMgr;
@property(strong,nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CitilesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"sadasdasdasdasd");
    // Do any additional setup after loading the view.
    [self dataInitialize];
    [self uiLayout];
}
//每次将要离开这个页面的时候
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //关掉开关
    [_locMgr stopUpdatingLocation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)uiLayout{
    if (![[[StorageMgr singletonStorageMgr]objectForKey:@"LocCity"]isKindOfClass:[NSNull class]]) {
        if ([[StorageMgr singletonStorageMgr]objectForKey:@"LocCity"]!=nil) {
            //已经获得了定位，将定位到的城市显示在按钮上；
            [_cityBtn setTitle:[[StorageMgr singletonStorageMgr]objectForKey:@"LocCity"] forState:UIControlStateNormal];
            //_cityBtn.titleLabel.text=[NSString stringWithFormat:@"%@您现在所在的城市:",_cityBtn];
            _cityBtn.enabled=YES;
            
            return;
            
        }
        
        
    }
    //当还没有获得定位的情况下去执行定位功能
    [self LocationStart];
}

-(void)LocationStart{
    _locMgr=[CLLocationManager new];
    //签协议
    _locMgr.delegate = self;
    //设置定位到的设备，位移多少距离进行一次识别
    _locMgr.distanceFilter = kCLDistanceFilterNone ;
    //设置把地球分割成边长多少精度的方块
    _locMgr.desiredAccuracy =  kCLLocationAccuracyBest;
    //打开定位服务的开关（开始定位)
    [_locMgr startUpdatingLocation];
}
//用Model的方式返回上一页
/*- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}*/
-(void)dataInitialize{
    firstVisit = YES;
    //创建文件管理器
    NSFileManager *fileMgr=[NSFileManager defaultManager];
    //获取要读取的文件的路经
    NSString *filePath= [[NSBundle mainBundle] pathForResource:@"Cities" ofType:@"plist"];
    //判断路径下是否存在文件
    if ([fileMgr fileExistsAtPath:filePath]) {
        //将文件内容读取为对应的格式
        NSDictionary *fileContent= [NSDictionary dictionaryWithContentsOfFile:filePath];
        //判断读取文件是否损坏
        if (fileContent) {
            NSLog(@"fileContent = %@",fileContent);
            _cities =fileContent;
            //提前字典中所有的键
            NSArray *rawkeys=[fileContent allKeys];
            //根据(localizedStandCompare:)（本地化升序）对rawkeys排序
            _keys = [rawkeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        }
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _keys.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //获取当前正在渲染的组的名称
    NSString *key = _keys[section];
    //根据组的名称，作为键来查询到对应的值（整个值就是这一组城市对应的城市数组）
    NSArray *sectionCities = _cities[key];
    //返回这一组城市的个数来作为行数
    return sectionCities.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    NSString *key = _keys[indexPath.section];
    NSArray *sectionCities = _cities[key];
    NSDictionary*city = sectionCities[indexPath.row];
    cell.textLabel.text = city[@"name"];
    return cell;
    
}
//设置组的标题文字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _keys[section];
}
//设置section header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = _keys[indexPath.section];
    NSArray *sectionCities = _cities[key];
    NSDictionary*city = sectionCities[indexPath.row];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"ResetHome" object:city[@"name"]] waitUntilDone:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//设置右侧快捷键栏
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _keys;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cityAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSNotificationCenter *noteCenter=[NSNotificationCenter defaultCenter];
    // [noteCenter postNotificationName:@"ResetHome" object:nil];
    NSNotification *note=[NSNotification notificationWithName:@"ResetHome" object:[[StorageMgr singletonStorageMgr] objectForKey:@"LocCity"]];
    //[noteCenter postNotification:note];
    //结合线程的通知，（表示先让通知接收者完成它收到通知后要做的事以后再执行别的任务）
    [noteCenter performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
    //回到上一页
    [self dismissViewControllerAnimated:YES completion:nil];
}
//定位失败时
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    if(error){
        switch (error.code) {
            case kCLErrorNetwork:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
                break;
            case kCLErrorDenied:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
                break;
            case kCLErrorLocationUnknown:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw" , nil) andTitle:nil onView:self];
                break;
            default:
                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError" , nil) andTitle:nil onView:self];
                break;
        }
    }
}
//定位成功时
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    // NSLog(@"维度：%f",newLocation.coordinate.latitude);
    // NSLog(@"经度：%f",newLocation.coordinate.longitude);
    _location = newLocation;
    //用flag思想判断是否可以去根据定位拿城市
    if(firstVisit){
        firstVisit = ! firstVisit;
        //根据定位拿城市
        [self getRegeoViaCoordinate];
    }
}
-(void)getRegeoViaCoordinate{
    //duration表示从now开始过3个SEC
    dispatch_time_t duration = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    //用duration这个设置好的策略去做某些事
    dispatch_after(duration, dispatch_get_main_queue(), ^{
        //正式做事情
        CLGeocoder *geo = [CLGeocoder new];
        //反向地理编码
        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(!error){
                CLPlacemark *first = placemarks.firstObject;
                NSDictionary *locDict = first.addressDictionary;
                NSLog(@"locDict = %@",locDict);
                NSString *cityStr = locDict[@"City"];
                cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
                [[StorageMgr singletonStorageMgr] removeObjectForKey:@"LocCity"];
                //将定位的城市保存进单例化全局变量
                [[StorageMgr singletonStorageMgr]addKey:@"LocCity" andValue:cityStr];
                //修改城市按钮标题
                [_cityBtn setTitle:cityStr forState:UIControlStateNormal];
                //
                _cityBtn.enabled=YES;
                
                
                
            }
        }];
        //关掉开关
        [_locMgr stopUpdatingLocation];
    });
}

@end
