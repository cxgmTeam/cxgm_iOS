//
//  AnotherCartViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/13.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AnotherCartViewController.h"
#import "ShopCartView.h"

#import "OrderConfirmViewController.h"

#import "GoodsDetailViewController.h"

@interface AnotherCartViewController ()

@property (strong,nonatomic)ShopCartView * cartView;;

@end

@implementation AnotherCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    
    UIButton* editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [editBtn setTitle:@"删除" forState:UIControlStateNormal];
    [editBtn setTitleColor:Color333333 forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [editBtn addTarget:self action:@selector(onTapDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    
    _cartView = [[ShopCartView alloc] init];
    _cartView.hideShoppingBtn = YES;
    [self.view addSubview:_cartView];
    [_cartView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    
    typeof(self) __weak wself = self;
    _cartView.gotoConfirmOrder = ^(NSArray *array,NSDictionary* dic){
        OrderConfirmViewController* vc = [OrderConfirmViewController new];
        vc.goodsArray = array;
        vc.moneyDic = dic;
        [wself.navigationController pushViewController:vc animated:YES];
    };
    _cartView.gotoGoodsDetail = ^(GoodsModel *model){
        GoodsDetailViewController* vc = [GoodsDetailViewController new];
        vc.fromShopCart = YES;
        vc.goodsId = model.productId;
        [wself.navigationController pushViewController:vc animated:YES];
    };
}

- (void)onTapDeleteBtn:(id)sender
{
    [self.cartView deleteSelectedGoods];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.cartView getShopCartList];
}

@end
