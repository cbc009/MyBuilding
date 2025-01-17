//
//  RKDemandChatController.h
//  ZhuZhan
//
//  Created by 孙元侃 on 15/3/19.
//
//

#import "ChatBaseViewController.h"
#import "AskPriceModel.h"
#import "QuotesModel.h"
@interface RKDemandChatController : ChatBaseViewController{
@protected
    NSMutableArray* _chatModels;
}
@property(nonatomic,strong)NSMutableArray* chatModels;
@property(nonatomic,strong)AskPriceModel *askPriceModel;
@property(nonatomic,strong)QuotesModel *quotesModel;
@property(nonatomic)BOOL isFinish;
@end
