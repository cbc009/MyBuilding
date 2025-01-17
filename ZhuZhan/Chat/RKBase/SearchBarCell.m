//
//  SearchBarCell.m
//  ZhuZhan
//
//  Created by 孙元侃 on 15/3/10.
//
//

#import "SearchBarCell.h"
@interface SearchBarCell ()
@property(nonatomic,strong)UIImageView* mainImageView;
@property(nonatomic,strong)UILabel* mainLabel;
@property(nonatomic,strong)UIView* seperatorLine;
@property(nonatomic,strong,setter=setModel:)SearchBarCellModel* model;

@end

#define mainLabelFont [UIFont systemFontOfSize:13]

@implementation SearchBarCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(UIImageView *)mainImageView{
    if (!_mainImageView) {
        _mainImageView=[[UIImageView alloc]init];
        _mainImageView.frame=CGRectMake(0, 0, 37, 37);
    }
    return _mainImageView;
}

-(UILabel *)mainLabel{
    if (!_mainLabel) {
        _mainLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 17)];
        _mainLabel.font=mainLabelFont;
    }
    return _mainLabel;
}

-(UIView *)seperatorLine{
    if (!_seperatorLine) {
        _seperatorLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 1)];
        _seperatorLine.backgroundColor=RGBCOLOR(229, 229, 229);
    }
    return _seperatorLine;
}

-(void)setUp{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.mainImageView];
    [self.contentView addSubview:self.mainLabel];
    [self.contentView addSubview:self.seperatorLine];
}

-(void)setModel:(SearchBarCellModel *)model{
    _model=model;
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:model.mainImageUrl] placeholderImage:[GetImagePath getImagePath:@"人脉_06a2"]];
    self.mainLabel.text=model.mainLabelText;
}

-(void)layoutSubviews{
    self.mainImageView.center=CGPointMake(30, CGRectGetHeight(self.frame)*0.5);
    self.mainLabel.frame=CGRectMake(65, 15, CGRectGetWidth(self.mainLabel.frame), CGRectGetHeight(self.mainLabel.frame));
    self.seperatorLine.center=CGPointMake(kScreenWidth-CGRectGetWidth(self.seperatorLine.frame)*0.5, self.frame.size.height-CGRectGetHeight(self.seperatorLine.frame)*.5);
}
@end


@implementation SearchBarCellModel
@end