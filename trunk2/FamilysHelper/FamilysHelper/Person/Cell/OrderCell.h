//
//  OrderCell.h
//  FamilysHelper
//
//  Created by zhouwengang on 15/6/6.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderCell : UITableViewCell
typedef void(^Blockcancel)();
@property (nonatomic,copy)Blockcancel bockcancel;
@property (weak, nonatomic) IBOutlet UILabel *lbl_ordernum;
@property (weak, nonatomic) IBOutlet UILabel *lbl_goodsname;
@property (weak, nonatomic) IBOutlet UILabel *lbl_buyBbTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbl_totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbl_payStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbl_leaveWords;
@property (weak, nonatomic) IBOutlet UILabel *lbl_originalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbl_goodsPrice;
@property (weak, nonatomic) IBOutlet UIButton *but_gopay;
@property (weak, nonatomic) IBOutlet UIButton *but_cancel;
@property (weak, nonatomic) IBOutlet UILabel *lbl_order;
@property (weak, nonatomic) IBOutlet UIImageView *lbl_image;
@property (strong, nonatomic) IBOutlet EGOImageView *iv_imagename;
@property (strong,nonatomic)UIButton *selectButton;

- (IBAction)gopay:(id)sender;
- (IBAction)cancel:(id)sender;


-(void) bindMsgModel:(OrderModel*)model index:(NSInteger)index isEdit:(BOOL)isEdit;

-(void) initView;
@end
