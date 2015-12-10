//
//  WCEditProfileViewController.m
//  WeChat
//
//  Created by hu on 15/12/5.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCEditProfileViewController.h"
#import "XMPPvCardTemp.h"

@interface WCEditProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑个人信息";

    self.textField.text = self.cell.detailTextLabel.text;
    self.textField.placeholder = self.cell.textLabel.text;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnClick)];
}

- (void)saveBtnClick
{
    self.cell.detailTextLabel.text = self.textField.text;
    [self.cell layoutIfNeeded];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(editProfileViewControllerDidSave)]) {
        [self.delegate editProfileViewControllerDidSave];
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
