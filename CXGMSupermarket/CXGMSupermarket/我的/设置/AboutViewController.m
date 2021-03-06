//
//  AboutViewController.m
//  CXGMSupermarket
//
//  Created by zhu yingmin on 2018/7/1.
//  Copyright © 2018年 zhu yingmin. All rights reserved.
//

#import "AboutViewController.h"
#import "SettingTableViewCell.h"

#import "EmployeesViewController.h"
#import "HTMLViewController.h"

@interface AboutViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)NSArray* dataArray;
@property(nonatomic,strong)NSArray* tempArray;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    UIImageView* iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_icon"]];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(self.view);
        make.top.equalTo(36);
    }];
    
    UILabel* label = [UILabel new];
    label.text = @"菜鲜果美";
    label.textColor = Color333333;
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:22];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(iconView.bottom).offset(15);
        make.centerX.equalTo(self.view);
    }];
    
    label = [[UILabel alloc] init];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    label.text = [NSString stringWithFormat:@"版本:V %@",appVersion];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    label.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(iconView.bottom).offset(53);
        make.centerX.equalTo(self.view);
    }];
    
    if ([DeviceHelper sharedInstance].showWineCategory) {
        self.dataArray = @[@"菜鲜果美会员服务协议",
                           @"菜鲜果美隐私权政策",
                           @"菜鲜果美商家信息",
                           @"菜鲜果美内部专用入口"];
    }else{
        self.dataArray = @[@"菜鲜果美会员服务协议",
                           @"菜鲜果美隐私权政策",
                           @"菜鲜果美商家信息"];
    }
    
    self.tempArray = @[@[@"service_agreement.html",@"会员服务协议"],
                       @[@"private.html",@"隐私权政策"],
                       @[@"business_info.html",@"商家信息"]];
    

    _tableView = [UITableView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(iconView.bottom).offset(106);
    }];
    _tableView.tableFooterView = [UIView new];
    
}

#pragma mark-
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
    if (!cell) {
        cell = [[SettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutCell"];
        UIView* line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"E8E8E8"];
        [cell addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.right.bottom.equalTo(cell);
            make.height.equalTo(1);
        }];
    }
    cell.rightLabel.hidden = YES;
    cell.switchButton.hidden = YES;
    cell.arrowView.hidden = NO;
    
    cell.leftLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        EmployeesViewController* vc = [EmployeesViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        HTMLViewController* vc = [HTMLViewController new];
        vc.fileName = self.tempArray[indexPath.row][0];
        vc.title = self.tempArray[indexPath.row][1];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
