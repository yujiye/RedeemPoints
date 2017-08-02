//
//  FNReturnReasonView.m
//  BonusStore
//
//  Created by Nemo on 16/4/21.
//  Copyright © 2016年 Nemo. All rights reserved.
//

#import "FNReturnReasonView.h"

@interface FNReturnReasonView ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    UIButtonActionBlock _confirmBlock;
    
    UIButtonActionBlock _cancelBlock;
    
    UIButtonActionBlock _protoBlock;
    
    NSArray *_array;
    
    NSMutableSet *_set;
    
    UIView *_bg;
}

@end

@implementation FNReturnReasonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _array = @[@"买贵了",@"质量有问题",@"货不对板",@"不想要了，就是这么任性"];
        
        _set = [[NSMutableSet alloc] init];
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        tap.delegate = self;
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];

        _bg = [[UIView alloc]initWithFrame:CGRectMake(0, kAverageValue(kWindowHeight-300), kWindowWidth-110, 300)];
        
        [_bg setCorner:5];
        
        _bg.backgroundColor = [UIColor whiteColor];
        
        [_bg setHorizonCenterWithSuperView:self];
        
        [self addSubview:_bg];
        
        UILabel *headerLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 100, 20)];
        
        headerLeftLabel.text = @"为什么不要我？";
        
        [headerLeftLabel clearBackgroundWithFont:[UIFont fzltWithSize:14] textColor:MAIN_COLOR_BLACK_ALPHA];
        
        [_bg addSubview:headerLeftLabel];

        
        UILabel *headerRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bg.width-95, headerLeftLabel.y, 80, 20)];
        
        headerRightLabel.textAlignment = NSTextAlignmentRight;
        
        headerRightLabel.text = @"查看退货政策";
        
        [headerRightLabel clearBackgroundWithFont:[UIFont fzltWithSize:12] textColor:UIColorWithRGB(35, 115, 211)];
        
        [_bg addSubview:headerRightLabel];
        
        [headerRightLabel addTarget:self action:@selector(goProto)];
        
        CALayer *line = [CALayer layerWithFrame:CGRectMake(5, headerRightLabel.y + headerRightLabel.height+7, _bg.width, 1)];
        
        [_bg.layer addSublayer:line];
        
        
        UITableView *_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, line.frame.origin.y + line.frame.size.height+5, _bg.width, 35*4)];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_bg addSubview:_tableView];


        _field = [[FNTextField alloc] init];
        
        _field.frame = CGRectMake(10, _tableView.y + _tableView.height + 10, _bg.width-20, 35);
        
        _field.delegate = self;
        
        [_field setBorderWithWidth:1 color:UIColorWithRGB(169, 170, 171)];
        
        _field.placeholder = @"其他原因请输入(30字以内)";
        
        [_bg addSubview:_field];
        
        _field.isToolBar = NO;
        
        _field.returnKeyType = UIReturnKeyDone;
        
        FNButton *confirmBut = [FNButton buttonWithType:FNButtonTypeEdge title:@"确认退货"];
        
        confirmBut.frame = CGRectMake(_field.x, _field.y + _field.height + 20, kAverageValue(_bg.width-20-22), 26);
        
        [confirmBut setCorner:5];
        
        [confirmBut addSuperView:_bg ActionBlock:^(id sender) {
            
            _confirmBlock(sender);
            
        }];
        
        
        FNButton *cancelBut = [FNButton buttonWithType:FNButtonTypePlain title:@"再想想"];
        
        cancelBut.frame = CGRectMake(confirmBut.x + confirmBut.width + 22, confirmBut.y, kAverageValue(_bg.width-20-22), 26);
        
        [cancelBut setCorner:5];
        
        [cancelBut addSuperView:_bg ActionBlock:^(id sender) {

            _cancelBlock(sender);
            
        }];

    }
    return self;
}

- (void)show
{
    self.hidden = NO;
}

- (void)hide
{
    self.hidden = YES;
    
    [self endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell =  [[[UITableViewCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.textLabel.font = [UIFont fzltWithSize:12];
    }
    
    cell.textLabel.text = _array[indexPath.row];
    
    if ([_set containsObject:_array[indexPath.row]])
    {
        cell.imageView.image = [UIImage imageNamed:@"product_return_check_s"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"product_return_check_n"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_set removeAllObjects];
    
    [_set addObject:_array[indexPath.row]];
    
    _reason = _array[indexPath.row];
    
    [tableView reloadData];
}

- (void)goProto
{
    _protoBlock(nil);
}

- (void)setProto:(UIButtonActionBlock)block
{
    _protoBlock = nil;
    
    _protoBlock = block;
}

- (void)setConfirm:(UIButtonActionBlock)confirm cancel:(UIButtonActionBlock)cancel
{
    _confirmBlock = nil;
    
    _cancelBlock = nil;
    
    _confirmBlock = confirm;
    
    _cancelBlock = cancel;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self];
    
    if (CGRectContainsPoint(_bg.frame, point))
    {
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.35 animations:^{
       
        UIReframeWithY(_bg, 50);
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        NSUInteger  character = 0;
        for(int i=0; i< [textField.text length];i++){
            character +=1;
        }
        if(character >29 && ![NSString isEmptyString:string])
        {
            [textField resignFirstResponder];
            [self makeToast:@"请确认退货理由少于30个字"];
            return NO;
        }else
        {
            return YES;
        }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length >30)
    {
        textField.text = [textField.text substringToIndex:30];
        
    }
    [UIView animateWithDuration:0.35 animations:^{
        
        UIReframeWithY(_bg, kAverageValue(kWindowHeight-300));
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
