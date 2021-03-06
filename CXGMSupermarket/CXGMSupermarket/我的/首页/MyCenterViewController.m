//
//  MyCenterViewController.m
//  CXGMSupermarket
//
//  Created by 天闻 on 2018/4/18.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "MyCenterViewController.h"
//head
#import "MyCenterHeadView.h"
//cell
#import "MyCenterGridCell.h"
#import "MyCenterCollectionCell.h"
//foot
#import "BlankCollectionFootView.h"

#import "CouponViewController.h"
#import "OrderViewController.h"
#import "AddressViewController.h"
#import "SettingViewController.h"
#import "InvitationViewController.h"
#import "HelpViewController.h"

@interface MyCenterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong , nonatomic)UICollectionView *collectionView;

@property (strong , nonatomic)NSArray *sectionArr0;
@property (strong , nonatomic)NSArray *sectionArr1;
@property (strong , nonatomic)NSArray *sectionArr2;
@end

/* cell */
static NSString *const MyCenterGridCellID = @"MyCenterGridCell";
static NSString *const MyCenterCollectionCellID = @"MyCenterCollectionCell";
/* head */
static NSString *const MyCenterHeadViewID = @"MyCenterHeadView";
/* foot */
static NSString *const BlankCollectionFootViewID = @"BlankCollectionFootView";

@implementation MyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sectionArr0 = @[@"全部订单",@"待付款",@"待配送",@"待收货",@"轻松退"];

//    self.sectionArr1 = @[@"邀请有礼"];
    self.sectionArr2 = @[@[@"优惠券",@"myCenter_item0"],
                         @[@"收货地址",@"myCenter_item1"],
                         @[@"帮助中心",@"myCenter_item2"],
                         @[@"联系客服",@"myCenter_item3"],
                         @[@"设置",@"myCenter_item4"]];
    

    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    self.collectionView.contentInset = UIEdgeInsetsMake(-STATUS_BAR_HEIGHT, 0, 0, 0);
}

- (BOOL)needJumpToLogin
{
    if (![UserInfoManager sharedInstance].isLogin) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoginVC_Notify object:nil];
        return YES;
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.collectionView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0/255.0 green:168/255.0 blue:98/255.0 alpha:1/1.0]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionArr0.count;
    }
    
    if (section == 1) {
        return self.sectionArr2.count;
    }

    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *gridcell = nil;
    
    if (indexPath.section == 0)
    {
        MyCenterGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyCenterGridCellID forIndexPath:indexPath];
        [cell setImage:[NSString stringWithFormat:@"dingdan_item%ld",(long)indexPath.item] title:self.sectionArr0[indexPath.item]];
        gridcell = cell;
        
    }
//    else if (indexPath.section == 1)
//    {
//        MyCenterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyCenterCollectionCellID forIndexPath:indexPath];
//        [cell setImage:@"gift_icon" title:self.sectionArr1[indexPath.item] subTitle:@"新鲜生鲜水果邀请好友共享！"];
//        gridcell = cell;
//    }
    else if (indexPath.section == 1)
    {
        MyCenterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyCenterCollectionCellID forIndexPath:indexPath];
        [cell setImage:[self.sectionArr2[indexPath.item] objectAtIndex:1] title:[self.sectionArr2[indexPath.item] objectAtIndex:0] subTitle:indexPath.item ==0? @"兑换吃、查看优惠券":@""];
        
        gridcell = cell;
    }


    
    return gridcell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        if (indexPath.section == 0) {
            MyCenterHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyCenterHeadViewID forIndexPath:indexPath];
            [headerView refreshUI];
            
            typeof(self) __weak wself = self;
            headerView.loginHander = ^{
                [wself needJumpToLogin];
            };
            reusableview = headerView;
        }
        
    }
    if (kind == UICollectionElementKindSectionFooter) {
        if (indexPath.section == 0 || indexPath.section == 1) {
            BlankCollectionFootView *footview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID forIndexPath:indexPath];
            reusableview = footview;
        }
    }
    return reusableview;
}


#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(ScreenW/5 , 70);
    }
    if (indexPath.section == 1 ) {
        return CGSizeMake(ScreenW, 50);
    }

    return CGSizeZero;
}

#pragma mark - head宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(ScreenW, 195);
    }
    return CGSizeZero;
}

#pragma mark - foot宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    if (section == 0 || section == 1) {
        return CGSizeMake(ScreenW,10);
    }
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 1) ? 1 : 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:{
            if ([self needJumpToLogin]) return;
            
            OrderViewController* vc = [OrderViewController new];
            vc.pageIndex = indexPath.item;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//            case 1:{
//                InvitationViewController* vc = [InvitationViewController new];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//
//                break;
        case 1:{
            
            if (indexPath.item == 2) {//帮助中心
                HelpViewController * vc = [HelpViewController new];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
            
            if (indexPath.item == 3) {//联系客服
                NSURL * url = [NSURL URLWithString:@"tel:4000130888"];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }
                return;
            }
            
            if (indexPath.item == 4)//设置
            {
                SettingViewController * vc = [SettingViewController new];
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            
            if ([self needJumpToLogin]) return;
            
            if (indexPath.item == 0) {//优惠券
                CouponViewController * vc = [CouponViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (indexPath.item == 1) {//收货地址
                AddressViewController * vc = [AddressViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
            break;
            
        default:
            break;
    }
}


#pragma mark - initial
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;        
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerClass:[MyCenterGridCell class] forCellWithReuseIdentifier:MyCenterGridCellID];
        [_collectionView registerClass:[MyCenterCollectionCell class] forCellWithReuseIdentifier:MyCenterCollectionCellID];

        [_collectionView registerClass:[MyCenterHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyCenterHeadViewID];

        [_collectionView registerClass:[BlankCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BlankCollectionFootViewID];

        [self.view addSubview:_collectionView];
        
        
    }
    return _collectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat off_y = scrollView.contentOffset.y;
    if (off_y<0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

@end
