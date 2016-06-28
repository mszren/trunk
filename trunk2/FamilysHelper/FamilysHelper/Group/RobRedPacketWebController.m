//
//  RobRedPacketWebController.m
//  FamilysHelper
//
//  Created by 曹亮 on 15/4/15.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "RobRedPacketWebController.h"


@interface RobRedPacketWebController (){
    
    MBProgressHUD *_hud;
}
@end
@implementation RobRedPacketWebController

- (id)init{
    self = [super init];
    if (self) {
        //        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initializeWhiteBackgroudView:@"群红包"];
    
    
    webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 20 )];
    
    NSURLRequest *  request;
    request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    webView.scalesPageToFit = YES;
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setWhiteNavBg];
    
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)initializeWhiteBackgroudView:(NSString *) titileStr
{
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_btn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLab.backgroundColor= [UIColor clearColor];
    titleLab.textColor = HomeNavBarBgColor;
    titleLab.font = HomeNavBarTitleFont;
    titleLab.text = titileStr;
    titleLab.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLab;
}

- (void)leftItemAction:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)webView:(UIWebView *)lwebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)lwebView{
    
    [webView stringByEvaluatingJavaScriptFromString:@"myJsAndroid.jsStartLoading()"];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)lwebView{
    
    [webView stringByEvaluatingJavaScriptFromString:@"myJsAndroid.jsStartLoading()"];
    _hud.hidden = YES;
}


@end
