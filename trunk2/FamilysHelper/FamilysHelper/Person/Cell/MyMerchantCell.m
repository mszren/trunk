//
//  MyMerchantCell.m
//  FamilysHelper
//
//  Created by hubin on 15/7/23.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "MyMerchantCell.h"


@interface MyMerchantCell (){
    
}

@property(nonatomic,strong)EGOImageView* imagUrl;
@property(nonatomic,strong)EGOImageView* shopImageUrl;
@property(nonatomic,strong)UILabel* shopnameLabel;
@property(nonatomic,strong)UILabel* goodsNameLabel;
@property(nonatomic,strong)UILabel* contextLabel;
@property(nonatomic,strong)UILabel* priceLabel;
@property(nonatomic,strong)MyCollectionModel* myCollectionModel;
@property (nonatomic,strong)UIView* backView;
@end;


@implementation MyMerchantCell
@synthesize messageListner;



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        
        _imagUrl = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"pic_default_60x60"]];
        _imagUrl.frame = CGRectMake(10, 10, 55, 55);
        _imagUrl.userInteractionEnabled = YES;
        [_backView addSubview:_imagUrl];
        _shopnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, SCREEN_WIDTH - 115,15)];
        _shopnameLabel.textColor = [UIColor blackColor];
        _shopnameLabel.font = [UIFont systemFontOfSize:15];
        _shopnameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [_backView addSubview:_shopnameLabel];
        UIView* shopView = [[UIView alloc] initWithFrame:CGRectMake(0, 76, SCREEN_WIDTH, 95)];
        shopView.backgroundColor = [UIColor whiteColor];
        [self addSubview:shopView];
        _shopImageUrl=[[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"pic_default_95x95"]];
        _shopImageUrl.frame = CGRectMake(10, 10, 75, 75);
        _shopImageUrl.userInteractionEnabled = YES;
        [shopView addSubview:_shopImageUrl];
        _contextLabel=[[UILabel alloc] initWithFrame:CGRectMake(95, 20, SCREEN_WIDTH - 105,15)];
        _contextLabel.textColor = [UIColor blackColor];
        _contextLabel.font = [UIFont systemFontOfSize:15];
        _contextLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [shopView addSubview:_contextLabel];
        _goodsNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(95, 35+15/2, SCREEN_WIDTH - 105,10)];
        _goodsNameLabel.textColor = [UIColor grayColor];
        _goodsNameLabel.font = [UIFont systemFontOfSize:10];
        _goodsNameLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [shopView addSubview:_goodsNameLabel];
        _priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(95, 60, SCREEN_WIDTH - 105,15)];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.font = [UIFont systemFontOfSize:15];
        _priceLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [shopView addSubview:_priceLabel];


    }
    return self;
}



- (void)bindData:(MyCollectionModel*)model{
    _myCollectionModel=model;
    if(!model){
        return;
    }
    if(model.imageUrl&&![@"" isEqualToString:model.imageUrl]){
        _imagUrl.imageURL=[AppImageUtil getImageURL:model.imageUrl Size:_imagUrl.frame.size];
    }
    _shopnameLabel.text=model.shopname;
    
    if(model.shopImageUrl&&![@"" isEqualToString:model.shopImageUrl]){
        _shopImageUrl.imageURL=[AppImageUtil getImageURL:model.shopImageUrl Size:_shopImageUrl.frame.size];
    }
    _contextLabel.text=model.context;
    _goodsNameLabel.text=model.goodsName;
    _priceLabel.text=[NSString stringWithFormat:@"¥%d.00",model.price];
}
@end
