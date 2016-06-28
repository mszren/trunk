//
//  ShareViewController.m
//  FamilysHelper
//
//  Created by zhouwengang on 15/6/16.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "ShareViewController.h"
#import "EGOTableView.h"
#import "IndexService.h"
#import "ShareCell.h"
#import "ShareDetailViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface ShareViewController () <UITableViewDataSource, UITableViewDelegate, EGOTableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) EGOTableView* tableView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, strong) DataModel* dataModel;

@end

@implementation ShareViewController
@synthesize messageListner;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    _refreshing = NO;
    _dataModel = [AppCache loadCache:CACHE_INDEX_MORESHAERE];
    if (!_dataModel) {
        [_tableView launchRefreshing];
    }
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 14, SCREEN_WIDTH - 160, 17)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"分享赚";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;

    _tableView = [[EGOTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TopBarHeight - 20)];

    _tableView.backgroundColor = [UIColor whiteColor];

    _tableView.backgroundView = nil;

    _tableView.dataSource = self;

    _tableView.delegate = self;

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.pullingDelegate = self;

    _tableView.autoScrollToNextPage = NO;
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;

    [self.view addSubview:_tableView];
}

- (void)pullingTableViewDidStartRefreshing:(EGOTableHeaderView*)tableView
{
    if (_dataModel) {
        _dataModel.nextCursor = 0;
        _dataModel.previousCursor = 0;
    }
    _refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1f];
}

- (void)pullingTableViewDidStartLoading:(EGOTableView*)tableView
{
    _refreshing = NO;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1f];
}

- (NSDate*)pullingTableViewRefreshingFinishedDate
{

    return [NSDate date];
}

- (NSDate*)pullingTableViewLoadingFinishedDate
{

    return [NSDate date];
}

- (void)loadData
{
    [[IndexService shareInstance] getShareListV6:[CurrentAccount currentAccount].uid
                                             mid:_dataModel.nextCursor
                                       onSuccess:^(DataModel* dataModel) {
                                           if (dataModel.code == 200) {

                                               if (_dataModel && !_refreshing) {
                                                   [_dataModel.data addObjectsFromArray:dataModel.data];
                                                   _dataModel.code = dataModel.code;
                                                   _dataModel.nextCursor = dataModel.nextCursor;
                                                   _dataModel.previousCursor = dataModel.previousCursor;
                                                   _dataModel.error = dataModel.error;
                                               }
                                               else
                                                   _dataModel = dataModel;

                                               [AppCache saveCache:CACHE_INDEX_MORESHAERE Data:_dataModel];
                                               [_tableView tableViewDidFinishedLoading];
                                               [_tableView reloadData];
                                           }

                                           if (dataModel.code == 20001) {
                                               [_tableView tableViewDidFinishedLoading];
                                               _tableView.reachedTheEnd = YES;
                                               [_tableView reloadData];
                                           }

                                       }];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 232;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return ((NSArray*)_dataModel.data).count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* ShareCellId = @"ShareCell.h";
    ShareCell* shareCell = [tableView dequeueReusableCellWithIdentifier:ShareCellId];
    if (!shareCell) {
        shareCell = [[ShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ShareCellId];
        shareCell.backgroundColor = COLOR_RED_DEFAULT_BackGround;
        shareCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    ShareModel* share = _dataModel.data[indexPath.row];
    [shareCell bindModel:share];
    return shareCell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    ShareModel* share = _dataModel.data[indexPath.row];
    NSString* strURL = [NSString stringWithFormat:@"%@/ibsApp/page/fenxiang/fxz_wzxq.html?share_id=%ld&userId=%ld", JAVA_API, (long)share.shareId, (long)[CurrentAccount currentAccount].uid];
    NSString* flag = @"fenxiang";
    NSDictionary* dic = @{ ACTION_Controller_Name : self,
        ACTION_Web_URL : strURL,
        ACTION_Web_Title : @"文章详情",
        ACTION_Web_flag : flag };
    [self RouteMessage:ACTION_SHOW_WEB_INFO withContext:dic];
}

#pragma mark
#pragma mark DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"ic_tywnr"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    
    [_tableView hideFooterViewAndHeadViewState];
    NSString *text = @"没有活动哦!";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                                 NSForegroundColorAttributeName: COLOR_GRAY_DEFAULT_OPAQUE_b9};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

#pragma mark -

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    [_tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{

    [_tableView tableViewDidEndDragging:scrollView];
}

- (void)onBtnBack:(UIButton*)sender
{

    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
