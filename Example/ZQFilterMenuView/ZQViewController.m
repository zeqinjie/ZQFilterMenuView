//
//  ZQViewController.m
//  ZQFilterMenuView
//
//  Created by zhengzeqin on 06/15/2020.
//  Copyright (c) 2020 zhengzeqin. All rights reserved.
//

#import "ZQViewController.h"
#import "ZQFliterMenuBarView.h"
@interface ZQViewController ()

@end

@implementation ZQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ZQFliterMenuBarView *barView = [[ZQFliterMenuBarView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 54)];
    [self.view addSubview:barView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
