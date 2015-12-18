//
//  AddCertificateViewController.m
//  鸿康护理-护士端
//
//  Created by 肖胜 on 15/11/24.
//  Copyright (c) 2015年 肖胜. All rights reserved.
//

#import "AddCertificateViewController.h"
#import "SelectCell.h"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface AddCertificateViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    UILabel *cardType;                      // 证件类型
    UITextField *cardNumber;
    UIImageView *frontSelect;
    UIImageView *backSelect;
    UITableView *selectCardTypeTableView;
    NSArray *cardTypeArray;
    NSString *certificateID;
    UIImagePickerController *imgPicker;
    UIImageView *currentImgView;
    UIImage *frontImg;
    UIImage *backImg;
}
@end

@implementation AddCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"添加证书";
    [self createSubviews];
}

- (void)createSubviews {
    
    //证件类型
    cardType = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, self.view.width-60, 40)];
    cardType.textAlignment = NSTextAlignmentCenter;
    cardType.text = @"请选择上传证件类型";
    cardType.backgroundColor = [UIColor whiteColor];
    cardType.textColor = [UIColor colorWithRed:0.780f green:0.780f blue:0.804f alpha:1.00f];
    cardType.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCardType)];
    tap1.numberOfTapsRequired = 1;
    [cardType addGestureRecognizer:tap1];
    [self.view addSubview:cardType];
    
    UIImageView *cardTypeSelect = [[UIImageView alloc]initWithFrame:CGRectMake(cardType.right-30, cardType.top+10, 20, 20)];
    cardTypeSelect.image = [UIImage imageNamed:@"下拉_xhdpi"];
    [self.view addSubview:cardTypeSelect];
    
    cardNumber = [[UITextField alloc]initWithFrame:CGRectMake(30, cardType.bottom+10, cardType.width, 40)];
    cardNumber.placeholder = @"请输入证件号码";
    cardNumber.delegate = self;
    cardNumber.keyboardType = UIKeyboardTypeASCIICapable;
    cardNumber.backgroundColor = [UIColor whiteColor];
    cardNumber.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:cardNumber];
    
    frontSelect = [[UIImageView alloc]initWithFrame:CGRectMake(30, cardNumber.bottom+10, cardNumber.width/2-5, 80)];
    frontSelect.image = [UIImage imageNamed:@"正面_xhdpi"];
    frontSelect.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPic:)];
    tap2.numberOfTapsRequired = 1;
    [frontSelect addGestureRecognizer:tap2];
    frontSelect.backgroundColor = [UIColor redColor];
    [self.view addSubview:frontSelect];
    
    backSelect = [[UIImageView alloc]initWithFrame:CGRectMake(frontSelect.right+10, frontSelect.y, frontSelect.width, 80)];
    backSelect.image = [UIImage imageNamed:@"反面_xhdpi"];
    backSelect.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectPic:)];
    tap3.numberOfTapsRequired = 1;
    [backSelect addGestureRecognizer:tap3];
    backSelect.backgroundColor = [UIColor redColor];
    [self.view addSubview:backSelect];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(30, frontSelect.bottom+10, cardNumber.width, 40);
    sureButton.backgroundColor = [UIColor colorWithRed:0.294f green:0.475f blue:0.925f alpha:1.00];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确认添加" forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 4;
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:sureButton];
    
    
}

// 选择图片
- (void)selectPic:(UITapGestureRecognizer *)tap {
   
    currentImgView = (UIImageView *)tap.view;
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
}

//选择证件类型
- (void)selectCardType {
    [self.view endEditing:YES];
    selectCardTypeTableView.hidden = !selectCardTypeTableView.hidden;
    if (cardTypeArray == nil) {
        
        [self getCards];
    }
    
    if (selectCardTypeTableView == nil) {
        selectCardTypeTableView = [[UITableView alloc]initWithFrame:CGRectMake(cardType.x, cardType.bottom, cardType.width, 140) style:UITableViewStylePlain];
        selectCardTypeTableView.dataSource = self;
        selectCardTypeTableView.delegate = self;
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = [UIColor clearColor];
        selectCardTypeTableView.tableFooterView = foot;
        [selectCardTypeTableView registerClass:[SelectCell class] forCellReuseIdentifier:@"cardtype_cell"];
        [self.view addSubview:selectCardTypeTableView];
        selectCardTypeTableView.hidden = YES;
    }
}

// 确认添加
- (void)sureButtonClick:(UIButton *)button {
    
    if ([cardType.text isEqualToString:@"请选择上传证件类型"]) {
        
        [SVProgressHUD showErrorWithStatus:@"请选择证件类型"];
        return;
    }
    if (!cardNumber.text.length) {
        
        [SVProgressHUD showErrorWithStatus:@"请输入证件号码"];
        return;
    }
    if (frontImg == nil || backImg == nil) {
        
        [SVProgressHUD showErrorWithStatus:@"证件照正反面为必填"];
        return;
    }
    button.enabled = NO;
    // 添加
    [SVProgressHUD showWithStatus:@"添加中。。。"];
    [DataService requestURL:@"addNurseCredentials" httpMethod:@"post" timeout:10 params:@{@"nurse_id":[Utility getID],@"certificate_id":certificateID, @"certificate_code":cardNumber.text, @"certificate_img":@[[Utility base64FromImage:frontImg],[Utility base64FromImage:backImg]]} responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                if ([_delegate respondsToSelector:@selector(AddCertificateSuccess:)]) {
                    
                    NSDictionary *dic = @{@"name":cardType.text,@"credentials_code":cardNumber.text,@"id":result[@"id"]};
                    [_delegate AddCertificateSuccess:dic];
                    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:1];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                button.enabled = YES;
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
            button.enabled = YES;
        }
    }];
}

// 获取证书类型
- (void)getCards {
    
    [DataService requestURL:@"getCredentials" httpMethod:@"post" timeout:10 params:nil responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                cardTypeArray = result[@"credentials_list"];
                [selectCardTypeTableView reloadData];
                selectCardTypeTableView.hidden = NO;
            }
            else {
                
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 || buttonIndex == 1) {
        
        if (imgPicker == nil) {
            
            imgPicker = [[UIImagePickerController alloc]init];
            imgPicker.allowsEditing = YES;
            imgPicker.delegate = self;
        }
    }
    switch (buttonIndex) {
            //相机
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imgPicker animated:YES completion:nil];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"此设备不支持相机"];
            }
            break;
            // 相册
        case 1:
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imgPicker animated:YES completion:nil];
            break;
            // 取消
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if (img == nil) {
        
        img = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
    currentImgView.image = img;
    if (currentImgView == frontSelect) {
        
        frontImg = img;
    }
    if (currentImgView == backSelect) {
        
        backImg = img;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

#pragma mark talbeView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
        return cardTypeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardtype_cell"];
        cell.textstring = cardTypeArray[indexPath.row][@"name"];
        return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
        cardType.text = cardTypeArray[indexPath.row][@"name"];
        cardType.textColor = [UIColor blackColor];
        certificateID = cardTypeArray[indexPath.row][@"id"];
        selectCardTypeTableView.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
    
}
@end
