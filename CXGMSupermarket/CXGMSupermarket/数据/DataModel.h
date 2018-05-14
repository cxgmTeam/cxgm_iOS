//
//  DataModel.h
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/8.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "JSONModel.h"

@interface ListModel : JSONModel
@property (nonatomic,strong)NSObject<Optional> * list;
@end

@interface DataModel : JSONModel
@property (nonatomic,strong)NSObject<Optional> * result;
@property (nonatomic,strong)NSString<Optional> * code;
@property (nonatomic,strong)NSString<Optional> * msg;
@property (nonatomic,strong)NSObject<Optional> * data;
@property (nonatomic,strong)ListModel<Optional> * listModel;

+(DataModel *)dataModelWith:(NSString *)JSON;
@end


//店铺
@interface ShopModel : JSONModel

@property (nonatomic,strong)NSString<Optional> * id;
@property (nonatomic,strong)NSString<Optional> * shopName;
@property (nonatomic,strong)NSString<Optional> * shopAddress;
@property (nonatomic,strong)NSString<Optional> * imageUrl;
@property (nonatomic,strong)NSString<Optional> * description;
@end

//商品信息
@interface GoodsModel : JSONModel
@property (nonatomic,strong)NSString<Optional> * id;
@property (nonatomic,strong)NSString<Optional> * sn;
@property (nonatomic,strong)NSString<Optional> * name;
@property (nonatomic,strong)NSString<Optional> * fullName;
@property (nonatomic,strong)NSString<Optional> * goodNum;
@property (nonatomic,strong)NSString<Optional> * price;
@property (nonatomic,strong)NSString<Optional> * cost;
@property (nonatomic,strong)NSString<Optional> * marketPrice;
@property (nonatomic,strong)NSString<Optional> * image;
@property (nonatomic,strong)NSString<Optional> * unit;
@property (nonatomic,strong)NSString<Optional> * weight;
@property (nonatomic,strong)NSString<Optional> * stock;
@property (nonatomic,strong)NSString<Optional> * allocatedStock;
@property (nonatomic,strong)NSString<Optional> * stockMemo;
@property (nonatomic,strong)NSString<Optional> * point;
@property (nonatomic,strong)NSString<Optional> * isMarketable;
@property (nonatomic,strong)NSString<Optional> * isList;
@property (nonatomic,strong)NSString<Optional> * isTop;
@property (nonatomic,strong)NSString<Optional> * isGift;
@property (nonatomic,strong)NSString<Optional> * memo;
@property (nonatomic,strong)NSString<Optional> * score;
@property (nonatomic,strong)NSString<Optional> * totalScore;
@property (nonatomic,strong)NSString<Optional> * scoreCount;
@property (nonatomic,strong)NSString<Optional> * hits;
@property (nonatomic,strong)NSString<Optional> * weekHits;
@property (nonatomic,strong)NSString<Optional> * monthHits;
@property (nonatomic,strong)NSString<Optional> * sales;
@property (nonatomic,strong)NSString<Optional> * weekSales;
@property (nonatomic,strong)NSString<Optional> * monthSales;
@property (nonatomic,strong)NSString<Optional> * weekHitsDate;
@property (nonatomic,strong)NSString<Optional> * monthHitsDate;
@property (nonatomic,strong)NSString<Optional> * weekSalesDate;
@property (nonatomic,strong)NSString<Optional> * monthSalesDate;
@property (nonatomic,strong)NSString<Optional> * originPlace;
@property (nonatomic,strong)NSString<Optional> * storageCondition;
@property (nonatomic,strong)NSString<Optional> * productCategoryId;
@property (nonatomic,strong)NSString<Optional> * productCategoryTwoId;
@property (nonatomic,strong)NSString<Optional> * productCategoryThirdId;
@property (nonatomic,strong)NSString<Optional> * productCategoryName;
@property (nonatomic,strong)NSString<Optional> * productCategoryTwoName;
@property (nonatomic,strong)NSString<Optional> * productCategoryThirdName;
@property (nonatomic,strong)NSString<Optional> * shopId;
@property (nonatomic,strong)NSString<Optional> * brandName;
@property (nonatomic,strong)NSString<Optional> * introduction;
@property (nonatomic,strong)NSString<Optional> * cid;
@property (nonatomic,strong)NSString<Optional> * cname;
@property (nonatomic,strong)NSString<Optional> * grade;
@property (nonatomic,strong)NSString<Optional> * parentId;
@property (nonatomic,strong)NSObject<Optional> * productImageList;
@property (nonatomic,strong)NSString<Optional> * goodCode;
@end

//优惠券
@interface CouponsModel : JSONModel
@property (nonatomic,strong)NSString<Optional> * beginDate;
@property (nonatomic,strong)NSString<Optional> * categoryId;
@property (nonatomic,strong)NSString<Optional> * codeId;
@property (nonatomic,strong)NSString<Optional> * endDate;
@property (nonatomic,strong)NSString<Optional> * introduction;
@property (nonatomic,strong)NSString<Optional> * name;
@property (nonatomic,strong)NSString<Optional> * productId;
@property (nonatomic,strong)NSString<Optional> * status;

@property(nonatomic,strong)NSString<Optional> * isOpen;//用做UI的展开折叠
@property(nonatomic,strong)NSString<Optional> * isExpire;
@end

//用户地址
@interface AddressModel : JSONModel
@property(nonatomic,strong)NSString<Optional> * id;
@property(nonatomic,strong)NSString<Optional> * address;
@property(nonatomic,strong)NSString<Optional> * area;
@property(nonatomic,strong)NSString<Optional> * dimension;
@property(nonatomic,strong)NSString<Optional> * longitude;
@property(nonatomic,strong)NSString<Optional> * phone;
@property(nonatomic,strong)NSString<Optional> * realName;
@end



@interface LocationModel : NSObject

@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *street;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;

@property(nonatomic,assign)BOOL inScope;//是否在配送范围

@end




