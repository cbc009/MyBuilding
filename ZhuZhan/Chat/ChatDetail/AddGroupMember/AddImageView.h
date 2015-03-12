//
//  AddImageView.h
//  ZhuZhan
//
//  Created by 孙元侃 on 15/3/11.
//
//

#import <UIKit/UIKit.h>

@protocol AddImageViewDelegate <NSObject>
-(void)addImageBtnClicked;
@end

@interface AddImageViewModel : NSObject
@property(nonatomic,copy)NSString* imageUrl;
@property(nonatomic,copy)NSString* name;
@end

@interface AddImageView : UIView
+(AddImageView*)addImageViewWithModels:(NSArray*)models;
@property(nonatomic,weak)id<AddImageViewDelegate>delegate;
@end
