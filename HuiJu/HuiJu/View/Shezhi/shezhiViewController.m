//
//  shezhiViewController.m
//  HuiJu
//
//  Created by admin1 on 2017/9/4.
//  Copyright © 2017年 shiki. All rights reserved.
//

#import "shezhiViewController.h"

@interface shezhiViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property (weak, nonatomic) IBOutlet UIButton *xiugaiTX;
- (IBAction)xiugaiAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (strong, nonatomic) NSArray *shezhiArr;


@end

@implementation shezhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _shezhiArr= @[@{@"biaoti":@"昵称",@"neirong":@"name"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //if([Utilities loginCheck]){
    switch (indexPath.section) {
        case 0:
            [self performSegueWithIdentifier:@"shezhitonichen" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"shezhitoxingbie" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"shezhitochusheng" sender:self];
            break;
        default:
            [self performSegueWithIdentifier:@"shezhitoshenfen" sender:self];
            break;
    }
}


- (IBAction)xiugaiAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
