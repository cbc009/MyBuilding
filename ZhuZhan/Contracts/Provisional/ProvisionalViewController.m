//
//  ProvisionalViewController.m
//  ZhuZhan
//
//  Created by 汪洋 on 15/3/30.
//
//

#import "ProvisionalViewController.h"
#import "LoginSqlite.h"
#import "StartManView.h"
#import "ReceiveView.h"
#import "MoneyView.h"
#import "ContractView.h"
#import "AppDelegate.h"
#import "HomePageViewController.h"
@interface ProvisionalViewController ()<UITableViewDataSource,UITableViewDelegate,MoneyViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *viewArr;
@property(nonatomic,strong)StartManView *startMainView;
@property(nonatomic,strong)ReceiveView *receiveView;
@property(nonatomic,strong)MoneyView *moneyView;
@property(nonatomic,strong)ContractView *contractView;

@property(nonatomic,strong)NSString *personaStr1;
@property(nonatomic,strong)NSString *personaStr2;
@property(nonatomic,strong)NSString *myCompanyName;
@property(nonatomic,strong)NSString *otherCompanyName;
@property(nonatomic,strong)NSString *personaName;
@property(nonatomic,strong)NSString *moneyStr;
@property(nonatomic,strong)NSString *contractStr;
@end

@implementation ProvisionalViewController
-(id)initWithView:(ProvisionalModel *)model{
    if(self = [super init]){
        self.personaStr1 = model.personaStr1;
        self.personaStr2 = model.personaStr2;
        self.myCompanyName = model.myCompanyName;
        self.otherCompanyName = model.otherCompanyName;
        self.personaName = model.personaName;
        self.moneyStr = model.moneyStr;
        self.contractStr = model.contractStr;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self setRightBtnWithText:@"提交"];
    self.title = @"填写佣金合同条款";
    
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //恢复tabBar
    AppDelegate* app=[AppDelegate instance];
    HomePageViewController* homeVC=(HomePageViewController*)app.window.rootViewController;
    [homeVC homePageTabBarRestore];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏tabBar
    AppDelegate* app=[AppDelegate instance];
    HomePageViewController* homeVC=(HomePageViewController*)app.window.rootViewController;
    [homeVC homePageTabBarHide];
}

-(void)rightBtnClicked{
    self.leftBtnIsBack = YES;
    self.needAnimaiton = YES;
    [self leftBtnClicked];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if(object == self.otherView1.textView){
//        [self layoutAndAnimateTextView:object index:2];
//    }else if (object == self.otherView2.textView){
//        [self layoutAndAnimateTextView:object index:3];
//    }else{
//        [self layoutAndAnimateTextView:object index:4];
//    }
//}
//
//-(void)layoutAndAnimateTextView:(UITextView *)textView index:(int)index{
//    CGFloat maxHeight = [OtherView maxHeight];
//    CGFloat contentH = [self getTextViewContentH:textView];
//    OtherView *view = (OtherView *)[textView superview];
//    BOOL isShrinking = NO;
//    CGFloat changeInHeight = 0;
//    __block CGFloat previousTextViewContentHeight = 0;
//    if(index == 2){
//        previousTextViewContentHeight = self.previousTextViewContentHeight1;
//    }else if (index == 3){
//        previousTextViewContentHeight = self.previousTextViewContentHeight2;
//    }else{
//        previousTextViewContentHeight = self.previousTextViewContentHeight3;
//    }
//    isShrinking = contentH < previousTextViewContentHeight;
//    changeInHeight = contentH - previousTextViewContentHeight;
//    
//    if (!isShrinking && (previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
//        changeInHeight = 0;
//    }else {
//        changeInHeight = MIN(changeInHeight, maxHeight - previousTextViewContentHeight);
//    }
//    
//    if (changeInHeight != 0.0f) {
//        [UIView animateWithDuration:0.25f
//                         animations:^{
//                             if (isShrinking) {
//                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//                                     previousTextViewContentHeight = MIN(contentH, maxHeight);
//                                 }
//                                 // if shrinking the view, animate text view frame BEFORE input view frame
//                                 [view adjustTextViewHeightBy:changeInHeight];
//                             }
//                             
//                             CGRect otherViewFrame = view.frame;
//                             view.frame = CGRectMake(0,0,320,otherViewFrame.size.height + changeInHeight);
//                             if (!isShrinking) {
//                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//                                     previousTextViewContentHeight = MIN(contentH, maxHeight);
//                                 }
//                                 // growing the view, animate the text view frame AFTER input view frame
//                                 [view adjustTextViewHeightBy:changeInHeight];
//                             }
//                         }
//                         completion:^(BOOL finished) {
//                         }];
//        
//        previousTextViewContentHeight = MIN(contentH, maxHeight);
//        if(index == 2){
//            self.previousTextViewContentHeight1 = previousTextViewContentHeight;
//        }else if (index == 3){
//            self.previousTextViewContentHeight2 = previousTextViewContentHeight;
//        }else{
//            self.previousTextViewContentHeight3 = previousTextViewContentHeight;
//        }
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        [textView becomeFirstResponder];
//    }
//}
//
//- (CGFloat)getTextViewContentH:(UITextView *)textView {
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        return ceilf([textView sizeThatFits:textView.frame.size].height);
//    } else {
//        return textView.contentSize.height;
//    }
//}

-(UITableView *)tableView{
    if(!_tableView){
        //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 320, kScreenHeight-64)];
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
    }
    return _tableView;
}

-(StartManView *)startMainView{
    if(!_startMainView){
        _startMainView = [[StartManView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        if(self.personaStr1){
            _startMainView.contactLabel.text = self.personaStr1;
        }
        
        if(self.myCompanyName){
            _startMainView.textField.text = self.myCompanyName;
        }
    }
    return _startMainView;
}

-(ReceiveView *)receiveView{
    if(!_receiveView){
        _receiveView = [[ReceiveView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
        if(self.personaName){
            _receiveView.personaLabel.text = self.personaName;
        }
        
        if(self.personaStr2){
            _receiveView.contactLabel.text = self.personaStr2;
        }
        
        if(self.otherCompanyName){
            _receiveView.textField.text = self.otherCompanyName;
        }
    }
    return _receiveView;
}

-(MoneyView *)moneyView{
    if(!_moneyView){
        _moneyView = [[MoneyView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
        if(self.moneyStr){
            _moneyView.textFied.text = self.moneyStr;
        }
    }
    return _moneyView;
}

-(ContractView *)contractView{
    if(!_contractView){
        _contractView = [[ContractView alloc] initWithFrame:CGRectMake(0, 0, 320, 290)];
        if(self.contractStr){
            _contractView.textView.text = self.contractStr;
        }
    }
    return _contractView;
}

-(NSMutableArray *)viewArr{
    if(!_viewArr){
        _viewArr = [NSMutableArray array];
        [_viewArr addObject:self.startMainView];
        [_viewArr addObject:self.receiveView];
        [_viewArr addObject:self.moneyView];
        [_viewArr addObject:self.contractView];
    }
    return _viewArr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.viewArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle = NO;
    [cell.contentView addSubview:self.viewArr[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 ||indexPath.row==1){
        return 180;
    }else if (indexPath.row == 2){
        return 48;
    }else{
        return 290;
    }
}

-(void)reloadStartMainView{
    [self.startMainView removeFromSuperview];
    self.startMainView = nil;
    [self.viewArr replaceObjectAtIndex:0 withObject:self.startMainView];
    [self.tableView reloadData];
}

-(void)reloadReceiveView{
    [self.receiveView removeFromSuperview];
    self.receiveView = nil;
    [self.viewArr replaceObjectAtIndex:1 withObject:self.receiveView];
    [self.tableView reloadData];
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]-0.01 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

-(void)dealloc{
    
}
@end


@implementation ProvisionalModel

@end