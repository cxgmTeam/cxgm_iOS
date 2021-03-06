//
//  ShopCartView.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/19.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartView : UIView

@property(nonatomic,assign)BOOL hideShoppingBtn;

//点击右上角的删除按钮调用
- (void)deleteSelectedGoods;

- (void)retsetSelectedStatus;

- (void)getShopCartList;

@property(nonatomic,copy)void(^gotoConfirmOrder)(NSArray* array,NSDictionary* dic) ;

@property(nonatomic,copy)void(^gotoGoodsDetail)(GoodsModel* model) ;
@end
