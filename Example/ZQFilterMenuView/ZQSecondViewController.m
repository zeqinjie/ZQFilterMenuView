//
//  ZQSecondViewController.m
//  ZQFilterMenuView_Example
//
//  Created by zhengzeqin on 2020/6/28.
//  Copyright © 2020 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import "ZQSecondViewController.h"
#import "ZQFliterMenuBarView.h"
#import <Masonry/Masonry.h>
@interface ZQSecondViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation ZQSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ZQFliterMenuBarView *barView = [[ZQFliterMenuBarView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 54)];
    [self.view addSubview:barView];
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
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

@end
