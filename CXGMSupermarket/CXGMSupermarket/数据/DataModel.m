//
//  DataModel.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "DataModel.h"

@implementation ListModel

@end

@implementation DataModel

+(DataModel *)dataModelWith:(NSString *)JSON{
    DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
    if ([model.data isKindOfClass:[NSDictionary class]]) {
        model.listModel = [[ListModel alloc] initWithDictionary:(NSDictionary *)model.data error:nil];
    }
    return model;
}
@end

@implementation ShopModel

@end

@implementation AdvertisementModel

@end

@implementation CategoryModel

@end

@implementation AdBannarModel

+(AdBannarModel *)AdBannarModelWithJson:(NSDictionary *)json
{
    AdBannarModel* model = [[AdBannarModel alloc] initWithDictionary:json error:nil];
    if ([model.productList isKindOfClass:[NSArray class]]) {
        model.productList = [GoodsModel arrayOfModelsFromDictionaries:model.productList error:nil];
    }
    return model;
}
@end

@implementation GoodsModel

@end



@implementation CouponsModel

@end

@implementation AddressModel

@end

@implementation OrderModel
+(OrderModel *)OrderModelWithJson:(NSDictionary *)json
{
    OrderModel* model = [[OrderModel alloc] initWithDictionary:json error:nil];
    if ([model.productDetails isKindOfClass:[NSArray class]]) {
        model.productDetails = [GoodsModel arrayOfModelsFromDictionaries:model.productDetails error:nil];
    }
    if ([model.address isKindOfClass:[NSDictionary class]]) {
        model.addressObj = [[AddressModel alloc] initWithDictionary:(NSDictionary*)model.address error:nil];
    }
    return model;
}
@end

@implementation LocationModel

@end

@implementation ReceiptItem

@end


@implementation PostageItem

@end
