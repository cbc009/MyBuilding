//
//  ProductModel.m
//  ZhuZhan
//
//  Created by 汪洋 on 14-9-4.
//
//

#import "ProductModel.h"
#import "ProjectStage.h"
@implementation ProductModel
-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.a_id = [ProjectStage ProjectStrStage:dict[@"id"]];
    self.a_name = [ProjectStage ProjectStrStage:dict[@"productName"]];
    self.a_content = [ProjectStage ProjectStrStage:dict[@"productDescription"]];
    self.a_imageUrl = [ProjectStage ProjectStrStage:dict[@"productImageLocation"]];
    self.a_commentNumber = [ProjectStage ProjectStrStage:[NSString stringWithFormat:@"%@",dict[@"productCommentsNumber"]]];
}

+ (NSURLSessionDataTask *)GetProductInformationWithBlock:(void (^)(NSMutableArray *posts, NSError *error))block productId:(NSString *)productId startIndex:(int)startIndex{
    NSString *urlStr = [NSString stringWithFormat:@"api/ProductInformation/ProductInformation?productId=%@&pageSize=5&pageIndex=%d",productId,startIndex];
    return [[AFAppDotNetAPIClient sharedClient] GET:urlStr parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"JSON===>%@",JSON);
        if([[NSString stringWithFormat:@"%@",JSON[@"d"][@"status"][@"statusCode"]]isEqualToString:@"1300"]){
            NSMutableArray *mutablePosts = [[NSMutableArray alloc] init];
            for(NSDictionary *item in JSON[@"d"][@"data"]){
                ProductModel *model = [[ProductModel alloc] init];
                [model setDict:item];
                [mutablePosts addObject:model];
            }
            if (block) {
                block([NSMutableArray arrayWithArray:mutablePosts], nil);
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"d"][@"status"][@"errors"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error ==> %@",error);
        if (block) {
            block([NSMutableArray array], error);
        }
        
    }];
}

//POST:
//{
//    "ProductName": ":"产品名字" 必填
//    "ProductDescription":"产品描述"
//    "ProductImageName":"产品图片名字"
//    "ProductImageStrings":"图片base64"
//    "CreatedBy":"创建人"
//}
+ (NSURLSessionDataTask *)AddProductInfomationWithBlock:(void (^)(NSMutableArray *posts, NSError *error))block dic:(NSMutableDictionary *)dic{
    NSString *urlStr = [NSString stringWithFormat:@"api/ProductInfomation/AddProductInfomation"];
    return [[AFAppDotNetAPIClient sharedClient] POST:urlStr parameters:dic success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"JSON===>%@",JSON);
        if([[NSString stringWithFormat:@"%@",JSON[@"d"][@"status"][@"statusCode"]]isEqualToString:@"1300"]){
            NSMutableArray *mutablePosts = [[NSMutableArray alloc] init];
            [mutablePosts addObject:JSON[@"d"][@"data"]];
            if (block) {
                block([NSMutableArray arrayWithArray:mutablePosts], nil);
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"d"][@"status"][@"errors"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error ==> %@",error);
        if (block) {
            block([NSMutableArray array], error);
        }
        
    }];
}

//POST:
//{
//    "productId": ":"产品Id" 必填
//    "PublishedBy":"发布人" 必填
//}
+ (NSURLSessionDataTask *)PublishProductInfomationWithBlock:(void (^)(NSMutableArray *posts, NSError *error))block dic:(NSMutableDictionary *)dic{
    NSString *urlStr = [NSString stringWithFormat:@"api/ProductInfomation/PublishProductInfomation"];
    return [[AFAppDotNetAPIClient sharedClient] POST:urlStr parameters:dic success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"JSON===>%@",JSON);
        if([[NSString stringWithFormat:@"%@",JSON[@"d"][@"status"][@"statusCode"]]isEqualToString:@"1300"]){
            NSMutableArray *mutablePosts = [[NSMutableArray alloc] init];
            [mutablePosts addObject:JSON[@"d"][@"data"]];
            if (block) {
                block([NSMutableArray arrayWithArray:mutablePosts], nil);
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"d"][@"status"][@"errors"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error ==> %@",error);
        if (block) {
            block([NSMutableArray array], error);
        }
        
    }];
}
@end