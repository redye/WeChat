
//
//  WCChatViewController.m
//  WeChat
//
//  Created by hu on 15/12/9.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCChatViewController.h"
#import "WCInputView.h"

@interface WCChatViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSLayoutConstraint *inputViewBottomContraints;

@end

@implementation WCChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self addObservers];
}

- (void)setUI
{
    //代码方式实现自动布局 VFL
    //创建一个 tableView 显示数据
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor redColor];
    //代码实现自动约束，要设置自动布局属性为NO
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    //创建输入框
    WCInputView *inputView = [WCInputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:inputView];
    
    //自动布局
    //水平方向
    NSDictionary *views = @{@"tableView":tableView,
                            @"inputView":inputView};
    NSArray *tableViewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHContraints];
    
    NSArray *inputViewHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHContraints];
    
    //垂直方向
    NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    self.inputViewBottomContraints = [vContraints lastObject];
    [self.view addConstraints:vContraints];
}

- (void)addObservers
{
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval timeInterval = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    NSValue *value = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = CGRectZero;
    [value getValue:&rect];
    
    CGFloat keyboardHeight = rect.size.height;
    //如果是 iOS7 一下的，但横屏时，键盘的高度是 size.width
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0 && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        keyboardHeight = rect.size.width;
    }
    [UIView animateWithDuration:timeInterval animations:^{
        self.inputViewBottomContraints.constant = keyboardHeight;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.inputViewBottomContraints.constant = 0;
}


- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
    NSInteger direction = 1;
    if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        direction = -1;
    }
    
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval timeInterval = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    NSValue *value = userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect rect = CGRectZero;
    [value getValue:&rect];
    CGFloat y = rect.origin.y;
    [UIView animateWithDuration:timeInterval animations:^{
        self.inputViewBottomContraints.constant = [UIScreen mainScreen].bounds.size.height - y;
    }];
}

- (void)loadMessage
{

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
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
