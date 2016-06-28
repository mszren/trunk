//
//  SearchController.m
//  FamilysHelper
//
//  Created by 我 on 15/8/19.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "SearchController.h"
#import "UserInfoViewController.h"

@interface SearchController ()<UITextFieldDelegate>

@end

@implementation SearchController{
    UITextField *_account;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
}

-(void)initView{
    
    [self setWhiteNavBg];
    [self initializeWhiteBackgroudView:@"添加朋友"];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"查找" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 90, 20)];
    nameLabel.text = @"微享号/昵称";
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = COLOR_GRAY_DEFAULT_OPAQUE_7a;
    [self.view addSubview:nameLabel];
    
    _account = [[UITextField alloc]initWithFrame:CGRectMake(10, 40, SCREEN_WIDTH - 20, 30)];
    _account.delegate = self;
    _account.borderStyle = UITextBorderStyleRoundedRect;
    _account.placeholder = @"请输入用户名或手机号或家人号";
    _account.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_account];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_account resignFirstResponder];
    return  YES;
}


-(void)rightItemAction:(UIBarButtonItem *)sender{
    if ([_account.text isEqualToString:@""]) {
        
        [ToastManager showToast:@"请输入搜索条件" withTime:Toast_Hide_TIME];
        [_account resignFirstResponder];
        return;
    }
    else{
        
        UserInfoViewController *userinfo=[[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
        userinfo.phone=_account.text;
        [self.navigationController pushViewController:userinfo animated:YES];
    }
    
    _account.text = @"";
    [_account resignFirstResponder];
    
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

@end
