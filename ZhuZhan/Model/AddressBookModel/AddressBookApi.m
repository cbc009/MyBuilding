//
//  AddressBookApi.m
//  ZhuZhan
//
//  Created by 汪洋 on 15/3/9.
//
//

#import "AddressBookApi.h"
#import "ConnectionAvailable.h"
#import "AddressBookModel.h"
#import "LoginSqlite.h"
@implementation AddressBookApi
+ (NSURLSessionDataTask *)GetAddressBookListWithBlock:(void (^)(NSMutableArray *posts, NSError *error))block keywords:(NSString *)keywords noNetWork:(void(^)())noNetWork{
    if (![ConnectionAvailable isConnectionAvailable]) {
        if (noNetWork) {
            noNetWork();
        }
        return nil;
    }
    NSString *urlStr = [NSString stringWithFormat:@"api/contacts/getContactsUserList?keywords=%@",keywords];
    NSLog(@"=====%@",urlStr);
    return [[AFAppDotNetAPIClient sharedNewClient] GET:urlStr parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
        NSLog(@"JSON===>%@",JSON);
        if([[NSString stringWithFormat:@"%@",JSON[@"status"][@"statusCode"]]isEqualToString:@"200"]){
            NSMutableArray *mutablePosts = [[NSMutableArray alloc] init];
            for(NSDictionary *item in JSON[@"data"]){
                AddressBookModel *ABModel = [[AddressBookModel alloc] init];
                [ABModel setDict:item];
                for(NSDictionary *item2 in item[@"groupUsers"]){
                    AddressBookContactModel *contactModel = [[AddressBookContactModel alloc] init];
                    [contactModel setDict:item2];
                    [ABModel.contactArr addObject:contactModel];
                }
                [mutablePosts addObject:ABModel];
            }
            if (block) {
                block([NSMutableArray arrayWithArray:mutablePosts], nil);
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"status"][@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        NSLog(@"error ==> %@",error);
        if (block) {
            block([NSMutableArray array], error);
        }
    }];
}
@end
