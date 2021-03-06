//
//  HomeViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/10.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "HomeViewController.h"
#import "GoodsDetailViewController.h"
#import "SubCategoryController.h"

#import "HomeGoodsView.h"
#import "HomeShopsView.h"

#import "SearchViewController.h"
#import "AddressViewController.h"

#import "MessageViewController.h"

#import "HYNoticeView.h"

#import "GoodsDetailViewController.h"
#import "WebViewController.h"

#define APPID @"1394406457"

@interface HomeViewController ()
@property(nonatomic,strong)HomeGoodsView* goodsView;
@property(nonatomic,strong)HomeShopsView* shopsView;

@property(nonatomic,strong)UIView* topView;

@property(nonatomic,assign)BOOL inScope;

@property(nonatomic,strong)HYNoticeView *noticeHot;

@property(nonatomic,assign)BOOL isVisible;

@property(nonatomic,assign)BOOL needNewAddress;//需要添加新地址，寻找店铺

@property(nonatomic,strong)UIView* navLine;

@property(nonatomic,strong)UIView* navBottomView;
@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupTopBar];
    
    [self setupMainUI:NO];
    
    [self setNoticeLocation];
    
    //检查版本
    [self checkAppUpdate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRemoteNotification:) name:Show_RemoteNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeShop:) name:Exchange_Shop object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHomePage:) name:AddedNewScope_Notify object:nil];
}

- (void)setNoticeLocation
{
    if (_noticeHot && _noticeHot.superview) {
        [_noticeHot removeFromSuperview];
    }
    _noticeHot = nil;
    
    NSLog(@"%s   %d  ",__func__,self.isVisible);

    if (!self.isVisible) return;
    
    
    NSString* locationString = [DeviceHelper sharedInstance].homeAddress;
    
    self.needNewAddress = YES;
    
    if ([DeviceHelper sharedInstance].defaultAddress) {
        self.needNewAddress = NO;
    }
    else if ([DeviceHelper sharedInstance].place && [DeviceHelper sharedInstance].locationInScope)
    {
        self.needNewAddress = NO;
    }
    
    CGFloat width = [self sizeLabelWidth:locationString];
    
    CGRect frame = CGRectMake(10, NAVIGATION_BAR_HEIGHT-25, width, 30);
    if (iPhoneX || iPhoneXR || iPhoneXS || iPhoneXRMAX) {
        frame = CGRectMake(10, NAVIGATION_BAR_HEIGHT-50, width, 30);
    }
    
    _noticeHot = [[HYNoticeView alloc] initWithFrame:frame text:locationString position:HYNoticeViewPositionTopLeft];
    [_noticeHot showType:HYNoticeTypeTestHot inView:self.navigationController.navigationBar];
}



- (void)setupMainUI:(BOOL)inScope
{
    self.inScope = inScope;
    
    [self setNoticeLocation];
    
    
    if (inScope)
    {
        if (_shopsView.superview) {
            [_shopsView removeFromSuperview];
            _shopsView = nil;
        }
        
        if (!_goodsView)
        {
            _goodsView = [HomeGoodsView new];
            [self.view addSubview:_goodsView];
            [_goodsView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(self.navBottomView.bottom);
                make.left.right.bottom.equalTo(self.view);
            }];

            
            typeof(self) __weak wself = self;
            _goodsView.showSubCategoryVC = ^(NSArray * array){
                SubCategoryController* vc = [SubCategoryController new];
                vc.categoryArr = array;
                [wself.navigationController pushViewController:vc animated:YES];
            };
            
            _goodsView.showGoodsDetailVC = ^(GoodsModel *model){
                GoodsDetailViewController* vc = [GoodsDetailViewController new];
                vc.goodsId = model.id;
                [wself.navigationController pushViewController:vc animated:YES];
            };
            _goodsView.showBusinessDetailVC = ^(AdBannarModel* model){
                if ([model.urlType isEqualToString:@"1"] && [model.notifyUrl length] > 0) {
                    WebViewController* vc = [WebViewController new];
                    vc.urlString = model.notifyUrl;
                    [wself.navigationController pushViewController:vc animated:YES];
                }
                if ([model.urlType isEqualToString:@"2"]){
                    GoodsDetailViewController* vc = [GoodsDetailViewController new];
                    vc.goodsId = model.productCode;
                    [wself.navigationController pushViewController:vc animated:YES];
                }
            };
            _goodsView.showAdvertiseDetailVC = ^(AdvertisementModel* ad){
                if ([ad.type isEqualToString:@"1"] && [ad.notifyUrl length] > 0) {
                    WebViewController* vc = [WebViewController new];
                    NSString* url = [NSString stringWithFormat:@"%@?token=%@",ad.notifyUrl,[UserInfoManager sharedInstance].userInfo.token];
                    vc.urlString = url;
                    [wself.navigationController pushViewController:vc animated:YES];
                }
                if ([ad.type isEqualToString:@"2"]) {
                    GoodsDetailViewController* vc = [GoodsDetailViewController new];
                    vc.goodsId = ad.productCode;
                    [wself.navigationController pushViewController:vc animated:YES];
                }
            };
            _goodsView.showHYNoticeView = ^(BOOL show){
                wself.noticeHot.hidden = !show;
            };
            

        }else{
            [_goodsView requestGoodsList];
        }
    }
    else
    {
        [DeviceHelper sharedInstance].homeAddress = @"当前位置不在配送范围内，请选择收货地址";
        
        if (_goodsView.superview) {
            [_goodsView removeFromSuperview];
            _goodsView = nil;
        }
        
        if (!_shopsView)
        {
            _shopsView = [HomeShopsView new];
            [self.view addSubview:_shopsView];
            [_shopsView mas_makeConstraints:^(MASConstraintMaker *make){
                make.top.equalTo(self.navBottomView.bottom);
                make.left.right.bottom.equalTo(self.view);
            }];
            typeof(self) __weak wself = self;
            _shopsView.selectShopHandler = ^{
                [wself setupMainUI:YES];
            };
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.navLine.hidden = NO;
    
    self.isVisible = YES;
    
    _topView.hidden = NO;
    
    
    [self setNoticeLocation];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.navLine.hidden = NO;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.navLine.hidden = YES;

    self.isVisible = NO;
    
    _topView.hidden = YES;
    
    
    if (_noticeHot && _noticeHot.superview) {
        [_noticeHot removeFromSuperview];
    }
    _noticeHot = nil;

}

- (void)setupTopBar
{
    UIButton* locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [locationBtn setImage:[UIImage imageNamed:@"order_address_white"] forState:UIControlStateNormal];
    locationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [locationBtn addTarget:self action:@selector(showAddressVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationBtn];

    
    UIButton* messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [messageBtn setImage:[UIImage imageNamed:@"top_message"] forState:UIControlStateNormal];
    messageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [messageBtn addTarget:self action:@selector(showMessageVC:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageBtn];
    
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(50, (44-28)/2, ScreenW-100, 28)];
    [self.navigationController.navigationBar addSubview:_topView];
    
    CustomTextField* textField = [CustomTextField new];
    textField.layer.cornerRadius = 14;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:242/255.0 alpha:1/1.0];
    textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 15, 15)];
    imgView.image = [UIImage imageNamed:@"top_searchBar_search"];
    textField.leftView = imgView;
    textField.placeholder = @"特惠三文鱼";
    [_topView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.topView);
    }];
    
    UIButton* btn = [UIButton new];
    [_topView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker* make){
        make.edges.equalTo(self.topView);
    }];
    [btn addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT-STATUS_BAR_HEIGHT-1, ScreenW, 2)];
    line.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [self.navigationController.navigationBar addSubview:line];
    self.navLine = line;
    
    _navBottomView = [UIView new];
    _navBottomView.backgroundColor = [UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0];
    [self.view addSubview:_navBottomView];
    [_navBottomView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(30);
    }];
    {
        UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_logo"]];
        [_navBottomView addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.navBottomView);
            if (ScreenW < 375) {
                make.right.equalTo(-10);
            }else{
               make.right.equalTo(-20);
            }
        }];
        
        UIImageView* icon1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_check"]];
        [_navBottomView addSubview:icon1];
        [icon1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.navBottomView);
            if (ScreenW < 375) {
                make.left.equalTo(10);
            }else{
                make.left.equalTo(20);
            }
            
        }];
        
        UILabel* label1 = [UILabel new];
        label1.text = @"全球食材";
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont systemFontOfSize:12];
        if (ScreenW < 375) {
            label1.font = [UIFont systemFontOfSize:10];
        }
        [_navBottomView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.navBottomView);
            make.left.equalTo(icon1.right).offset(5);
        }];
        
        UIImageView* icon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_check"]];
        [_navBottomView addSubview:icon2];
        [icon2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.navBottomView);
            make.left.equalTo(label1.right).offset(10);
        }];
        
        UILabel* label2 = [UILabel new];
        label2.text = @"优质放心";
        label2.textColor = [UIColor whiteColor];
        label2.font = [UIFont systemFontOfSize:12];
        if (ScreenW < 375) {
            label2.font = [UIFont systemFontOfSize:10];
        }
        [_navBottomView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.navBottomView);
            make.left.equalTo(icon2.right).offset(5);
        }];
        
        
        UIImageView* icon3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_check"]];
        [_navBottomView addSubview:icon3];
        [icon3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.navBottomView);
            make.left.equalTo(label2.right).offset(10);
        }];
        
        UILabel* label3 = [UILabel new];
        label3.text = @"1小时送达";
        label3.textColor = [UIColor whiteColor];
        label3.font = [UIFont systemFontOfSize:12];
        if (ScreenW < 375) {
            label3.font = [UIFont systemFontOfSize:10];
        }
        [_navBottomView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(self.navBottomView);
            make.left.equalTo(icon3.right).offset(5);
        }];
        
    }
}

- (void)showAddressVC:(id)sender
{
    AddressViewController* vc = [AddressViewController new];
    vc.needNewAddress = self.needNewAddress;
    typeof(self) __weak wself = self;
    vc.selectedAddress = ^(AddressModel * address){
        
        [DeviceHelper sharedInstance].defaultAddress = address;
        
        [DeviceHelper sharedInstance].homeAddress = [@"送货至：" stringByAppendingString:address.area] ;
        [wself setNoticeLocation];
        
        //请求店铺
        [wself checkAddress:address.longitude dimension:address.dimension];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showMessageVC:(id)sender
{
    MessageViewController* vc = [MessageViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)onTapButton:(id)sender
{
    SearchViewController* vc = [SearchViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showRemoteNotification:(NSNotification *)notify
{
    NSDictionary* dic = [notify userInfo];
    
    //urlType为2时跳转商品详情，urlType为1时直接打开H5连接
    if ([dic[@"urlType"] intValue] == 2)
    {
        GoodsDetailViewController* vc = [GoodsDetailViewController new];
        vc.goodsId = dic[@"goodcode"];
        vc.shopId = dic[@"shopId"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([dic[@"urlType"] intValue] == 1 )
    {
        WebViewController* vc = [WebViewController new];
        vc.urlString = dic[@"notifyUrl"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)exchangeShop:(NSNotification *)notify
{
    LocationModel* location = (LocationModel *)[notify object];
    if (location) {
        
        [self checkAddress:[[NSNumber numberWithDouble:location.longitude] stringValue] dimension:[[NSNumber numberWithDouble:location.latitude] stringValue]];
    }
}

- (void)refreshHomePage:(NSNotification *)notify
{
    AddressModel* address = [DeviceHelper sharedInstance].defaultAddress;
    
    [self checkAddress:address.longitude dimension:address.dimension];
}

- (void)checkAddress:(NSString *)longitude dimension:(NSString *)dimension
{
    NSDictionary* dic = @{
                          @"longitude":longitude,
                          @"dimension":dimension
                          };
    typeof(self) __weak wself = self;
    //data为空代表不在配送范围内
    [AFNetAPIClient POST:[LoginBaseURL stringByAppendingString:APICheckAddress] token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray *)model.data;
            //更新店铺
            if (array.count > 0) {

                ShopModel* shop = [[ShopModel alloc] initWithDictionary:[array firstObject] error:nil];
                
                //1.切换店铺  2.从店铺列表切换到商品列表
                if ([DeviceHelper sharedInstance].shop && ![[DeviceHelper sharedInstance].shop.id isEqualToString:shop.id]) {
                    
                    [DeviceHelper sharedInstance].shop = shop;
                    
                    [wself.goodsView requestGoodsList];
                }
                else if ([[DeviceHelper sharedInstance].shop.id length] == 0){
                    
                    [DeviceHelper sharedInstance].shop = shop;
                    
                    [wself setupMainUI:YES];
                }
            }
        }
    } failure:^(id JSON, NSError *error){

    }];
}

#pragma mark-


- (CGFloat)sizeLabelWidth:(NSString *)text
{
    CGFloat titleWidth = SCREENW*0.6;
    
    if (text.length > 0) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:13]};
        
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        
        titleWidth = ceilf(textSize.width)+20;
    }
    if (titleWidth >= SCREENW) {
        titleWidth = SCREENW-20;
    }
    return titleWidth;
}


#pragma mark- 检查更新

-(void)checkAppUpdate
{
    //1先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    
    //2从网络获取appStore版本号
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",APPID]]] returningResponse:nil error:nil];
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"hsUpdateAppError:%@",error);
        return;
    }
    NSArray *array = appInfoDic[@"results"];
    NSDictionary *dic = array[0];
    NSString *appStoreVersion = dic[@"version"];
    //打印版本号
    NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
    //3当前版本号小于商店版本号,就更新
    if([currentVersion floatValue] < [appStoreVersion floatValue])
    {
        UIAlertController * vc = [UIAlertController alertControllerWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] preferredStyle:UIAlertControllerStyleAlert];
        
        [vc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [vc addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",APPID ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }]];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        NSLog(@"版本号好像比商店大噢!检测到不需要更新");
    }
    
}
#pragma mark-
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
