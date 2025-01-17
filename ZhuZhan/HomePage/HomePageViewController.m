//
//  HomePageViewController.m
//  ZhuZhan
//
//  Created by 汪洋 on 14-8-5.
//  Copyright (c) 2014年 zpzchina. All rights reserved.
//
#import "HomePageViewController.h"
#import "LoginModel.h"
#import "AppDelegate.h"
#import "LoginSqlite.h"
#import "ConnectionAvailable.h"
#import "MBProgressHUD.h"
#import "AddressBookViewController.h"
#import "AddFriendViewController.h"
#import "ChatListViewController.h"
#import "RecommendListViewController.h"
#import "RemindListViewController.h"
#import "ConstractListController.h"
#import "ContractsBaseViewController.h"
#import "AskPriceMainViewController.h"
#import "MainContractsBaseController.h"
#import "ProvisionalViewController.h"
#import "OtherContractsBaseController.h"
#import "AskPriceMessageViewController.h"
#import "MarketViewController.h"
#import "SecretView.h"
#import "AskPriceViewController.h"

#define contentHeight (kScreenHeight==480?431:519)
@interface HomePageViewController ()<LoginViewDelegate,MarketViewDelegate,ContactViewDelegate,ActiveViewControllerDelegate,SecretViewDelegate>
@property(nonatomic,strong)UINavigationController *navigatin;
@property(nonatomic,strong)MarketViewController *marketView;
@property(nonatomic)int secretCount;
@property(nonatomic,strong)SecretView *secretView;
@end

@implementation HomePageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.secretCount = 0;
    self.isOpenContactView = NO;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [GetImagePath getImagePath:@"loading"];
    [self.view addSubview:imageView];
    
    UIButton *secretBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secretBtn.frame = CGRectMake(260, 20, 50, 50);
    //secretBtn.backgroundColor = [UIColor yellowColor];
    [secretBtn addTarget:self action:@selector(secretBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secretBtn];
    
    self.view.backgroundColor = RGBCOLOR(240, 240, 240);
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, contentHeight)];
//    contactview = [[ContactViewController alloc] init];
//    nav = [[UINavigationController alloc] initWithRootViewController:contactview];
//    [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
//    nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
//    [contentView addSubview:nav.view];
    
    self.marketView = [[MarketViewController alloc] init];
    self.marketView.delegate = self;
    nav = [[UINavigationController alloc] initWithRootViewController:self.marketView];
    [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
    nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
    [contentView addSubview:nav.view];
    self.marketView = nil;
    
    toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, 320, 49)];
   [toolView setBackgroundColor:RGBCOLOR(229, 229, 229)];
    
    contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactBtn setFrame:CGRectMake(20, 8, 30, 40)];
    [contactBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单01b"] forState:UIControlStateNormal];
    contactBtn.tag = 0;
    [contactBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:contactBtn];
    
    projectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [projectBtn setFrame:CGRectMake(80, 8, 30, 40)];
    [projectBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单02a"] forState:UIControlStateNormal];
    projectBtn.tag = 1;
    [projectBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:projectBtn];
    
    companyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [companyBtn setFrame:CGRectMake(210, 8, 30, 40)];
    [companyBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单03a"] forState:UIControlStateNormal];
    companyBtn.tag = 3;
    [companyBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:companyBtn];
    
    tradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tradeBtn setFrame:CGRectMake(270, 8, 30, 40)];
    [tradeBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单04a"] forState:UIControlStateNormal];
    tradeBtn.tag = 4;
    [tradeBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:tradeBtn];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoLogin:) name:@"LoginAgain" object:nil];
    
    
    //更多按钮的实现
    UIImage *storyMenuItemImage = [GetImagePath getImagePath:@"bg-menuitem"];
    UIImage *storyMenuItemImagePressed = [GetImagePath getImagePath:@"bg-menuitem-highlighted"];
    
    // Camera MenuItem.
    QuadCurveMenuItem *cameraMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[GetImagePath getImagePath:@"yongjin"]
                                                         highlightedContentImage:nil flag:0];
    // People MenuItem.
    QuadCurveMenuItem *peopleMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                highlightedImage:storyMenuItemImagePressed
                                                                    ContentImage:[GetImagePath getImagePath:@"xunjia"]
                                                         highlightedContentImage:nil flag:0];
    // Place MenuItem.
    QuadCurveMenuItem *placeMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[GetImagePath getImagePath:@"xiaoxi"]
                                                        highlightedContentImage:nil flag:0];
    // Music MenuItem.
    QuadCurveMenuItem *musicMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:[GetImagePath getImagePath:@"huihua"]
                                                        highlightedContentImage:nil flag:0];
    // Thought MenuItem.
    QuadCurveMenuItem *thoughtMenuItem = [[QuadCurveMenuItem alloc] initWithImage:storyMenuItemImage
                                                                 highlightedImage:storyMenuItemImagePressed
                                                                     ContentImage:[GetImagePath getImagePath:@"jiahaoyou"]
                                                          highlightedContentImage:nil flag:0];
    
    NSArray *menus = [NSArray arrayWithObjects:cameraMenuItem, peopleMenuItem, placeMenuItem, musicMenuItem, thoughtMenuItem, nil];
    
    menu = [[QuadCurveMenu alloc] initWithFrame:self.view.bounds menus:menus];
    //menu.backgroundColor=[UIColor greenColor];
    menu.delegate = self;
     
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            imageView.alpha = 0;
            secretBtn.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [secretBtn removeFromSuperview];
            [self.view addSubview:contentView];
            [self.view addSubview:toolView];
            [self.view addSubview:menu];
        }];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)homePageTabBarHide{
    contentView.frame=CGRectMake(0, 0, 320, kScreenHeight);
    [nav.view setFrame:CGRectMake(0, 0, 320, kScreenHeight)];
    menu.hidden=YES;
    toolView.hidden=YES;
}

-(void)homePageTabBarRestore{
    contentView.frame=CGRectMake(0, 0, 320, contentHeight);
    [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
    menu.hidden=NO;
    toolView.hidden=NO;
}

-(void)BtnClick:(UIButton *)button{
    for(int i=0;i<contentView.subviews.count;i++) {
        [((UIView*)[contentView.subviews objectAtIndex:i]) removeFromSuperview];
    }
    switch (button.tag) {
        case 0:
            NSLog(@"人脉");
            if(self.isOpenContactView){
//                contactview = [[ContactViewController alloc] init];
//                contactview.delegate = self;
//                nav = [[UINavigationController alloc] initWithRootViewController:contactview];
//                [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
//                nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
//                [contentView addSubview:nav.view];
//                contactview = nil;
                activeView = [[ActiveViewController alloc] init];
                activeView.delegate = self;
                nav = [[UINavigationController alloc] initWithRootViewController:activeView];
                [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
                nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
                [contentView addSubview:nav.view];
                activeView = nil;
            }else{
                self.marketView = [[MarketViewController alloc] init];
                self.marketView.delegate = self;
                nav = [[UINavigationController alloc] initWithRootViewController:self.marketView];
                [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
                nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
                [contentView addSubview:nav.view];
                self.marketView = nil;
            }
            [contactBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单01b"] forState:UIControlStateNormal];
            [projectBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单02a"] forState:UIControlStateNormal];
            [companyBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单03a"] forState:UIControlStateNormal];
            [tradeBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单04a"] forState:UIControlStateNormal];
            break;
        case 1:
            NSLog(@"项目");
            projectview = [[ALLProjectViewController alloc] init];
            nav = [[UINavigationController alloc] initWithRootViewController:projectview];
            [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
            nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
            [contentView addSubview:nav.view];
            [contactBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单01a"] forState:UIControlStateNormal];
            [projectBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单02b"] forState:UIControlStateNormal];
            [companyBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单03a"] forState:UIControlStateNormal];
            [tradeBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单04a"] forState:UIControlStateNormal];
            projectview = nil;
            break;
        case 2:
            NSLog(@"更多");
            break;
        case 3:
            NSLog(@"企业");
            companyview = [[MoreCompanyViewController alloc] init];
            nav = [[UINavigationController alloc] initWithRootViewController:companyview];
            [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
            nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
            [contentView addSubview:nav.view];
            [contactBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单01a"] forState:UIControlStateNormal];
            [projectBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单02a"] forState:UIControlStateNormal];
            [companyBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单03b"] forState:UIControlStateNormal];
            [tradeBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单04a"] forState:UIControlStateNormal];
            companyview = nil;
            break;
        case 4:
            NSLog(@"交易");
            productView = [[ProductViewController alloc] init];
            //tradeView=[[TradeViewController alloc]init];
            //testVC=[[ViewController alloc]init];
            
            nav = [[UINavigationController alloc] initWithRootViewController:productView];
            //nav = [[UINavigationController alloc] initWithRootViewController:tradeView];
            //nav=[[UINavigationController alloc]initWithRootViewController:testVC];
            [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
            nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
            [contentView addSubview:nav.view];
            [contactBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单01a"] forState:UIControlStateNormal];
            [projectBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单02a"] forState:UIControlStateNormal];
            [companyBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单03a"] forState:UIControlStateNormal];
            [tradeBtn setBackgroundImage:[GetImagePath getImagePath:@"主菜单04b"] forState:UIControlStateNormal];
            productView = nil;
            testVC=nil;
            break;
        default:
            break;
    }
}

-(void)gotoLogin:(NSNotification*)notification{
    //NSDictionary *nameDictionary = [notification userInfo];
    if (![ConnectionAvailable isConnectionAvailable]) {
        [MBProgressHUD myShowHUDAddedTo:self.view animated:YES];
        return;
    }
    
    [LoginSqlite deleteAll];
    
    UIButton* btn=[UIButton new];
    btn.tag=0;
    [self BtnClick:btn];
    [self homePageTabBarRestore];
}

-(void)loginCompleteWithDelayBlock:(void (^)())block{
    HomePageViewController* homeVC=(HomePageViewController*)[AppDelegate instance].window.rootViewController;
    UIButton* btn=[[UIButton alloc]init];
    btn.tag=0;
    [homeVC BtnClick:btn];
    if (block) {
        block();
    }
}

//更多按钮的委托方法
- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"===>%ld",(long)idx);
    if(idx == 0){
        NSLog(@"推荐信");
        quadCurveVC=[[ProvisionalViewController alloc]init];
        [self addAnimation];
        [nav pushViewController:quadCurveVC animated:NO];
    }else if(idx == 1){
        NSLog(@"发询价");
        quadCurveVC=[[AskPriceMainViewController alloc]init]; 
        [self addAnimation];
        [nav pushViewController:quadCurveVC animated:NO];
    }else if(idx == 2){
        NSLog(@"消息");
        quadCurveVC=[[AskPriceMessageViewController alloc]init];
        [self addAnimation];
        [nav pushViewController:quadCurveVC animated:NO];
    }else if (idx == 3){
        NSLog(@"会话");
        quadCurveVC=[[ChatListViewController alloc]init];
        if([[LoginSqlite getdata:@"userType"] isEqualToString:@"Personal"]){
            [self addAnimation];
            [nav pushViewController:quadCurveVC animated:NO];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"企业账号无此功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else{
        NSLog(@"通讯录");
        NSLog(@"%@",[LoginSqlite getdata:@"userType"]);
        quadCurveVC = [[AddressBookViewController alloc] init];
        if([[LoginSqlite getdata:@"userType"] isEqualToString:@"Personal"]){
            [self addAnimation];
            [nav pushViewController:quadCurveVC animated:NO];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"企业账号无此功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

-(void)gotoLoginView{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.view.window.rootViewController presentViewController:nv animated:YES completion:nil];
}

-(void)addAnimation{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = @"rippleEffect";
    [self.view.layer addAnimation:transition forKey:nil];
}

-(void)gotoContactView{
    self.isOpenContactView = YES;
    for(int i=0;i<contentView.subviews.count;i++) {
        [((UIView*)[contentView.subviews objectAtIndex:i]) removeFromSuperview];
    }
//    contactview = [[ContactViewController alloc] init];
//    contactview.delegate = self;
//    nav = [[UINavigationController alloc] initWithRootViewController:contactview];
//    [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
//    nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
//    [contentView addSubview:nav.view];
//    contactview = nil;
    
    activeView = [[ActiveViewController alloc] init];
    activeView.delegate = self;
    nav = [[UINavigationController alloc] initWithRootViewController:activeView];
    [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
    nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
    [contentView addSubview:nav.view];
    activeView = nil;
}

-(void)backGotoMarketView{
    self.isOpenContactView = NO;
    for(int i=0;i<contentView.subviews.count;i++) {
        [((UIView*)[contentView.subviews objectAtIndex:i]) removeFromSuperview];
    }
    self.marketView = [[MarketViewController alloc] init];
    self.marketView.delegate = self;
    nav = [[UINavigationController alloc] initWithRootViewController:self.marketView];
    [nav.view setFrame:CGRectMake(0, 0, 320, contentHeight)];
    nav.navigationBar.barTintColor = RGBCOLOR(85, 103, 166);
    [contentView addSubview:nav.view];
    self.marketView = nil;
}

-(void)secretBtnAction{
    self.secretCount +=1;
    if(self.secretCount == 5){
        [self.view.window addSubview:self.secretView];
    }
}

-(SecretView *)secretView{
    if(!_secretView){
        _secretView = [[SecretView alloc] initWithFrame:self.view.frame];
        _secretView.delegate = self;
    }
    return _secretView;
}

-(void)closeView{
    [self.secretView removeFromSuperview];
    self.secretView = nil;
}

//category 1为询价 2为报价
- (void)gotoMyAskPriceWithCategory:(NSInteger)category{
    NSString* otherStr;
    if(category == 1){
        otherStr = @"0";
    }else if (category == 2){
        otherStr = @"1";
    }else{
        otherStr = @"-1";
    }
    
    AskPriceViewController* vc = [[AskPriceViewController alloc] initWithOtherStr:otherStr];
    [nav pushViewController:vc animated:YES];
}

- (void)gotoAdressBookFriendList{
    [self quadCurveMenu:nil didSelectIndex:4];
}

- (void)gotoChatList{
    [self quadCurveMenu:nil didSelectIndex:3];
}

- (void)gotoContracts{
    ConstractListController *view = [[ConstractListController alloc] init];
    [nav pushViewController:view animated:YES];
}
@end
