//
//  GoodsCashViewCell.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/30.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "GoodsCashViewCell.h"

@interface GoodsCashViewCell ()


@end

@implementation GoodsCashViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUP];
    }
    return self;
}



- (void)setupUP
{
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"商品总额";
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label1.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(18);
        make.left.equalTo(15);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"优惠";
    label2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label2.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label1.bottom).offset(16);
        make.left.equalTo(15);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"运费";
    label3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label3.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label2.bottom).offset(16);
        make.left.equalTo(15);
    }];
    
    _postageLabel = [[UILabel alloc] init];
    _postageLabel.text = @"（满100.00元包邮）";
    _postageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    _postageLabel.textColor = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1/1.0];
    [self addSubview:_postageLabel];
    [_postageLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label3);
        make.left.equalTo(label3.right);
    }];
    
    _totalAmountLabel = [[UILabel alloc] init];
    _totalAmountLabel.text = @"¥460.00";
    _totalAmountLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _totalAmountLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_totalAmountLabel];
    [_totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label1);
        make.right.equalTo(-15);
    }];

    _preferentialLabel = [[UILabel alloc] init];
    _preferentialLabel.text = @"¥0.00";
    _preferentialLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _preferentialLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_preferentialLabel];
    [_preferentialLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label2);
        make.right.equalTo(-15);
    }];
    
    _couponsLabel = [[UILabel alloc] init];
    _couponsLabel.text = [NSString stringWithFormat:@"¥%.2f",Freight_Charges];
    _couponsLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    _couponsLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [self addSubview:_couponsLabel];
    [_couponsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label3);
        make.right.equalTo(-15);
    }];
}
@end
