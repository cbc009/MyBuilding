//
//  ALLProjectViewController.h
//  ZhuZhan
//
//  Created by 汪洋 on 15/4/28.
//
//

#import <UIKit/UIKit.h>

@interface ALLProjectViewController : UIViewController
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *keywords;
@property (nonatomic, strong)UIViewController* nowViewController;
@end
