//
//  MainViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/4/1.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"

#import "HomeViewController.h"

@interface MainViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)CLLocationManager* locationManager;//定位

@property(nonatomic,strong)UILabel* titleLabel;

@property(nonatomic,strong)HomeViewController* homeVC;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = Color333333;
    label.font = PFR17Font;
    label.text = @"";
    self.navigationItem.titleView = label;
    self.titleLabel = label;
    
    NSArray* vc = @[@"HomeViewController",
                    @"CategoryViewController",
                    @"ShoppingCartController",
                    @"MyCenterViewController"];
    
    NSArray* title = @[@"首页",
                       @"分类",
                       @"购物车",
                       @"我的"];
    
    NSArray* image = @[@"tab_item0",
                       @"tab_item1",
                       @"tab_item2",
                       @"tab_item3"];
    
    NSArray* selectedImage = @[@"tab_item0_selected",
                               @"tab_item1_selected",
                               @"tab_item2_selected",
                               @"tab_item3_selected"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : PFR10Font,
                                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]
                                                        } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : PFR10Font,
                                                        NSForegroundColorAttributeName : [UIColor colorWithHexString:@"00A862"]
                                                        } forState:UIControlStateSelected];
    
    NSMutableArray* array = [NSMutableArray array];
    for (NSInteger i = 0; i < vc.count; i++)
    {
        NSString* string = vc[i];
        CustomViewController* controller = [NSClassFromString(string) new];
        if (i == 0) {
            self.homeVC = (HomeViewController *)controller;
        }
        CutomNavigationController *nav = [[CutomNavigationController alloc] initWithRootViewController:controller];
        if (i == vc.count-1) {
            nav.navigationBarHidden = YES;
        }
        
        UITabBarItem* barItem = [[UITabBarItem alloc]initWithTitle:title[i] image:[UIImage imageNamed:image[i]] selectedImage:[[UIImage imageNamed:selectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        barItem.tag = i;
        
        nav.tabBarItem = barItem;
        [array addObject:nav];
    }
    self.viewControllers = array;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLocationCity:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWindowHomeNotify:) name:WindowHomePage_Notify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onWindowShopCartNotify:) name:WindowShopCart_Notify object:nil];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    switch (item.tag) {
        case 0:
            self.titleLabel.text = @"";
            break;
        case 1:
            self.titleLabel.text = @"分类";
            break;
        case 2:
            self.titleLabel.text = @"购物车";
            break;
        case 3:
            self.titleLabel.text = @"";
            break;
            
        default:
            break;
    }
}

- (void)onWindowHomeNotify:(NSNotification *)notify{
    self.selectedIndex = 0;
    self.titleLabel.text = @"";
}


- (void)onWindowShopCartNotify:(NSNotification *)notify{
    self.selectedIndex = 2;
    self.titleLabel.text = @"购物车";
}

#pragma mark- 定位
- (void)startLocationCity:(NSNotification *)notify{
    if (!self.locationManager)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 1000.0f;
    }
    //定位服务是否可用
    BOOL enable=[CLLocationManager locationServicesEnabled];
    //是否具有定位权限
    int status=[CLLocationManager authorizationStatus];
    if(!enable || status<3){
        //请求权限
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *loc = [locations firstObject];
//维度：loc.coordinate.latitude
//经度：loc.coordinate.longitude
    
    [DeviceHelper sharedInstance].location = loc;
    
    NSLog(@"纬度=%f，经度=%f",loc.coordinate.latitude,loc.coordinate.longitude);
    NSLog(@"locations.count  %ld",locations.count);
    
    //判断是不是属于国内范围
    if (![WGS84TOGCJ02 isLocationOutOfChina:[loc coordinate]]) {
        //转换后的coord
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[loc coordinate]];
        
        [self checkAddress:[NSString stringWithFormat:@"%lf",coord.longitude] dimension:[NSString stringWithFormat:@"%lf",coord.latitude]];
    }
    
    
    // 保存 Device 的现语言
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                            objectForKey:@"AppleLanguages"];
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                              forKey:@"AppleLanguages"];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loc
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       if(!error){
                           for (CLPlacemark *place in placemarks) {
                               NSLog(@"placemark.addressDictionary  %@",place.addressDictionary);
                               [DeviceHelper sharedInstance].place = place;
                               
                               NSString *city = place.locality;
                               NSString *administrativeArea = place.administrativeArea;
                               if ([city isEqualToString:administrativeArea]) {
                                   //四大直辖市
//                                   self.addressString = [NSString stringWithFormat:@"%@%@",city,place.subLocality];
                               }else{
//                                   self.addressString = [NSString stringWithFormat:@"%@%@",administrativeArea,city];
                               }
                               break;
                           }
                       }
                       // 还原Device 的语言
                       [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
                   }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    
    switch([error code]) {
        case kCLErrorDenied:
        {
            errorString = @"Access to Location Services denied by user";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"前往设置打开定位功能" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorLocationUnknown:
            errorString = @"Location data unavailable";
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
    if (errorString) {
        NSLog(@"定位失败信息  %@",errorString);
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


- (void)checkAddress:(NSString *)longitude dimension:(NSString *)dimension
{
    NSDictionary* dic = @{
                          @"longitude":longitude,
                          @"dimension":dimension
                          };
    WEAKSELF;
    //data为空代表不在配送范围内
    [AFNetAPIClient POST:[LoginBaseURL stringByAppendingString:APICheckAddress] token:nil parameters:dic success:^(id JSON, NSError *error){
        DataModel* model = [[DataModel alloc] initWithString:JSON error:nil];
        if ([model.data isKindOfClass:[NSArray class]]) {
            NSArray* array = (NSArray *)model.data;
            if (array.count > 0) {
                [DeviceHelper sharedInstance].shop = [[ShopModel alloc] initWithDictionary:[array firstObject] error:nil];
                [weakSelf.homeVC setupMainUI:YES];
            }else{
                [weakSelf.homeVC setupMainUI:NO];
            }
        }else{
            [weakSelf.homeVC setupMainUI:NO];
        }
    } failure:^(id JSON, NSError *error){
        [weakSelf.homeVC setupMainUI:NO];
    }];
}


#pragma mark-
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
