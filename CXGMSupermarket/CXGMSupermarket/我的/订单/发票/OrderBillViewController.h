//
//  OrderBillViewController.h
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/5/2.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterSubViewController.h"

@interface OrderBillViewController : MyCenterSubViewController

@property(nonatomic,copy)void(^writeReceiptFinish)(ReceiptItem* receipt);
@end
