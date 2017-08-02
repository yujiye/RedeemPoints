#import "FNPriceChoice.h"
#import "FNHeader.h"

@interface FNPriceChoice ()<UITableViewDelegate,UITableViewDataSource>
{
    PriceChoiceClickBlock _priceChoiceClickBlock;
}

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation FNPriceChoice

- (void)setPriceChoiceClick:(PriceChoiceClickBlock)block
{
    _priceChoiceClickBlock = nil;
    _priceChoiceClickBlock = block;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigaitionBackItem];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择充值数量";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    if ([self.tableView respondsToSelector: @selector (setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        [self.tableView setSeparatorColor:MAIN_BACKGROUND_COLOR];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuserId = NSStringFromClass([self class]);
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:reuserId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.frame = CGRectMake(20, 0, kScreenWidth -48, 60);
        cell.textLabel.font = [UIFont fzltWithSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = UIColorWithRGB(51, 51, 51);
    }
    NSString * str  = self.dataArr[indexPath.row];
    NSString * needStr = [NSString stringWithFormat:@"%ld元",(NSUInteger)([str integerValue]*[self.price  integerValue])];
    cell.textLabel.text = needStr;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * choicePrice = self.dataArr[indexPath.row];
    if(_priceChoiceClickBlock)
    {
        _priceChoiceClickBlock(choicePrice);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end
