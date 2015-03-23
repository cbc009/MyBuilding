//
//  AskPriceViewController.m
//  ZhuZhan
//
//  Created by 孙元侃 on 15/3/16.
//
//

#import "AskPriceViewController.h"
#import "RKStageChooseView.h"
#import "RKTwoView.h"
#import "AskPriceViewCell.h"
#import "ChooseProductBigStage.h"
#import "ChooseProductSmallStage.h"
#import "DemanDetailViewController.h"
#import "DemandStageChooseController.h"
#import "AskPriceApi.h"
#import "AskPriceModel.h"
#import "QuotesModel.h"
#import "DemandListSearchController.h"
@interface AskPriceViewController ()<DemandStageChooseControllerDelegate,RKStageChooseViewDelegate>
@property(nonatomic,strong)NSString *statusStr;
@property(nonatomic,strong)NSString *otherStr;
@property(nonatomic,strong)NSMutableArray *showArr;
@end

@implementation AskPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusStr = @"";
    self.otherStr = @"00";
    [self initNavi];
   // [self setUpSearchBarWithNeedTableView:NO isTableViewHeader:YES];
    [self initStageChooseViewWithStages:@[@"全部",@"进行中",@"已采纳",@"已关闭"]  numbers:@[@"0",@"0",@"0",@"0"]];
    [self initTableView];
    [self initTableViewHeader];

    self.tableView.backgroundColor=AllBackDeepGrayColor;
}

-(void)loadList{
    [AskPriceApi GetAskPriceWithBlock:^(NSMutableArray *posts, NSError *error) {
        if(!error){
            NSLog(@"%@,%@",posts[0],posts[1]);
            self.showArr = posts[0];
           [self.stageChooseView changeNumbers:@[posts[1][@"totalCount"],posts[1][@"processingCount"],posts[1][@"completeCount"],posts[1][@"offCount"]]];
            [self.tableView reloadData];
        }
    } status:self.statusStr startIndex:0 other:self.otherStr noNetWork:nil];
}

-(void)initTableViewHeader{
    CGRect frame=self.searchBar.frame;
    frame.origin=CGPointZero;
    self.searchBar.frame=frame;
    self.tableView.tableHeaderView=self.searchBar;
}

-(void)initNavi{
    [self initTitleViewWithTitle:@"全部需求列表"];
    [self setLeftBtnWithImage:[GetImagePath getImagePath:@"013"]];
    [self setRightBtnWithImage:[GetImagePath getImagePath:@"搜索按钮"]];
    self.needAnimaiton=YES;
}

-(void)initTitleViewWithTitle:(NSString*)title{
    NSString* titleStr=title;
    UIFont* font=[UIFont fontWithName:@"GurmukhiMN-Bold" size:19];
    UILabel* titleLabel=[[UILabel alloc]init];
    titleLabel.text=titleStr;
    titleLabel.font=font;
    titleLabel.textColor=[UIColor whiteColor];
    CGSize size=[titleStr boundingRectWithSize:CGSizeMake(9999, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    titleLabel.frame=CGRectMake(0, 0, size.width, size.height);
    
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake( 0, 0, 15, 9)];
    imageView.center=CGPointMake(CGRectGetMaxX(titleLabel.frame)+CGRectGetWidth(imageView.frame)*0.5+5, CGRectGetMidY(titleLabel.frame));
    imageView.image=[GetImagePath getImagePath:@"交易_页头箭头"];
    
    CGRect frame=titleLabel.frame;
    frame.size.width+=CGRectGetWidth(imageView.frame);
    
    UIButton* button=[[UIButton alloc]initWithFrame:frame];
    [button addTarget:self action:@selector(selectDemandStage) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:titleLabel];
    [button addSubview:imageView];
    
    self.navigationItem.titleView=button;
}

-(void)rightBtnClicked{
    UIViewController* vc=[[DemandListSearchController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    //[self presentViewController:vc animated:YES completion:nil];
}

-(void)selectDemandStage{
    DemandStageChooseController* vc=[[DemandStageChooseController alloc]init];
    vc.delegate=self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)finishSelectedWithStageName:(NSString *)stageName index:(int)index{
    [self initTitleViewWithTitle:stageName];
    if(index == 1){
        self.otherStr = @"01";
    }else if (index == 2){
        self.otherStr = @"00";
    }
    [self loadList];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.showArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AskPriceModel *model = self.showArr[indexPath.row];
    return [AskPriceViewCell carculateTotalHeightWithContents:@[model.a_invitedUser,model.a_productBigCategory,model.a_productCategory,model.a_remark]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AskPriceViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[AskPriceViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.clipsToBounds=YES;
    }
    AskPriceModel *model = self.showArr[indexPath.row];
    cell.contents=@[model.a_invitedUser,model.a_productBigCategory,model.a_productCategory,model.a_remark];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AskPriceModel *model = self.showArr[indexPath.row];
    [AskPriceApi GetAskPriceDetailsWithBlock:^(NSMutableArray *posts, NSError *error) {
        if(!error){
            if(posts.count !=0){
                QuotesModel *quotesModel = posts[0];
                NSLog(@"%@",quotesModel.a_loginName);
                [AskPriceApi GetQuotesListWithBlock:^(NSMutableArray *posts, NSError *error) {
                    if(!error){
                        
                    }
                } providerId:quotesModel.a_loginId tradeCode:model.a_tradeCode startIndex:0 noNetWork:nil];
            }
        }
    } tradeId:model.a_id noNetWork:nil];

    return;
    DemanDetailViewController* vc=[[DemanDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    return;
    if (indexPath.row%2) {
        ChooseProductBigStage* vc=[[ChooseProductBigStage alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ChooseProductSmallStage* vc=[[ChooseProductSmallStage alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)stageBtnClickedWithNumber:(NSInteger)stageNumber{

    NSLog(@"=====> %ld",(long)stageNumber);
    if(stageNumber == 0){
        self.statusStr = @"";
    }else if (stageNumber == 1){
        self.statusStr = @"0";
    }else if (stageNumber == 2){
        self.statusStr = @"1";
    }else{
        self.statusStr = @"2";
    }
    [self loadList];
}
@end
