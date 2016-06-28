//
//  MoreActivityViewController.m
//  FamilysHelper
//
//  Created by xujie on 15/7/16.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//
#import "MoreActivityViewController.h"
#import "EGOTableView.h"
#import "IndexService.h"
#import "MoreActivityCell.h"

@interface MoreActivityViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, EGOTableViewDelegate, UISearchControllerDelegate, UISearchDisplayDelegate>{
    ASIHTTPRequest* _request;
    DataModel* _dataModel;
    NSString* titles;
    BOOL _iRefresh;
    //EGOTableView* tableView;
}
@property (nonatomic, strong) EGOTableView* tableView;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UISearchDisplayController* searchDisp;
@property (nonatomic, strong) NSMutableArray* searchResults;

@end

@implementation MoreActivityViewController


- (void)viewDidLoad {
    titles=@"";
    _dataModel.nextCursor=0;
    _iRefresh = NO;
    [self setWhiteNavBg];
    [super viewDidLoad];
    [self initView];
    _dataModel=[AppCache loadCache:CACHE_INDEX_MOREACTIVITY];
    if(_dataModel){
        [_tableView reloadData];
        [_tableView tableViewDidFinishedLoading];
    }else{
        [_tableView launchRefreshing];
    }
}


@synthesize messageListner;

- (void)pullingTableViewDidStartRefreshing:(EGOTableHeaderView*)tableView
{
    if (_dataModel) {
        _dataModel.nextCursor = 0;
        _dataModel.previousCursor = 0;
    }
    _iRefresh = YES;
    [self loadData:NO];
}

- (void)pullingTableViewDidStartLoading:(EGOTableView*)tableView
{
    _iRefresh = NO;
    [self loadData:NO];
}

- (NSDate*)pullingTableViewRefreshingFinishedDate
{
    
    return [NSDate date];
}

- (NSDate*)pullingTableViewLoadingFinishedDate
{
    
    return [NSDate date];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _searchResults = [[NSMutableArray alloc] initWithCapacity:0];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 14, SCREEN_WIDTH - 160, 17)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"更多活动";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = COLOR_RED_DEFAULT_78;
    self.navigationItem.titleView = titleLabel;
    
    _tableView = [[EGOTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TopBarHeight - 20)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.pullingDelegate = self;
    _tableView.autoScrollToNextPage = NO;
    [self.view addSubview:_tableView];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SearchBarHeight)];
    _searchBar.barTintColor = TableSeparatorColor;
    [_searchBar setBackgroundColor:COLOR_GRAY_LIGHT];
    
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.keyboardType = UIKeyboardAppearanceDefault;
    _tableView.tableHeaderView = _searchBar; //把搜索框放在表头
    
    //创建SearchDisplayController并与SearchBar关联
    //参数一：要关联的SearchBar
    //参数二：要搜索的那个TableView所在的视图控制器
    _searchDisp = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisp.searchResultsDataSource = self;
    _searchDisp.searchResultsDelegate = self;
}
- (void)loadData:(BOOL)iRefresh{
    if(_request){
        [_request cancel];
    }
    _request=[[IndexService shareInstance] getMoreBangActivityList:_dataModel.nextCursor title:titles nSuccess:^(DataModel *dataModel) {
        if(dataModel.code==200){

            if(_dataModel){
                if (_iRefresh)
                    [_dataModel.data removeAllObjects];
                
                [_dataModel.data addObjectsFromArray:dataModel.data];
                _dataModel.code = dataModel.code;
                _dataModel.nextCursor = dataModel.nextCursor;
                _dataModel.previousCursor = dataModel.previousCursor;
                _dataModel.error = dataModel.error;
            }else{
                _dataModel=dataModel;
            }
            [AppCache saveCache:CACHE_INDEX_MOREACTIVITY Data:_dataModel];
        }
        [_tableView reloadData];
        [_tableView tableViewDidFinishedLoading];
    }];
}

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 210;
}

//- (CGFloat)tableView:(UITableView*)tableView
//estimatedHeightForHeaderInSection:(NSInteger)section
//{
//    return 40;
//}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView != _tableView) {
        
        return _searchResults.count;
    }
    else {
        return ((NSArray*)_dataModel.data).count;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* moreCellId = @"MoreActivityCell";
    MoreActivityCell* moreActivityCell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
    if (!moreActivityCell) {
        moreActivityCell = [[MoreActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellId];
        moreActivityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        moreActivityCell.backgroundColor = COLOR_RED_DEFAULT_BackGround;
    }
    if (tableView != _tableView) {
        [moreActivityCell bindMoreActivity:_searchResults[indexPath.row]];

    }else{
        [moreActivityCell bindMoreActivity:_dataModel.data[indexPath.row]];
    }
    return moreActivityCell;
}

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (indexPath.section == 0) {
        
        NSArray* listModel = _dataModel.data;
        id obj = listModel[indexPath.row];
        if ([obj isKindOfClass:[ActivityModel class]]) {
            ActivityModel* activityModel = obj;
            [self RouteMessage:ACTION_SHOW_BANGBANG_ACTIVITYDETAIL
                   withContext:@{ ACTION_Controller_Name : messageListner,
                                  ACTION_Controller_Data : activityModel }];
        }
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    
    if (tableView != _tableView) {
        
        [_searchResults removeAllObjects];
        
        for (ActivityModel* activityModel in _dataModel.data) {
            
            NSRange range = [activityModel.title rangeOfString:_searchBar.text];
            if (range.location != NSNotFound) {
                [_searchResults addObject:activityModel];
            }
        }
        
        return 1;
    }
    else {
        return 1;
    }
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

#pragma mark
#pragma mark--ButtonTaget

- (void)onBtnBack:(UIBarButtonItem*)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
