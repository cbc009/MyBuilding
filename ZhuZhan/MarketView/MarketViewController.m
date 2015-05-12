//
//  MarketViewController.m
//  ZhuZhan
//
//  Created by 汪洋 on 15/5/5.
//
//

#import "MarketViewController.h"
#import "AdDataModel.h"
#import "MarketSearchViewController.h"
#import "SearchMaterialViewController.h"
#import "ZWAdView.h"
#define contentHeight (kScreenHeight==480?431:519)
@interface MarketViewController ()<ZWAdViewDelagate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)ZWAdView *zwAdView;
@property(nonatomic,strong)UIImageView *centerImageView;
@property(nonatomic,strong)UIImageView *phoneImageView;
@property(nonatomic,strong)UIImageView *homeImageView;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,strong)UIView *searchView;
@property(nonatomic,strong)UIButton *centerBtn;
@property(nonatomic,strong)UIButton *phoneBtn;
@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBCOLOR(237, 237, 237);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:19], NSFontAttributeName,nil]];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 30, 30)];
    //[rightButton setBackgroundImage:[GetImagePath getImagePath:@"项目-首页_03a"] forState:UIControlStateNormal];
    [leftButton setTitle:@"收起" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    [self.searchView addSubview:self.searchBtn];
    self.navigationItem.titleView = self.searchView;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.zwAdView];
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.phoneImageView];
    [self.scrollView addSubview:self.centerBtn];
    [self.scrollView addSubview:self.phoneBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, contentHeight)];
        _scrollView.contentSize = CGSizeMake(320, 455);
    }
    return _scrollView;
}

-(UIImageView *)headImageView{
    if(!_headImageView){
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
        _headImageView.image = [GetImagePath getImagePath:@"index_head"];
    }
    return _headImageView;
}

-(UIImageView *)homeImageView{
    if(!_homeImageView){
        _homeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 21)];
        _homeImageView.image = [GetImagePath getImagePath:@"index_home"];
    }
    return _homeImageView;
}

-(ZWAdView *)zwAdView{
    if(!_zwAdView){
        _zwAdView=[[ZWAdView alloc]initWithFrame:CGRectMake(0, 0,320 , 100)];
        _zwAdView.delegate=self;
        /**广告链接*/
        AdDataModel * dataModel = [AdDataModel adDataModelWithImageName];
        _zwAdView.adDataArray=[NSMutableArray arrayWithArray:dataModel.imageNameArray];
        _zwAdView.pageControlPosition=ZWPageControlPosition_BottomCenter;/**设置圆点的位置*/
        _zwAdView.hidePageControl=NO;/**设置圆点是否隐藏*/
        _zwAdView.adAutoplay=YES;/**自动播放*/
        _zwAdView.adPeriodTime=4.0;/**时间间隔*/
        _zwAdView.placeImageSource=@"banner1";/**设置默认广告*/
        [_zwAdView loadAdDataThenStart];
    }
    return _zwAdView;
}

-(UIImageView *)centerImageView{
    if(!_centerImageView){
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 224)];
        _centerImageView.image = [GetImagePath getImagePath:@"index_need"];
    }
    return _centerImageView;
}

-(UIButton *)centerBtn{
    if(!_centerBtn){
        _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _centerBtn.frame = CGRectMake(18, 190, 283, 123);
        [_centerBtn addTarget:self action:@selector(centerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}

-(UIImageView *)phoneImageView{
    if(!_phoneImageView){
        _phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 334, 320, 121)];
        _phoneImageView.image = [GetImagePath getImagePath:@"index_phone"];
    }
    return _phoneImageView;
}

-(UIButton *)phoneBtn{
    if(!_phoneBtn){
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneBtn.frame = CGRectMake(18, 380, 283, 49);
        [_phoneBtn addTarget:self action:@selector(phoneBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

-(UIButton *)searchBtn{
    if(!_searchBtn){
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(0, 0, 254, 28);
        [_searchBtn setBackgroundImage:[GetImagePath getImagePath:@"MarketSearch"] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        _searchBtn.adjustsImageWhenHighlighted = NO;
    }
    return _searchBtn;
}

-(UIView *)searchView{
    if(!_searchView){
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(47, 26, 254, 28)];
    }
    return _searchView;
}

-(void)leftBtnClick{
    if([self.delegate respondsToSelector:@selector(gotoContactView)]){
        [self.delegate gotoContactView];
    }
}

-(void)searchAction{
    MarketSearchViewController *view = [[MarketSearchViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)centerBtnAction{
    SearchMaterialViewController *view = [[SearchMaterialViewController alloc] init];
    [self.navigationController pushViewController:view animated:YES];
}

-(void)phoneBtnAction{
    NSString *deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPhone"]) {
        NSString *telephone = @"tel://4006697262";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telephone]];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备不能打电话" delegate:nil cancelButtonTitle:@"是" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
}
@end
