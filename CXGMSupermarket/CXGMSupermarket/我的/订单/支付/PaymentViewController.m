//
//  PaymentViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/22.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "PaymentViewController.h"
#import "OrderPaywayViewCell.h"
#import "PaymentButton.h"

@interface PaymentViewController ()

@property(nonatomic,strong)UIButton* payButon;

@property(nonatomic,strong)UILabel* timeLabel;
@property(nonatomic,strong)UILabel* moneyLabel;

@property(nonatomic,strong)OrderPaywayViewCell* payView;

@property(nonatomic,strong)PaymentButton* weixinBtn;
@property(nonatomic,strong)PaymentButton* alipayBtn;
@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付订单";
    
    
    [self setupMainUI];
}

- (void)setupMainUI
{
    [self.payButon mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(50);
    }];

    
    UIView* whiteView1 = [UIView new];
    whiteView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView1];
    [whiteView1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(106);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"支付剩余时间  4:15";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView1 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(30);
        make.centerX.equalTo(whiteView1);
    }];
    _timeLabel = label;
    
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(25, 123, 326, 18);
    label.text = @"请在规定的时间内完成支付，否则订单将会被自动取消！";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = [UIColor colorWithRed:255/255.0 green:121/255.0 blue:40/255.0 alpha:1/1.0];
    [whiteView1 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.timeLabel.bottom).offset(5);
        make.centerX.equalTo(whiteView1);
    }];
    
    UIView* whiteView2 = [UIView new];
    whiteView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView2];
    [whiteView2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.equalTo(self.view);
        make.top.equalTo(whiteView1.bottom).offset(10);
        make.height.equalTo(45);
    }];
    
    label = [[UILabel alloc] init];
    label.text = @"实付金额：";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    [whiteView2 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(15);
        make.centerY.equalTo(whiteView2);
    }];
    
    label = [[UILabel alloc] init];
    label.text = @"￥464.14";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [whiteView2 addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(-15);
        make.centerY.equalTo(whiteView2);
    }];
    _moneyLabel = label;
    
    
    label = [[UILabel alloc] init];
    label.text = @"选择支付方式";
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(whiteView2.bottom).offset(10);
        make.left.equalTo(15);
    }];
    
//    _payView = [OrderPaywayViewCell new];
//    [self.view addSubview:_payView];
//    [_payView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.equalTo(label.bottom).offset(10);
//        make.left.right.equalTo(self.view);
//        make.height.equalTo(90);
//    }];
    
    _weixinBtn = [PaymentButton new];
    [self.view addSubview:_weixinBtn];
    [_weixinBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
    }];
}


- (UIButton *)payButon{
    if (!_payButon) {
        _payButon = [UIButton new];
        _payButon.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
        [_payButon setTitle:@"确认支付￥642.14" forState:UIControlStateNormal];
        _payButon.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        [_payButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:_payButon];
    }
    return _payButon;
}
@end
