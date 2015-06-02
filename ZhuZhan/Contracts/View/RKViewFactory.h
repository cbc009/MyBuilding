//
//  RKViewFactory.h
//  ZhuZhan
//
//  Created by 孙元侃 on 15/3/26.
//
//

#import <Foundation/Foundation.h>

@interface RKViewFactory : NSObject
+ (UIView*)noHistorySearchResultsViewWithTop:(CGFloat)top;

+ (UIView*)noSearchResultsViewWithTop:(CGFloat)top;

//将url图片在固定区域内居中显示，只显示原图部分内容，不失真
+ (void)imageViewWithImageView:(UIImageView*)imageView imageUrl:(NSString*)imageUrl defaultImageName:(NSString*)defaultImageName;

+ (UIImage *)convertViewAsImage:(UIView *)aview;

+ (void)autoLabel:(UILabel*)label maxWidth:(CGFloat)maxWidth;

+ (CGFloat)autoLabelWithMaxWidth:(CGFloat)maxWidth font:(UIFont*)font content:(NSString*)content;

+ (void)autoLabel:(UILabel*)label maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHieght;

+ (CGFloat)autoLabelWithMaxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight font:(UIFont*)font content:(NSString*)content;
@end
