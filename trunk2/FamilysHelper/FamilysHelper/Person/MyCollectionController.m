//
//  MyCollectionController.m
//  FamilysHelper
//
//  Created by hubin on 15/7/22.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "MyCollectionController.h"
#import "EGOTableView.h"
#import "UserService.h"
#import "MyCollectionCell.h"
#import "MyCollectionModel.h"
#import "MyMerchantCell.h"
#import "MyActivityCell.h"
#import "TopicModel.h"
#import "GoodsModel.h"
#import "EditView.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface MyCollectionController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, EGOTableViewDelegate, UISearchControllerDelegate, UISearchDisplayDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>{
    ASIHTTPRequest* _request;
    DataModel* _dataModel;
    NSInteger types;
    BOOL _iRefresh;
    NSMutableIndexSet *_indexSetToDel;
    NSMutableArray *_deldectOrders;
    NSMutableString *_delectOrderNums;
}
@property (nonatomic, strong) UIView* screeningView;
@property (nonatomic, strong) UIView* typeView;
@property (nonatomic, strong) EGOTableView* tableView;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UILabel* interactionText;
@property (nonatomic, strong) UILabel* businessText;
@property (nonatomic, strong) UILabel* activityText;


@end

@implementation MyCollectionController{
    EditView *_editView;
    BOOL _isEdit;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWhiteNavBg];
    [self initView];
    //默认为互动
    _interactionText.textColor=COLOR_RED_DEFAULT_78;
    _dataModel=[AppCache loadCache:CACHE_PERSON_MYCOLLECTION];
    if(_dataModel&&((MyCollectionModel*)_dataModel.data[0]).objectType==1){
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
    [self loadData];

 }

- (void)pullingTableViewDidStartLoading:(EGOTableView*)tableView
{
    _iRefresh = NO;
    [self loadData];
 }

- (NSDate*)pullingTableViewRefreshingFinishedDate
{
    
    return [NSDate date];
}

- (NSDate*)pullingTableViewLoadingFinishedDate
{
    
    return [NSDate date];
}
- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(types==1){
        return 76;
    }else if(types==3){
        return 181;
    }else if(types==2){
        return 145;
    }else{
        return 215;
    }
}
- (void)initView
{
    _isEdit = NO;
    _dataModel.nextCursor=0;
    types=1;
    _indexSetToDel = [[NSMutableIndexSet alloc]init];
    _deldectOrders = [[NSMutableArray alloc]initWithCapacity:0];
    _delectOrderNums = [[NSMutableString alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 14, SCREEN_WIDTH - 160, 17)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我的收藏";
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = COLOR_RED_DEFAULT_78;
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStylePlain target:self action:@selector(showTypeView:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _tableView = [[EGOTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TopBarHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.pullingDelegate = self;
    _tableView.autoScrollToNextPage = NO;
    _tableView.emptyDataSetDelegate= self;
    _tableView.emptyDataSetSource = self;
    [self.view addSubview:_tableView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onLongPress:)];
    [_tableView addGestureRecognizer:longPress];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SearchBarHeight)];
    [_searchBar setBackgroundColor:COLOR_GRAY_LIGHT];
    _searchBar.barTintColor = TableSeparatorColor;
    [_searchBar.layer setBorderWidth:1];
    [_searchBar.layer setBorderColor:TableSeparatorColor.CGColor];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    _searchBar.keyboardType = UIKeyboardAppearanceDefault;
    _tableView.tableHeaderView = _searchBar; //把搜索框放在表头
    
    //筛选View
    _screeningView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    _screeningView.backgroundColor=COLOR_GRAY_DEFAULT_255;
    [self.view addSubview:_screeningView];
    UILabel* leftColor = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 5, 20)];
    leftColor.backgroundColor = COLOR_RED_DEFAULT_78;
    [_screeningView addSubview:leftColor];
    UILabel* screeningText = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 40, 20)];
    screeningText.text = @"筛选";
    screeningText.font = [UIFont systemFontOfSize:20];
    screeningText.textColor=RGBACOLOR(0, 0, 0, 1);
    [_screeningView addSubview:screeningText];
    
    _interactionText = [[UILabel alloc] initWithFrame:CGRectMake(25, 55, 30, 15)];
    _interactionText.tag=1;
    _interactionText.text = @"互动";
    _interactionText.font = [UIFont systemFontOfSize:15];
    _interactionText.textColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.5];
    _interactionText.userInteractionEnabled=YES;
    UITapGestureRecognizer* interactionTapHit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTypeButton:)];
    [_interactionText addGestureRecognizer:interactionTapHit];
    [_screeningView addSubview:_interactionText];

    _businessText = [[UILabel alloc] initWithFrame:CGRectMake(85, 55, 30, 15)];
    _businessText.tag=3;
    _businessText.text = @"商家";
    _businessText.font = [UIFont systemFontOfSize:15];
    _businessText.textColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.5];
    _businessText.userInteractionEnabled=YES;
    UITapGestureRecognizer* businessTapHit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTypeButton:)];
    [_businessText addGestureRecognizer:businessTapHit];
    [_screeningView addSubview:_businessText];

    _activityText = [[UILabel alloc] initWithFrame:CGRectMake(145, 55, 30, 15)];
    _activityText.tag=2;
    _activityText.text = @"活动";
    _activityText.font = [UIFont systemFontOfSize:15];
    _activityText.textColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.5];
    _activityText.userInteractionEnabled=YES;
    UITapGestureRecognizer* activityTapHit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTypeButton:)];
    [_activityText addGestureRecognizer:activityTapHit];
    [_screeningView addSubview:_activityText];

    _screeningView.hidden=YES;
    
    //分类弹出层
    _typeView=[[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, SCREEN_HEIGHT-135)];
    _typeView.backgroundColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.3];
    [self.view addSubview:_typeView];
    _typeView.hidden=YES;
    UITapGestureRecognizer* tapHit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHideView:)];
    [_typeView addGestureRecognizer:tapHit];
    
    _editView = [[EditView alloc]
                 initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TopBarHeight - 54, SCREEN_WIDTH, 34)];
    [_editView.cancelButton addTarget:self
                               action:@selector(onBtnCancel:)
                     forControlEvents:UIControlEventTouchUpInside];
    [_editView.deletButton addTarget:self
                              action:@selector(onBtnDelet:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editView];
    _editView.hidden = YES;


}

- (void)loadData{
    if(_request){
        [_request cancel];
    }
    _request=[[UserService shareInstance] getMyCollectList:_searchBar.text type:types nextCursor:_dataModel.nextCursor userId:[[CurrentAccount currentAccount] uid] OnSuccess:^(DataModel *dataModel) {
        if(dataModel.code==200){
            
            if(_dataModel && !_iRefresh){
                [_dataModel.data addObjectsFromArray:dataModel.data];
                _dataModel.code = dataModel.code;
                _dataModel.nextCursor = dataModel.nextCursor;
                _dataModel.previousCursor = dataModel.previousCursor;
                _dataModel.error = dataModel.error;
            }else{
                _dataModel=dataModel;
            }
            [AppCache saveCache:CACHE_PERSON_MYCOLLECTION Data:_dataModel];
        }
        [_tableView reloadData];
        [_tableView tableViewDidFinishedLoading];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    
        return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
         return ((NSArray*)_dataModel.data).count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(types==1){
    static NSString* moreCellId = @"MyCollectionCell";
    
    MyCollectionCell* myCollectionCell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
    if (!myCollectionCell) {
        myCollectionCell = [[MyCollectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellId];
        myCollectionCell.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        myCollectionCell.backgroundColor = COLOR_RED_DEFAULT_BackGround;
    }
            [myCollectionCell bindData:_dataModel.data[indexPath.row]];
        return myCollectionCell;
    }else if(types==3){
        static NSString* moreCellId = @"MyMerchantCell";
        
        MyMerchantCell* myMerchantCell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
        if (!myMerchantCell) {
            myMerchantCell = [[MyMerchantCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellId];
            myMerchantCell.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
            myMerchantCell.backgroundColor = COLOR_RED_DEFAULT_BackGround;
        }
            [myMerchantCell bindData:_dataModel.data[indexPath.row]];
        return myMerchantCell;

        
    }else if(types==2){
        static NSString* moreCellId = @"MyActivityCell";
        
        MyActivityCell* myActivityCell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
        if (!myActivityCell) {
            myActivityCell = [[MyActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:moreCellId];
            myActivityCell.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
            myActivityCell.backgroundColor = COLOR_RED_DEFAULT_BackGround;
        }
            [myActivityCell bindData:_dataModel.data[indexPath.row]];
        return myActivityCell;
    }

    return nil;
}
//UISearchBarDelegate协议中定义的方法，当开始编辑时（搜索框成为第一响应者时）被调用。
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{   //搜索条输入文字修改时触发

    if (_dataModel) {
        _dataModel.nextCursor = 0;
        _dataModel.previousCursor = 0;
    }
    _iRefresh = YES;
    [self loadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar
{
    _searchBar.showsCancelButton = YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    _searchBar.text=@"";
    if (_dataModel) {
        _dataModel.nextCursor = 0;
        _dataModel.previousCursor = 0;
    }
    _iRefresh = YES;
    [self loadData];
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _searchBar.showsCancelButton = NO;
    [_searchBar resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (_isEdit) {
        [_indexSetToDel addIndex:indexPath.row];
        
    }else{
        if(!_dataModel.data){
            return;
        }
        MyCollectionModel* myCollectionModel=(MyCollectionModel*)_dataModel.data[indexPath.row];
        if(types==1){
            TopicModel* topicModel = [TopicModel alloc];
            topicModel.publishId=myCollectionModel.objectId;
            topicModel.tribeld=myCollectionModel.triberId;
            NSDictionary* dic = [NSDictionary
                                 dictionaryWithObjectsAndKeys:self, ACTION_Controller_Name, topicModel,
                                 ACTION_Controller_Data, nil];
            [self RouteMessage:ACTION_SHOW_BANGBANG_TOPICDETAIL withContext:dic];
            topicModel=nil;
        }else
            if(types==2){
                [self RouteMessage:ACTION_SHOW_BANGBANG_ACTIVITYDETAIL
                       withContext:@{ ACTION_Controller_Name : messageListner,
                                      ACTION_Controller_Data : [NSString stringWithFormat:@"%d",myCollectionModel.objectId] }];
            }else if(types==3){
                GoodsModel* goods = [GoodsModel alloc];
                goods.shopName = myCollectionModel.shopname;
                goods.shopId = myCollectionModel.objectId;
                NSDictionary* dic = @{ ACTION_Controller_Name : self, ACTION_Controller_Data : goods };
                
                [self RouteMessage:ACTION_SHOW_BANGBANG_GOODSDETAIL
                       withContext:dic];
                goods=nil;
            }
        myCollectionModel=nil;
    }

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isEdit) {
        [_indexSetToDel removeIndex:indexPath.row];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}

#pragma mark
#pragma mark DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    [_tableView hideFooterViewAndHeadViewState];
    NSString *text;
    if (![_searchBar.text isEqualToString:@""]) {
        text = @"没有搜索到哦!";
    }
    else
        text = @"还没有收藏哦!";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                                 NSForegroundColorAttributeName: COLOR_GRAY_DEFAULT_OPAQUE_b9};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"ic_tywnr"];
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

-(void)showTypeView:(UIBarButtonItem*) UIBarButtonItem{
    _typeView.hidden=NO;
    _screeningView.hidden=NO;
}
-(void)onHideView:(UIBarButtonItem*) UIBarButtonItem{
    _typeView.hidden=YES;
    _screeningView.hidden=YES;
}
-(void)onTypeButton:(id) uiLabel{
    _isEdit = NO;
    [_tableView setEditing:NO animated:YES];
    _typeView.hidden=YES;
    _screeningView.hidden=YES;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)uiLabel;
    UIView *tapView =tap.view;

    if(tapView.tag==1){
        _interactionText.textColor=COLOR_RED_DEFAULT_78;
        _businessText.textColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.5];
        _activityText.textColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.5];
        types=1;
        _searchBar.text=@"";
    }else if(tapView.tag==3){
        _interactionText.textColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.5];
        _businessText.textColor=COLOR_RED_DEFAULT_78;
        _activityText.textColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.5];
        types=3;
        _searchBar.text=@"";
    }else if(tapView.tag==2){
        _interactionText.textColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.5];
        _businessText.textColor=[UIColor colorWithRed:50.0 / 255.0 green:50.0 / 255.0 blue:50.0 / 255.0 alpha:0.5];
        _activityText.textColor=COLOR_RED_DEFAULT_78;
        types=2;
        _searchBar.text=@"";
    }
    [_tableView launchRefreshing];
}

#pragma mark
#pragma mark -- UILongPressGestureRecognizer
-(void)onLongPress:(UILongPressGestureRecognizer *)sender{
    
    _editView.hidden = NO;
    _isEdit = YES;
    [_tableView setEditing:YES animated:YES];
    
}

#pragma mark
#pragma mark -- UIButtonAction
-(void)onBtnCancel:(UIButton *)sender{
    
    _editView.hidden = YES;
    _isEdit = NO;
    [_indexSetToDel removeAllIndexes];
    [_tableView setEditing:NO animated:YES];
    
}

-(void)onBtnDelet:(UIButton *)sender{
    if (_indexSetToDel.count > 0) {
        
        [_deldectOrders addObjectsFromArray:[_dataModel.data objectsAtIndexes:_indexSetToDel ]];
        for (NSInteger i = 0; i<_deldectOrders.count; i++) {
            MyCollectionModel *model = _deldectOrders[i];
            if (i == _deldectOrders.count - 1) {
                [_delectOrderNums appendFormat:@"%d",model.collectId];
            }
            else{
                [_delectOrderNums appendFormat:@"%d,",model.collectId];
            }
        }
        _editView.hidden = YES;
        _isEdit = NO;
        [self deldecOrderNums];
        _delectOrderNums = [[NSMutableString alloc]initWithCapacity:0];
        [_deldectOrders removeAllObjects];
        [_indexSetToDel removeAllIndexes];
        [_tableView setEditing:NO animated:YES];
    }
    else{
        
        [ToastManager showToast:@"请选择删除对象" withTime:Toast_Hide_TIME];
        return;
    }
    
}

-(void)deldecOrderNums{
    [[UserService shareInstance] deleteMyCollect:_delectOrderNums OnSuccess:^(DataModel *dataModel) {
        if (dataModel.code == 202) {
            [ToastManager showToast:@"删除收藏成功" withTime:Toast_Hide_TIME];
        }
        else
            [ToastManager showToast:dataModel.error withTime:Toast_Hide_TIME];
        
        if (_dataModel) {
            _dataModel.nextCursor = 0;
            _dataModel.previousCursor = 0;
        }
        _iRefresh = YES;
        [self loadData];
        
    }];
}

@end
