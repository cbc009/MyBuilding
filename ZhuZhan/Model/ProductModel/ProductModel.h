//
//  ProductModel.h
//  ZhuZhan
//
//  Created by 汪洋 on 14-9-4.
//
//

#import <Foundation/Foundation.h>

@interface ProductModel : NSObject
@property (nonatomic,strong) NSString *a_id;
//名字
@property (nonatomic,strong) NSString *a_name;
//内容
@property (nonatomic,strong) NSString *a_content;

//产品列表压缩图片
@property (nonatomic,strong) NSString *a_imageUrl;
//推广搜索页压缩图片
@property (nonatomic,strong) NSString *a_marketImageUrl;
//原图片
@property (nonatomic,strong) NSString *a_originImageUrl;

//评论数
@property (nonatomic,strong) NSString *a_commentNumber;
@property (nonatomic,strong) NSString *a_createdBy;
@property (nonatomic, strong) NSString *a_imageWidth;
@property (nonatomic, strong) NSString *a_imageHeight;
@property (nonatomic, strong) NSString *a_avatarUrl;
@property (nonatomic, strong) NSString *a_userName;
@property (nonatomic, strong) NSString *a_isFocused;
@property (nonatomic, strong) NSString *a_focusedNum;
@property(nonatomic,strong)NSString* a_userType;
@property (nonatomic, strong) NSDictionary *dict;



//获取产品
+ (NSURLSessionDataTask *)GetProductInformationWithBlock:(void (^)(NSMutableArray *posts, NSError *error))block startIndex:(int)startIndex keyWords:(NSString *)keyWords noNetWork:(void(^)())noNetWork;

//添加产品
+ (NSURLSessionDataTask *)AddProductInformationWithBlock:(void (^)(NSMutableArray *posts, NSError *error))block dic:(NSDictionary *)dic imgData:(NSData *)imgData noNetWork:(void(^)())noNetWork;

//发布产品信息
+ (NSURLSessionDataTask *)PublishProductInformationWithBlock:(void (^)(NSMutableArray *posts, NSError *error))block dic:(NSMutableDictionary *)dic noNetWork:(void(^)())noNetWork;

//获取产品列表
+ (NSURLSessionDataTask *)GetProductListWithBlock:(void (^)(NSMutableArray *posts, NSError *error))block startIndex:(int)startIndex productDesc:(NSString *)productDesc userId:(NSString *)userId productIds:(NSString *)productIds noNetWork:(void(^)())noNetWork;
@end
