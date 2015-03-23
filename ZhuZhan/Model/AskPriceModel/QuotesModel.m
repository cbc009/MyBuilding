//
//  QuotesModel.m
//  ZhuZhan
//
//  Created by 汪洋 on 15/3/21.
//
//

#import "QuotesModel.h"

@implementation QuotesModel
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.a_isVerified = dict[@"isVerified"];
    self.a_loginId = dict[@"loginId"];
    self.a_loginName = dict[@"loginName"];
    self.a_status = dict[@"status"];
}
@end


@implementation QuotesDetailModel

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.a_id = dict[@"id"];
    self.a_bookBuildingId = dict[@"bookBuildingId"];
    self.a_createdTime = dict[@"createdTime"];
    self.a_isAccepted = dict[@"isAccepted"];
    self.a_quoteContent = dict[@"quoteContent"];
    self.a_quoteIsVerified = dict[@"quoteIsVerified"];
    self.a_quoteUser = dict[@"quoteUser"];
    self.a_status = dict[@"status"];
    self.a_tradeCode = dict[@"tradeCode"];
}

@end