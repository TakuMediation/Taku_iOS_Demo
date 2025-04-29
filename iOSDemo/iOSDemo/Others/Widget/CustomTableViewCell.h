//
//  CustomTableViewCell.h
//  iOSDemo
//
//  Created by ltz on 2024/12/25.
//

#import <UIKit/UIKit.h>



@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subTitleLbl;  

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subTitle;

@end




