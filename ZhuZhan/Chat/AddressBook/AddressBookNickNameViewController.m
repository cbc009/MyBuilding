//
//  AddressBookNickNameViewController.m
//  ZhuZhan
//
//  Created by 汪洋 on 15/4/9.
//
//

#import "AddressBookNickNameViewController.h"
#import "EndEditingGesture.h"
#import "AddressBookApi.h"
#import "LoginSqlite.h"
@interface AddressBookNickNameViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextField *textField;
@end

@implementation AddressBookNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavi];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.textField];
    [EndEditingGesture addGestureToView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavi{
    self.title=@"备注信息";
    [self setLeftBtnWithImage:[GetImagePath getImagePath:@"013"]];
    [self setRightBtnWithText:@"完成"];
}

-(void)rightBtnClicked{
    if(self.textField.text.length >20){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"不能超过20个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    NSMutableDictionary* dic=[@{
                                @"userId":self.targetId,
                                @"nickName":self.textField.text
                                }mutableCopy];
    [AddressBookApi UpdateNickNameWithBlock:^(NSMutableArray *posts, NSError *error) {
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(addressBookNickNameViewControllerFinish )]) {
                [self.delegate addressBookNickNameViewControllerFinish];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if([ErrorCode errorCode:error]){
                [LoginAgain AddLoginView:NO];
            }else{
                [ErrorCode alert];
            }
        }
    } dic:dic noNetWork:^{
        [ErrorCode alert];
    }];
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, 300, 30)];
        _titleLabel.text=@"备注名";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = AllLightGrayColor;
    }
    return _titleLabel;
}

-(UITextField *)textField{
    if(!_textField){
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 104, 320, 40)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _textField.leftView.userInteractionEnabled = NO;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.placeholder = @"填写备注名(1-20字)";
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        [_textField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }
    return _textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}
@end
