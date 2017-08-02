//
//  FNAreaVC.m
//  BonusStore
//
//  Created by Nemo on 16/5/24.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNAreaVC.h"
#import "FNMyBO.h"

NSMutableDictionary *FNAreaInfo;

@interface FNAreaVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_array;
}

@end

@implementation FNAreaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableViewDelegate = self;
    
    __weak __typeof(self) weakSelf = self;
    
    if (self.isProvice)
    {
        [[FNMyBO port02] getProVincesListWithBlock:^(id result) {
            
            if (result && [result isKindOfClass:[NSArray class]])
            {
                [_array addObjectsFromArray:result];
            }
            
            [weakSelf.tableView reloadData];
            
        }];
    }
    else if (self.provinceId)
    {
        [FNMyBO getCitysListWithProvinceId:[self.provinceId integerValue] block:^(id result) {
            
            if (result && [result isKindOfClass:[NSArray class]])
            {
                [_array addObjectsFromArray:result];
            }
            
        }];
        
         [weakSelf.tableView reloadData];
    }
    else if (self.cityId)
    {
        [FNMyBO getCountysListWithCityId:[self.cityId integerValue] block:^(id result) {
            
            if (result && [result isKindOfClass:[NSArray class]])
            {
                [_array addObjectsFromArray:result];
            }
            
        }];
         [weakSelf.tableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    FNAreaArgs *area = _array[indexPath.row];
    
    if (self.isProvice)
    {
        cell.textLabel.text = area.provinceName;
    }
    else if (self.provinceId)
    {
        cell.textLabel.text = area.cityName;
    }
    else if (self.cityId)
    {
        cell.textLabel.text = area.countyName;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FNAreaArgs *area = _array[indexPath.row];

    FNAreaVC *vc = [[FNAreaVC alloc] init];
    
    if (self.isProvice)
    {
        vc.provinceId = area.provinceId;
        
        [FNAreaInfo addEntriesFromDictionary:@{@"provinceId":area.provinceId,@"provinceName":area.provinceName}];
    }
    else if (self.provinceId)
    {
        vc.cityId = area.cityId;
    
        [FNAreaInfo addEntriesFromDictionary:@{@"cityId":area.cityId,@"cityName":area.cityName}];
    }
    else if (self.cityId)
    {
        [FNAreaInfo addEntriesFromDictionary:@{@"countyId":area.countyId,@"countyName":area.countyName}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
