//
//  ProjectStage.h
//  ZhuZhan
//
//  Created by 汪洋 on 14-8-26.
//
//

#import <Foundation/Foundation.h>
#import "projectModel.h"
@interface ProjectStage : NSObject
//字符串的处理
+(NSString *)ProjectStrStage:(NSString *)str;

//时间的处理
+(NSString *)ProjectTimeStage:(NSString *)str;

//bool的处理
+(NSString *)ProjectBoolStage:(NSString *)str;

//判断项目阶段
+(NSString *)JudgmentProjectStage:(projectModel *)model;
@end