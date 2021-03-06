//
//  ShoppingCartController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/10.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "ShoppingCartController.h"

#import "OrderConfirmViewController.h"

#import "ShopCartView.h"
#import "GoodsDetailViewController.h"

#import "MainViewController.h"

@interface ShoppingCartController ()

@property (strong,nonatomic)ShopCartView * cartView;;

@end

@implementation ShoppingCartController



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
    _cartView.hideShoppingBtn = NO;
    [self.view addSubview:_cartView];
    [_cartView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(-TAB_BAR_HEIGHT);
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

    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.cartView getShopCartList];
    
    MainViewController* tabVC = (MainViewController *)self.tabBarController;
    [tabVC getShopCartNumber];
}



@end
