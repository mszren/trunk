//
//  OrderListModel.m
//  Common
//
//  Created by zhouwengang on 15/5/23.
//  Copyright (c) 2015年 FamilyTree. All rights reserved.
//

#import "OrderModel.h"
@implementation OrderModel
-(id)copyWithZone:(NSZone *)zone{
    OrderModel *Ordel=[[OrderModel alloc]init];
    Ordel.consigneePhone=[self.consigneePhone copy];
    Ordel.goodsId=self.goodsId;
    Ordel.goodsPrice=self.goodsPrice;
    Ordel.imagename=[self.imagename copy];
    Ordel.nickname=[self.nickname copy];
    Ordel.shopname=[self.shopname copy];
    Ordel.goodsname=[self.goodsname copy];
    Ordel.createTime=self.createTime;
    Ordel.leaveWords=self.leaveWords;
    Ordel.buyBbTotal=self.buyBbTotal;
    Ordel.payStatus=self.payStatus;
    Ordel.totalPrice=self.totalPrice;
    Ordel.orderId=self.orderId;
    Ordel.shopId=self.shopId;
    Ordel.orderNum=[self.orderNum copy];
    Ordel.originalPrice=self.originalPrice;
    Ordel.bangbi = self.bangbi;
    Ordel.goods = [self.goods copy];
    Ordel.goodsTitle = [self.goodsTitle copy];
    Ordel.customerNum = [self.customerNum copy];
    Ordel.goodsName = [self.goodsName copy];
    Ordel.notice = [self.notice copy];
    Ordel.payType = self.payType;
    Ordel.shopImage = [self.shopImage copy];
    Ordel.shopName = [self.shopName copy];
    Ordel.status = self.status;
    return  Ordel;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.leaveWords forKey:@"leaveWords"];
    [aCoder encodeObject:self.consigneePhone forKey:@"consigneePhone"];
    [aCoder encodeInt64:self.goodsId forKey:@"goodsId"];
    [aCoder encodeInt64:self.goodsPrice   forKey:@"goodsPrice"];
    [aCoder encodeObject:self.imagename forKey:@"imagename"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.shopname forKey:@"shopname"];
    [aCoder encodeObject:self.goodsname forKey:@"goodsname"];
    [aCoder encodeInt64:self.createTime forKey:@"time"];
    [aCoder encodeDouble:self.buyBbTotal forKey:@"buyBbTotal"];
    [aCoder encodeInt64:self.payStatus   forKey:@"payStatus"];
    [aCoder encodeInt64:self.totalPrice forKey:@"totalPrice"];
    [aCoder encodeInt64:self.orderId   forKey:@"orderId"];
    [aCoder encodeInt64:self.shopId   forKey:@"shopId"];
    [aCoder encodeObject:self.orderNum forKey:@"orderNum"];
    [aCoder encodeInt64:self.originalPrice forKey:@"originalPrice"];
    [aCoder encodeInt64:self.bangbi   forKey:@"bangbi"];
    [aCoder encodeObject:self.goods forKey:@"goods"];
    [aCoder encodeObject:self.goodsTitle forKey:@"goodsTitle"];
    
    [aCoder encodeObject:self.customerNum forKey:@"customerNum"];
    [aCoder encodeObject:self.goodsName forKey:@"goodsName"];
    [aCoder encodeInt64:self.payType forKey:@"payType"];
    [aCoder encodeInt64:self.status   forKey:@"status"];
    [aCoder encodeObject:self.notice forKey:@"notice"];
    [aCoder encodeObject:self.shopName forKey:@"shopName"];
    [aCoder encodeObject:self.shopImage forKey:@"shopImage"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.goodsId = [aDecoder decodeIntegerForKey:@"goodsId"];
        self.goodsPrice = [aDecoder decodeIntegerForKey:@"goodsPrice"];
         self.originalPrice = [aDecoder decodeIntegerForKey:@"originalPrice"];
        self.consigneePhone = [aDecoder decodeObjectForKey:@"consigneePhone"];
        self.imagename = [aDecoder decodeObjectForKey:@"imagename"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.shopname = [aDecoder decodeObjectForKey:@"shopname"];
        self.goodsname = [aDecoder decodeObjectForKey:@"goodsname"];
        self.createTime=[aDecoder decodeIntegerForKey:@"time"];
        self.leaveWords = [aDecoder decodeObjectForKey:@"leaveWords"];
        self.buyBbTotal = [aDecoder decodeDoubleForKey:@"buyBbTotal"];
        self.payStatus = [aDecoder decodeIntegerForKey:@"payStatus"];
        self.totalPrice = [aDecoder decodeIntegerForKey:@"totalPrice"];
        self.orderId = [aDecoder decodeIntegerForKey:@"orderId"];
        self.shopId = [aDecoder decodeIntegerForKey:@"shopId"];
        self.orderNum = [aDecoder decodeObjectForKey:@"orderNum"];
        self.bangbi = [aDecoder decodeIntegerForKey:@"bangbi"];
        self.goods = [aDecoder decodeObjectForKey:@"goods"];
        self.goodsTitle = [aDecoder decodeObjectForKey:@"goodsTitle"];
        
        self.payType = [aDecoder decodeIntegerForKey:@"payType"];
        self.status = [aDecoder decodeIntegerForKey:@"status"];
        self.customerNum = [aDecoder decodeObjectForKey:@"customerNum"];
        self.goodsName = [aDecoder decodeObjectForKey:@"goodsName"];
        self.notice = [aDecoder decodeObjectForKey:@"notice"];
        self.shopImage = [aDecoder decodeObjectForKey:@"shopImage"];
        self.shopName = [aDecoder decodeObjectForKey:@"shopName"];
    }
    return self;
}


+(OrderModel *)JsonParse:(NSDictionary *)dict{
    OrderModel *model=[[OrderModel alloc]init];
    
    model.bangbi=([dict objectForKey:@"bangbi"] !=[NSNull null])&&([dict objectForKey:@"bangbi"] !=nil) ?[[dict objectForKey:@"bangbi"] integerValue]:0;
    model.goods=([dict objectForKey:@"goods"] !=[NSNull null])&&([dict objectForKey:@"goods"] !=nil) ?[dict objectForKey:@"goods"] :@"";
    model.goodsTitle=([dict objectForKey:@"goodsTitle"] !=[NSNull null])&&([dict objectForKey:@"goodsTitle"] !=nil) ?[dict objectForKey:@"goodsTitle"] :@"";
    model.consigneePhone=([dict objectForKey:@"consigneePhone"] !=[NSNull null])&&([dict objectForKey:@"consigneePhone"] !=nil)?[dict objectForKey:@"consigneePhone"]:@"";
    model.leaveWords=([dict objectForKey:@"leaveWords"] !=[NSNull null])&&([dict objectForKey:@"leaveWords"] !=nil)?[dict objectForKey:@"leaveWords"]:@"";
    model.imagename=([dict objectForKey:@"imagename"] !=[NSNull null])&&([dict objectForKey:@"imagename"] !=nil)?[dict objectForKey:@"imagename"]:@"";
    model.shopname=([dict objectForKey:@"shopname"] !=[NSNull null])&&([dict objectForKey:@"shopname"] !=nil)?[dict objectForKey:@"shopname"]:@"";
    model.nickname=([dict objectForKey:@"nickname"] !=[NSNull null])&&([dict objectForKey:@"nickname"] !=nil)?[dict objectForKey:@"nickname"]:@"";
    model.goodsname=([dict objectForKey:@"goodsname"] !=[NSNull null])&&([dict objectForKey:@"goodsname"] !=nil)?[dict objectForKey:@"goodsname"]:@"";
    model.goodsId=([dict objectForKey:@"goodsId"] !=[NSNull null])&&([dict objectForKey:@"goodsId"] !=nil) ?[[dict objectForKey:@"goodsId"] integerValue]:0;
    model.goodsPrice=([dict objectForKey:@"goodsPrice"] !=[NSNull null])&&([dict objectForKey:@"goodsPrice"] !=nil) ?[[dict objectForKey:@"goodsPrice"] integerValue]:0;
     model.originalPrice=([dict objectForKey:@"originalPrice"] !=[NSNull null])&&([dict objectForKey:@"originalPrice"] !=nil) ?[[dict objectForKey:@"originalPrice"] integerValue]:0;
    model.buyBbTotal=([dict objectForKey:@"buyBbTotal"] !=[NSNull null])&&([dict objectForKey:@"buyBbTotal"] !=nil) ?[[dict objectForKey:@"buyBbTotal"] doubleValue]:0;
    model.payStatus=([dict objectForKey:@"payStatus"] !=[NSNull null])&&([dict objectForKey:@"payStatus"] !=nil) ?[[dict objectForKey:@"payStatus"] integerValue]:0;
    model.totalPrice=([dict objectForKey:@"totalPrice"] !=[NSNull null])&&([dict objectForKey:@"totalPrice"] !=nil) ?[[dict objectForKey:@"totalPrice"] integerValue]:0;
    model.orderId=([dict objectForKey:@"orderId"] !=[NSNull null])&&([dict objectForKey:@"orderId"] !=nil) ?[[dict objectForKey:@"orderId"] integerValue]:0;
     model.shopId=([dict objectForKey:@"shopId"] !=[NSNull null])&&([dict objectForKey:@"shopId"] !=nil) ?[[dict objectForKey:@"shopId"] integerValue]:0;
    model.orderNum=([dict objectForKey:@"orderNum"] !=[NSNull null])&&([dict objectForKey:@"orderNum"] !=nil) ?[dict objectForKey:@"orderNum"] :@"";
    NSDictionary *creattime=[dict objectForKey:@"createTime"];
    NSInteger time=[[creattime objectForKey:@"time"] integerValue];
    model.createTime=time;
    
    model.shopName=([dict objectForKey:@"shopName"] !=[NSNull null])&&([dict objectForKey:@"shopName"] !=nil)?[dict objectForKey:@"shopName"]:@"";
    model.shopImage=([dict objectForKey:@"shopImage"] !=[NSNull null])&&([dict objectForKey:@"shopImage"] !=nil)?[dict objectForKey:@"shopImage"]:@"";
    model.customerNum=([dict objectForKey:@"customerNum"] !=[NSNull null])&&([dict objectForKey:@"customerNum"] !=nil)?[dict objectForKey:@"customerNum"]:@"";
    model.goodsName=([dict objectForKey:@"goodsName"] !=[NSNull null])&&([dict objectForKey:@"goodsName"] !=nil)?[dict objectForKey:@"goodsName"]:@"";
    model.notice=([dict objectForKey:@"notice"] !=[NSNull null])&&([dict objectForKey:@"notice"] !=nil)?[dict objectForKey:@"notice"]:@"";
    model.payType=([dict objectForKey:@"payType"] !=[NSNull null])&&([dict objectForKey:@"payType"] !=nil) ?[[dict objectForKey:@"payType"] integerValue]:0;
    model.status=([dict objectForKey:@"status"] !=[NSNull null])&&([dict objectForKey:@"status"] !=nil) ?[[dict objectForKey:@"status"] integerValue]:0;
    
    return model;
}

@end
