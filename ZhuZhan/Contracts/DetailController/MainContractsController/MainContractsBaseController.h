//
//  MainContractsBaseController.h
//  ZhuZhan
//
//  Created by 孙元侃 on 15/4/15.
//
//

#import "ContractsBaseViewController.h"
#import "ContractsMainClauseModel.h"
@interface MainContractsBaseController : ContractsBaseViewController
//只声明,不用传
@property (nonatomic, strong)ContractsMainClauseModel* mainClauseModel;

//只允许在消息列表传,主条款id
@property (nonatomic, copy)NSString* contractId;

//详细阶段的数据,只有在非主条款页面进入主条款页面才允许传
//暂时取消，需要则重新打开
//@property (nonatomic, strong)NSMutableArray* contractsStagesViewData;
//当从另一个详情页进来的时候赋值为YES
@property (nonatomic)BOOL isFromDetailView;
@end
