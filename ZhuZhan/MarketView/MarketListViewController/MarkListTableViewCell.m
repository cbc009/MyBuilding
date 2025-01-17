//
//  MarkListTableViewCell.m
//  ZhuZhan
//
//  Created by 汪洋 on 15/6/4.
//
//

#import "MarkListTableViewCell.h"
#import "MarketModel.h"
#import "RKViewFactory.h"
@implementation MarkListTableViewCell

+ (CGFloat)carculateCellHeightWithModel:(MarketModel *)cellModel{
    CGFloat height = 0;
    height += [MarketListTitleView titleViewHeight]+5;
    height += [RKViewFactory autoLabelWithMaxWidth:300 maxHeight:60 font:[UIFont systemFontOfSize:14] content:cellModel.a_reqDesc]+5;
    if(cellModel.a_reqType != 5){
        height += 45;
    }
    
    if(cellModel.a_reqType == 1 || cellModel.a_reqType == 2){
        height += 45;
    }
    
    height += [MarketListFootView footViewHeight];
    
    height +=15;
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleView];
        [self.bgView addSubview:self.footView];
        [self.bgView addSubview:self.contentLabel];
        [self.bgView addSubview:self.firstTitleLabel];
        [self.bgView addSubview:self.firstContentLabel];
        [self.bgView addSubview:self.secondTitleLabel];
        [self.bgView addSubview:self.secondContentLabel];
    }
    return self;
}

-(MarketListTitleView *)titleView{
    if(!_titleView){
        _titleView = [[MarketListTitleView alloc] init];
    }
    return _titleView;
}

-(MarketListFootView *)footView{
    if(!_footView){
        _footView = [[MarketListFootView alloc] init];
        _footView.delegate = self;
    }
    return _footView;
}

-(UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [MarketListTitleView titleViewHeight])];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(UILabel *)contentLabel{
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _contentLabel;
}

-(UILabel *)firstTitleLabel{
    if(!_firstTitleLabel){
        _firstTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
        _firstTitleLabel.textColor = AllNoDataColor;
        _firstTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _firstTitleLabel;
}

-(UILabel *)firstContentLabel{
    if(!_firstContentLabel){
        _firstContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
        _firstContentLabel.font = [UIFont systemFontOfSize:16];
    }
    return _firstContentLabel;
}

-(UILabel *)secondTitleLabel{
    if(!_secondTitleLabel){
        _secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
        _secondTitleLabel.textColor = AllNoDataColor;
        _secondTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _secondTitleLabel;
}

-(UILabel *)secondContentLabel{
    if(!_secondContentLabel){
        _secondContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
        _secondContentLabel.font = [UIFont systemFontOfSize:16];
    }
    return _secondContentLabel;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

-(void)setMarketModel:(MarketModel *)marketModel{
    [self.titleView setImageUrl:marketModel.a_avatarUrl title:marketModel.a_loginName type:marketModel.a_reqTypeCn time:marketModel.a_createdTime needRound:marketModel.a_needRound];
    self.contentLabel.text = marketModel.a_reqDesc;
    if([marketModel.a_reqDesc isEqualToString:@"-"]){
        self.contentLabel.textColor = AllNoDataColor;
    }else{
        self.contentLabel.textColor = RGBCOLOR(51, 51, 51);
    }
    
    if(marketModel.a_reqType !=5){
        if(marketModel.a_reqType !=2){
            self.firstTitleLabel.text = @"需求所在地";
        }else{
            self.firstTitleLabel.text = @"大类";
        }
    }
    
    if(marketModel.a_reqType !=5){
        if(marketModel.a_reqType !=2){
            self.firstContentLabel .text = marketModel.a_address;
            if([marketModel.a_address isEqualToString:@"-"]){
                self.firstContentLabel.textColor = AllNoDataColor;
            }else{
                self.firstContentLabel.textColor = RGBCOLOR(51, 51, 51);
            }
        }else{
            self.firstContentLabel .text = marketModel.a_bigTypeCn;
            if([marketModel.a_bigTypeCn isEqualToString:@"-"]){
                self.firstContentLabel.textColor = AllNoDataColor;
            }else{
                self.firstContentLabel.textColor = RGBCOLOR(51, 51, 51);
            }
        }
    }
    
    if(marketModel.a_reqType == 1){
        self.secondTitleLabel.text = @"金额要求（百万）";
        self.secondContentLabel.text = marketModel.a_money;
        if([marketModel.a_money isEqualToString:@"-"]){
            self.secondContentLabel.textColor = AllNoDataColor;
        }else{
            self.secondContentLabel.textColor = RGBCOLOR(51, 51, 51);
        }
    }else if (marketModel.a_reqType == 2){
        self.secondTitleLabel.text = @"分类";
        self.secondContentLabel.text = marketModel.a_smallTypeCn;
        if([marketModel.a_smallTypeCn isEqualToString:@"-"]){
            self.secondContentLabel.textColor = AllNoDataColor;
        }else{
            self.secondContentLabel.textColor = RGBCOLOR(51, 51, 51);
        }
    }
    
    [self.footView setCount:marketModel.a_commentCount isSelf:marketModel.a_isSelf isPersonal:marketModel.a_needRound needBtn:marketModel.a_isSelf?marketModel.a_needBtn:YES];
    
    CGFloat height = 0;
    CGRect frame = self.titleView.frame;
    height += CGRectGetHeight(self.titleView.frame)+5;
    
    [RKViewFactory autoLabel:self.contentLabel maxWidth:300 maxHeight:60];
    frame = self.contentLabel.frame;
    frame.origin.y = height;
    self.contentLabel.frame = frame;
    height += CGRectGetHeight(self.contentLabel.frame)+5;
    
    if(marketModel.a_reqType !=5){
        self.firstTitleLabel.hidden = NO;
        frame = self.firstTitleLabel.frame;
        frame.origin.y = height;
        self.firstTitleLabel.frame = frame;
        height += CGRectGetHeight(self.firstTitleLabel.frame);
    }else{
        self.firstTitleLabel.hidden = YES;
    }
    
    if(marketModel.a_reqType !=5){
        self.firstContentLabel.hidden = NO;
        frame = self.firstContentLabel.frame;
        frame.origin.y = height;
        self.firstContentLabel.frame = frame;
        height += CGRectGetHeight(self.firstContentLabel.frame)+5;
    }else{
        self.firstContentLabel.hidden = YES;
    }
    
    if(marketModel.a_reqType == 1 || marketModel.a_reqType == 2){
        self.secondTitleLabel.hidden = NO;
        frame = self.secondTitleLabel.frame;
        frame.origin.y = height;
        self.secondTitleLabel.frame = frame;
        height += CGRectGetHeight(self.secondTitleLabel.frame);
    }else{
        self.secondTitleLabel.hidden = YES;
    }
    
    if(marketModel.a_reqType == 1 || marketModel.a_reqType == 2){
        self.secondContentLabel.hidden = NO;
        frame = self.secondContentLabel.frame;
        frame.origin.y = height;
        self.secondContentLabel.frame = frame;
        height += CGRectGetHeight(self.secondContentLabel.frame)+5;
    }else{
        self.secondContentLabel.hidden = YES;
    }
    
    frame = self.footView.frame;
    frame.origin.y = height;
    self.footView.frame = frame;
    height += CGRectGetHeight(self.footView.frame);
    
    frame = self.bgView.frame;
    frame.size.height = height+5;
    self.bgView.frame = frame;
}

-(void)addFriend{
    if([self.delegate respondsToSelector:@selector(addFriend:)]){
        [self.delegate addFriend:self.indexPath];
    }
}

-(void)delRequire{
    if([self.delegate respondsToSelector:@selector(delRequire:)]){
        [self.delegate delRequire:self.indexPath];
    }
}
@end
