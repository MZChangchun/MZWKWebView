//
//  WelcomeViewController.m
//  xuesheng
//
//  Created by Mr.Yang on 16/6/15.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"

@interface WelcomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl * page;
@property (nonatomic, strong) UIScrollView  * scroll;
@property (nonatomic, assign) NSInteger     number;

@end

@implementation WelcomeViewController

- (UIPageControl *)page{
    if (!_page) {
        _page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 30)];
        _page.center = CGPointMake(DEVICE_WIDTH / 2.0, DEVICE_HEIGHT - 20);
        _page.backgroundColor = [UIColor clearColor];
        _page.numberOfPages = self.number;//总页数
        _page.currentPage = 0;
        _page.pageIndicatorTintColor = [UIColor grayColor];
        _page.currentPageIndicatorTintColor = [UIColor greenColor];
        [_page addTarget:self action:@selector(pageChage) forControlEvents:UIControlEventTouchUpInside];//
    }
    return _page;
}
- (UIScrollView *)scroll{
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:DEVICE_BOUNDS];
        _scroll.backgroundColor = [UIColor whiteColor];
        _scroll.contentSize = CGSizeMake(DEVICE_WIDTH * self.number, 0);
        _scroll.showsVerticalScrollIndicator = 0;
        _scroll.showsHorizontalScrollIndicator = 0;
        _scroll.indicatorStyle = 2;//风格
        _scroll.pagingEnabled = 1;//翻动整页
        _scroll.delegate = self;
        NSString * iphone = @"";
        NSString * imageName = @"";
        if (iPhone4) {
            iphone = @"4";
        }else if (iPhone5){
            iphone = @"5";
        }else if (iPhone6){
            iphone = @"6";
        }else if (iPhone6plus){
            iphone = @"6p";
        }
        for (int i = 0; i < self.number; i ++) {
            imageName = [NSString stringWithFormat:@"welcome%@%d", iphone, i];
            NSLog(@"------\t %@", imageName);
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH * i, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
            NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
            NSLog(@"--path \t %@", path);
            imageView.image = [UIImage imageWithContentsOfFile:path];
            [_scroll addSubview:imageView];
            if (i == self.number - 1) {
                
                UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
                button.center = CGPointMake(DEVICE_WIDTH / 2.0 + DEVICE_WIDTH * (self.number - 1), DEVICE_HEIGHT - 60);
                button.layer.cornerRadius = 5.0;
                button.layer.masksToBounds = 1;
                button.layer.borderColor = [UIColor yellowColor].CGColor;
                button.layer.borderWidth = 1.5;
                button.backgroundColor = [UIColor whiteColor];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitle:@"进入应用" forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                [button addTarget:self action:@selector(loginIn) forControlEvents:UIControlEventTouchUpInside];
                [_scroll addSubview:button];
                
            }
        }
    }
    return _scroll;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.number = 5;
    [self.view addSubview:self.scroll];
    [self.view addSubview:self.page];
}
//页控制器点击方法
- (void)pageChage{
    self.scroll.contentOffset = CGPointMake(DEVICE_WIDTH * self.page.currentPage, 0);//偏移
}
//开始滚动就不停的调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    NSLog(@"开始滚动aaa>>>>>>>%f",scrollView .contentOffset.x);//从0.5开始,因为滑动时必须偏移一点才能调用
    self.page.currentPage=scrollView.contentOffset.x/DEVICE_WIDTH;
    if (scrollView.contentOffset.x >= DEVICE_WIDTH * (self.number - 1) + 150 ) {
        [self loginIn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loginIn{
    //跳转到主界面
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].delegate window].rootViewController= [[LoginViewController alloc] init];
    });
}


@end
