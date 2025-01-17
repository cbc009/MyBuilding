//
//  RecommendFriendViewController.m
//  ZhuZhan
//
//  Created by 汪洋 on 15/4/9.
//
//

#import "RecommendFriendViewController.h"
#import "RecommendFriendCell.h"
#import "AddressBookApi.h"
#import "FriendModel.h"
#import "RecommendFriendSearchController.h"
#import "MJRefresh.h"
#import "PersonalDetailViewController.h"
#import "MyTableView.h"
#define seperatorLineColor RGBCOLOR(229, 229, 229)
@interface RecommendFriendViewController ()<RecommendFriendCellDelegate,RecommendFriendSearchControllerDelegate>
@property(nonatomic,strong)NSMutableArray* models;
@property(nonatomic)int startIndex;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)RecommendFriendSearchController* searchBarTableViewController;
@end

@implementation RecommendFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startIndex = 0;
    [self initNavi];
    [self setUpSearchBarWithNeedTableView:YES isTableViewHeader:NO];
    [self initTableView];
    [self firstNetWork];
    [self initTopView];
    //集成刷新控件
    [self setupRefresh];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [super searchBarCancelButtonClicked:searchBar];
    [self headerRereshing];
}

-(void)setupRefresh{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.startIndex = 0;
    [AddressBookApi GetUserRecommendInfoWithBlock:^(NSMutableArray *posts, NSError *error) {
        if(!error){
            [self.models removeAllObjects];
            self.models = posts;
            if(self.models.count == 0){
                [MyTableView reloadDataWithTableView:self.tableView];
                [MyTableView hasData:self.tableView];
            }else{
                [MyTableView removeFootView:self.tableView];
                [self.tableView reloadData];
            }
        }else{
            if([ErrorCode errorCode:error] == 403){
                [LoginAgain AddLoginView:NO];
            }else{
                [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
                    [self firstNetWork];
                }];
            }
        }
        [self.tableView headerEndRefreshing];
    } startIndex:0 noNetWork:^{
        [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
            [self firstNetWork];
        }];
    }];
}

- (void)footerRereshing
{
    [AddressBookApi GetUserRecommendInfoWithBlock:^(NSMutableArray *posts, NSError *error) {
        if(!error){
            self.startIndex++;
            [self.models addObjectsFromArray:posts];
            if(self.models.count == 0){
                [MyTableView reloadDataWithTableView:self.tableView];
                [MyTableView hasData:self.tableView];
            }else{
                [MyTableView removeFootView:self.tableView];
                [self.tableView reloadData];
            }
        }else{
            if([ErrorCode errorCode:error] == 403){
                [LoginAgain AddLoginView:NO];
            }else{
                [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
                    [self firstNetWork];
                }];
            }
        }
        [self.tableView footerEndRefreshing];
    } startIndex:self.startIndex+1 noNetWork:^{
        [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
            [self firstNetWork];
        }];
    }];
}

-(void)initTopView{
    CGFloat y=64+CGRectGetHeight(self.searchBar.frame);
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, 40)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    
    UIView* seperatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, 39, kScreenWidth, 1)];
    seperatorLine.backgroundColor=seperatorLineColor;
    [self.topView addSubview:seperatorLine];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, 30)];
    label.text = @"推荐用户";
    label.font = [UIFont systemFontOfSize:15];
    [self.topView addSubview:label];
    
    CGFloat height=kScreenHeight-y-40;
    self.tableView.frame = CGRectMake(0, y+CGRectGetHeight(self.topView.frame), 320, height);
}

-(void)initNavi{
    self.title=@"添加好友";
    [self setLeftBtnWithImage:[GetImagePath getImagePath:@"013"]];
}

-(void)firstNetWork{
    self.startIndex = 0;
    [AddressBookApi GetUserRecommendInfoWithBlock:^(NSMutableArray *posts, NSError *error) {
        if(!error){
            self.models = posts;
            if(self.models.count == 0){
                [MyTableView reloadDataWithTableView:self.tableView];
                [MyTableView hasData:self.tableView];
            }else{
                [MyTableView removeFootView:self.tableView];
                [self.tableView reloadData];
            }
        }else{
            if([ErrorCode errorCode:error] == 403){
                [LoginAgain AddLoginView:NO];
            }else{
                [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
                    [self firstNetWork];
                }];
            }
        }
    } startIndex:0 noNetWork:^{
        [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
            [self firstNetWork];
        }];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 57;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendFriendCell* cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[RecommendFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    FriendModel *model = self.models[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.indexPathRow = (int)indexPath.row;
    cell.selectionStyle = NO;
    return cell;
}

-(void)setUpSearchBarTableView{
    self.searchBarTableViewController=[[RecommendFriendSearchController alloc]initWithTableViewBounds:CGRectMake(0, 0, kScreenWidth, kScreenHeight-CGRectGetMinY(self.searchBar.frame))];
    self.searchBarTableViewController.delegate=self;
    self.searchBarTableViewController.headImageDelegate = self;
    self.searchBarTableViewController.nowViewController = self;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [super searchBarSearchButtonClicked:searchBar];
    [self.searchBarTableViewController loadListWithKeyWords:searchBar.text];
}

-(void)headClick:(int)index{
    FriendModel *model = self.models[index];
    [self headClickWithModel:model];
}

- (void)headClickWithModel:(FriendModel *)model{
    [self searchBarCancelButtonClicked:self.searchBar];
    PersonalDetailViewController *view = [[PersonalDetailViewController alloc] init];
    view.contactId = model.a_id;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)addFriend{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}
@end
