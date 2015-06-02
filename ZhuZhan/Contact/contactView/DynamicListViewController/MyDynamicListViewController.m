//
//  MyDynamicListViewController.m
//  ZhuZhan
//
//  Created by 汪洋 on 15/6/1.
//
//

#import "MyDynamicListViewController.h"
#import "XHPathCover.h"
#import "LoginSqlite.h"
#import "LoadingView.h"
#import "CompanyApi.h"
#import "CompanyModel.h"
#import "LoginModel.h"
#import "ContactModel.h"
#import "LoginViewController.h"
#import "PersonalCenterViewController.h"
#import "MJRefresh.h"
#import "ContactModel.h"
#import "MyTableView.h"

@interface MyDynamicListViewController ()<XHPathCoverDelegate,UITableViewDelegate,UITableViewDataSource,LoginViewDelegate>
@property(nonatomic,strong)XHPathCover *pathCover;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)LoadingView *loadingView;
@property(nonatomic,strong)NSMutableArray *modelsArr;
@property(nonatomic,strong)UINavigationController *navigationController;
@property(nonatomic)int startIndex;
@end

@implementation MyDynamicListViewController

-(instancetype)initNav:(UINavigationController *)nav{
    if(self = [super init]){
        self.navigationController = nav;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.pathCover;
    self.startIndex = 0;
    
    [self loadUserInfo];
    
    //集成刷新控件
    [self setupRefresh];
    
    __weak MyDynamicListViewController *wself = self;
    [self.pathCover setHandleRefreshEvent:^{
        [wself _refreshing];
    }];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeHeadImage) name:@"changHead" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (changeUserName) name:@"changName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBackgroundImage) name:@"changBackground" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_refreshing {
    // refresh your data sources
    self.startIndex = 0;
    [self loadList];
}

- (void)setupRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

-(XHPathCover *)pathCover{
    if(!_pathCover){
        _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 154) bannerPlaceholderImageName:@"默认主图"];
        _pathCover.delegate = self;
        [_pathCover setHeadTaget];
        [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"匿名用户", XHUserNameKey,@"想要使用更多功能请登录",XHBirthdayKey, nil]];
    }
    return _pathCover;
}

-(NSMutableArray *)modelsArr{
    if(!_modelsArr){
        _modelsArr = [NSMutableArray array];
    }
    return _modelsArr;
}

//滚动是触发的事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidScroll:scrollView isMyDynamicList:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pathCover scrollViewWillBeginDragging:scrollView];
}

-(void)gotoMyCenter{
    NSString *deviceToken = [LoginSqlite getdata:@"token"];
    if ([deviceToken isEqualToString:@""]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.delegate = self;
        loginVC.needDelayCancel = YES;
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self.view.window.rootViewController presentViewController:nv animated:YES completion:nil];
    }else{
        PersonalCenterViewController *personalVC = [[PersonalCenterViewController alloc] init];
        [self.navigationController pushViewController:personalVC animated:YES];
    }
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320,kScreenHeight-160)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [NSString stringWithFormat:@"productCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = NO;
    return cell;
}

-(void)changeHeadImage{
    [self.pathCover setHeadImageUrl:[NSString stringWithFormat:@"%@",[LoginSqlite getdata:@"userImage"]]];
}

-(void)changeUserName{
    [self.pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:[LoginSqlite getdata:@"userName"], XHUserNameKey, nil]];
}

-(void)changeBackgroundImage{
    [self.pathCover setBackgroundImageUrlString:[LoginSqlite getdata:@"backgroundImage"]];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changHead" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changBackground" object:nil];
}

- (void)footerRereshing{
    [ContactModel MyActivesWithBlock:^(NSMutableArray *posts, NSError *error) {
        if(!error){
            self.startIndex ++;
            [self.modelsArr addObjectsFromArray:posts];
            [MyTableView reloadDataWithTableView:self.tableView];
            if(self.modelsArr.count == 0){
                [MyTableView hasData:self.tableView];
            }
        }else{
            if([ErrorCode errorCode:error] == 403){
                [LoginAgain AddLoginView:NO];
            }else{
                [ErrorView errorViewWithFrame:CGRectMake(0, 50, 320, kScreenHeight-50) superView:self.view reloadBlock:^{
                    [self loadUserInfo];
                }];
            }
        }
        [LoadingView removeLoadingView:self.loadingView];
        self.loadingView = nil;
        [self.tableView footerEndRefreshing];
    } startIndex:self.startIndex+1 noNetWork:^{
        [LoadingView removeLoadingView:self.loadingView];
        self.loadingView = nil;
        [self.tableView footerEndRefreshing];
        [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
            [self loadUserInfo];
        }];
    }];
}

-(void)loadUserInfo{
    self.loadingView = [LoadingView loadingViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view];
    if(![[LoginSqlite getdata:@"token"] isEqualToString:@""]){
        if([[LoginSqlite getdata:@"userType"] isEqualToString:@"Company"]){
            [CompanyApi GetCompanyDetailWithBlock:^(NSMutableArray *posts, NSError *error) {
                if(!error){
                    if(posts.count !=0){
                        CompanyModel *model = posts[0];
                        [LoginSqlite insertData:model.a_companyLogo datakey:@"userImage"];
                        [LoginSqlite insertData:model.a_companyName datakey:@"userName"];
                        [_pathCover setHeadImageUrl:model.a_companyLogo];
                        [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.a_companyName, XHUserNameKey,@"", XHBirthdayKey, nil]];
                    }
                }else{
                    if([ErrorCode errorCode:error] == 403){
                        [LoginAgain AddLoginView:NO];
                    }else{
                        [ErrorView errorViewWithFrame:CGRectMake(0, 50, 320, kScreenHeight-50) superView:self.view reloadBlock:^{
                            [self loadUserInfo];
                        }];
                    }
                }
            } companyId:[LoginSqlite getdata:@"userId"] noNetWork:^{
                [LoadingView removeLoadingView:self.loadingView];
                self.loadingView = nil;
                __weak MyDynamicListViewController *wself = self;
                [wself.pathCover stopRefresh];
                [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
                    [self loadUserInfo];
                }];
            }];
        }else{
            [LoginModel GetUserInformationWithBlock:^(NSMutableArray *posts, NSError *error) {
                if(!error){
                    if(posts.count !=0){
                        ContactModel *model = posts[0];
                        [LoginSqlite insertData:model.userImage datakey:@"userImage"];
                        [LoginSqlite insertData:model.userName datakey:@"userName"];
                        [LoginSqlite insertData:model.personalBackground datakey:@"backgroundImage"];
                        
                        [_pathCover setHeadImageUrl:model.userImage];
                        [_pathCover setBackgroundImageUrlString:model.personalBackground];
                        [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:model.userName, XHUserNameKey,model.companyName, XHBirthdayKey,model.position,XHTitkeKey, nil]];
                    }
                }else{
                    if([ErrorCode errorCode:error] == 403){
                        [LoginAgain AddLoginView:NO];
                    }else{
                        [ErrorView errorViewWithFrame:CGRectMake(0, 50, 320, kScreenHeight-50) superView:self.view reloadBlock:^{
                            [self loadUserInfo];
                        }];
                    }
                }
            } userId:[LoginSqlite getdata:@"userId"] noNetWork:^{
                [LoadingView removeLoadingView:self.loadingView];
                self.loadingView = nil;
                __weak MyDynamicListViewController *wself = self;
                [wself.pathCover stopRefresh];
                [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
                    [self loadUserInfo];
                }];
            }];
        }
    }
    
    [self loadList];
}

-(void)loadList{
    [ContactModel MyActivesWithBlock:^(NSMutableArray *posts, NSError *error) {
        if(!error){
            [self.modelsArr removeAllObjects];
            self.modelsArr = posts;
            if(self.modelsArr.count == 0){
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
                [ErrorView errorViewWithFrame:CGRectMake(0, 50, 320, kScreenHeight-50) superView:self.view reloadBlock:^{
                    [self loadUserInfo];
                }];
            }
        }
        [LoadingView removeLoadingView:self.loadingView];
        self.loadingView = nil;
        __weak MyDynamicListViewController *wself = self;
        [wself.pathCover stopRefresh];
    } startIndex:0 noNetWork:^{
        [LoadingView removeLoadingView:self.loadingView];
        self.loadingView = nil;
        __weak MyDynamicListViewController *wself = self;
        [wself.pathCover stopRefresh];
        [ErrorView errorViewWithFrame:CGRectMake(0, 0, 320, kScreenHeight) superView:self.view reloadBlock:^{
            [self loadUserInfo];
        }];
    }];
}

-(void)loginCompleteWithDelayBlock:(void (^)())block{
    
}
@end