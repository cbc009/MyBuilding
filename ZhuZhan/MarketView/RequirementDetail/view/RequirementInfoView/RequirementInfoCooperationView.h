//
//  RequirementInfoCooperationView.h
//  ZhuZhan
//
//  Created by 孙元侃 on 15/6/9.
//
//

#import <UIKit/UIKit.h>

@interface RequirementInfoCooperationView : UIView
+ (RequirementInfoCooperationView*)cooperationViewWithRequirementDescribe:(NSString*)requirementDescribe;
@property (nonatomic, copy)NSString* area;
@property (nonatomic, copy)NSString* requirementDescribe;


@property (nonatomic, strong)UITextField* areaField;
@property (nonatomic, strong)UILabel* requirementDescribeLabel;
@end