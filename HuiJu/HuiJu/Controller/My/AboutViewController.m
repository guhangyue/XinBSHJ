//
//  AboutViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/7.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "AboutViewController.h"
#import <CoreImage/CoreImage.h>
#import "UserModel.h"
@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationItem];
    [self netRequest];
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
    //设置标题文字
    self.navigationItem.title = @"我的推广";
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    //[self.navigationController.navigationBar setBarTintColor:HEAD_THEMECOLOR];
    //设置导航条的风格颜色
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 124, 236);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //设置导航条是否隐藏
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
    //    NSString *ID = [[StorageMgr singletonStorageMgr]objectForKey:@"MemberId"];
    //    NSDictionary *para = @{@"memberId":ID};
    [RequestAPI requestURL:@"/mySelfController/getInvitationCode" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            //    NSDictionary *result = responseObject[@"result"];
            //   _QR = result[@"result"];
            _avi =  responseObject[@"result"];
            
            //创建一个二维码滤镜实例（CIFilter）
            CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
            //滤镜恢复默认设置
            [filter setDefaults];
            //给滤镜添加数据
            NSString *string = [NSString stringWithFormat:@"http://dwz.cn/%@",_avi];
            //将字符串转成二进制数据
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            //通过KVC设置滤镜inputMessage数据
            [filter setValue:data forKeyPath:@"inputMessage"];
            //4.获取生成的图片
            CIImage *ciImg = filter.outputImage;
            //5.设置二维码的前景色和背景颜色
            //CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
            //5.1设置默认值
            //[colorFilter setDefaults];
           // [colorFilter setValue:ciImg forKey:@"inputImage"];
            //[colorFilter setValue:[CIColor colorWithRed:255 green:255 blue:255] forKey:@"inputColor0"];
            //[colorFilter setValue:[CIColor colorWithRed:255 green:0 blue:255 alpha:0] forKey:@"inputColor1"];
            //[colorFilter setValue:[UIColor whiteColor] forKey:@"inputColor1"];
            // 6.获取滤镜输出的图像
            //CIImage *outputImage = [filter outputImage];
            //ciImg = colorFilter.outputImage;
            // 7.将CIImage转成UIImage
            UIImage *image = [self createNonInterpolatedUIImageFormCIImage:ciImg withSize:200];
            
            //显示二维码
            //_codeImage.image = image;
            UIImage *customQrcode = [self imageBlackToTransparent:image withRed:255.f andGreen:255.f andBlue:255.f];
            _codeImage.layer.shadowOffset = CGSizeMake(0, 0.5);  // 设置阴影的偏移量
            _codeImage.layer.shadowRadius = 1;  // 设置阴影的半径
            _codeImage.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
            _codeImage.layer.shadowOpacity = 1; // 设置阴影的不透明度
            _codeImage.image = customQrcode;

        }
    } failure:^(NSInteger statusCode, NSError *error) {
        //失败以后要做的事情
        NSLog(@"statusCode = %ld",(long)statusCode);
        
        [Utilities popUpAlertViewWithMsg:@"网络错误,请稍等再试" andTitle:nil onView:self];
        
    }];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
//遍历图片像素
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*-(void)requst{
    _avi = [Utilities getCoverOnView:self.view];
    
    [RequestAPI requestURL:@"/mySelfController/getInvitationCode" withParameters:@{@"memberId":@2} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"mypromotion:%@", responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            //NSDictionary *result = responseObject[@"result"];
            [_avi stopAnimating];
        }
        else{
            [_avi stopAnimating];
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误,请稍等再试" andTitle:@"提示" onView:self];
    }];
    
    
}*/

@end
