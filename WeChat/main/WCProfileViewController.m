//
//  WCProfileViewController.m
//  WeChat
//
//  Created by hu on 15/12/5.
//  Copyright © 2015年 redye. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WCEditProfileViewController.h"

@interface WCProfileViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, WCEditProfileViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *haedView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;//昵称

@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;//微信号
@property (weak, nonatomic) IBOutlet UILabel *orgnameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮件



@end

@implementation WCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    [self loadCard];
}

- (void)loadCard
{
    //显示个人信息
    
    //XMPP提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;

    //设置头像
    if (myVCard.photo) {
        self.haedView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    self.nicknameLabel.text = myVCard.nickname;
    
    self.weixinNumLabel.text = [WCUser sharedWCUser].name;
    
    self.orgnameLabel.text = myVCard.orgName;
    
    //部门：可能有多个
    if (myVCard.orgUnits.count > 0) {
        self.orgunitLabel.text = [myVCard.orgUnits objectAtIndex:0];
    } else {
        self.orgunitLabel.text = nil;
    }
    
    self.titleLabel.text = myVCard.title;
    
    //电话
#warning myVCard.telecomsAddresses 这个get方法，没有对电子名片的xml数据进行解析
    // 使用note字段充当电话
    self.phoneLabel.text = myVCard.note;
    
    self.emailLabel.text = myVCard.mailer;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = cell.tag;
    
    if (tag == 2) { //步子哦任何操作
        WCLog(@"不做任何操作");
        return;
    }
    
    if (tag == 0) { //选择照片
        WCLog(@"选择照片");
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相机", nil];
        [sheet showInView:self.view];
    } else {
        WCLog(@"跳到下一个控制器");
        [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];
        
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;  //点击了取消
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        //照相
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        //相册
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.haedView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //更新到服务器
    [self editProfileViewControllerDidSave];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[WCEditProfileViewController class]]) {
        WCEditProfileViewController *editProfileViewController = (WCEditProfileViewController *)destinationViewController;
        editProfileViewController.cell = sender;
    }
}

#pragma mark - WCEditProfileViewControllerDelegate
- (void)editProfileViewControllerDidSave
{
    //获取当前的电子卡片信息
    XMPPvCardTemp *vCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    vCard.photo = UIImagePNGRepresentation(self.haedView.image);
    vCard.nickname = self.nicknameLabel.text;
    vCard.orgName = self.orgnameLabel.text;
    
    if (self.orgunitLabel.text.length > 0) {
        vCard.orgUnits = @[self.orgunitLabel.text];
    }
    
    vCard.title = self.titleLabel.text;
    vCard.note = self.phoneLabel.text;
    vCard.mailer = self.emailLabel.text;
    
    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:vCard];
}
@end
