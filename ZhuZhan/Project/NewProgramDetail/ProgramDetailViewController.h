//
//  ProgramDetailViewController.h
//  ZhuZhan
//
//  Created by 孙元侃 on 14-8-26.
//
//

#import <UIKit/UIKit.h>
#import "projectModel.h"
@interface ProgramDetailViewController : UIViewController
@property(nonatomic,strong)projectModel* model;
@property(nonatomic,strong)NSString *projectId;
@end
