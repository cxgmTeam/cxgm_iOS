//
//  OrderStateHeadView.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/26.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderStateHeadView : UICollectionReusableView
@property(nonatomic,strong)OrderModel* orderItem;

@property(nonatomic,strong)UILabel* remainTimeLabel;
@end
