//
//  MoreCompanyViewCell.m
//  ZhuZhan
//
//  Created by 孙元侃 on 14-9-4.
//
//

#import "MoreCompanyViewCell.h"

@implementation MoreCompanyViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(MoreCompanyViewCell *)getCellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    MoreCompanyViewCell* cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSLog(@"11");
        NSLog(@"22");
    
    if (!cell.myImageView) {
        //公司图片
        cell.myImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 94, 94)];
        
        //公司名称
        cell.companyNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(99, 10, 210, 20)];
        cell.companyNameLabel.textColor=RGBCOLOR(62, 127, 226);
        cell.companyNameLabel.font=[UIFont boldSystemFontOfSize:14];
        
        //公司行业
        cell.companyBusiness=[[UILabel alloc]initWithFrame:CGRectMake(99, 30, 210, 20)];
        cell.companyBusiness.font=[UIFont boldSystemFontOfSize:13];
        cell.companyBusiness.textColor=RGBCOLOR(188, 188, 188);
        
        //公司介绍
        cell.companyIntroduce=[[UILabel alloc]initWithFrame:CGRectMake(99, 50, 210, 40)];
        cell.companyIntroduce.font=[UIFont boldSystemFontOfSize:13];
        cell.companyIntroduce.numberOfLines=2;
        
        [cell addSubview:cell.myImageView];
        [cell addSubview:cell.companyNameLabel];
        [cell addSubview:cell.companyBusiness];
        [cell addSubview:cell.companyIntroduce];

    }
        //cell=[[MoreCompanyViewCell alloc]initWithStyle:style reuseIdentifier:reuseIdentifier];
//        cell.myImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
//        cell.myImageView.image=[UIImage imageNamed:@"公司－我的公司_02a.png"];
//    cell.companyIntroduce.text=@"sadasda";
//
           // }
    
    
    return cell;
}
@end