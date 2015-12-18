//
//  NextRegistController.m
//  鸿康护理（护士端）
//
//  Created by CaiNiao on 15/11/19.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "NextRegistController.h"
#import "SelectCell.h"
#import "Utility.h"
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface NextRegistController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    UIImageView *backSelect;//反面图片选取
    UIImageView *frontSelect;//正面图片选取
    UIActionSheet *actionSheet1;//正面图片点击弹框
    UIActionSheet *actionSheet2;//反面图片点击弹框
    UIImagePickerController *pckerController;//正面图片选择器
    UIImagePickerController *pckerController1;//反面图片选择器
    UILabel *proTitleLabel;
    UILabel *cardType;
    UITableView *selectProTitleTableView;
    UITableView *selectCardTypeTableView;
    NSArray *proTitleArray;
    NSArray *cardTypeArray;
    UITextField *nameText;
    UILabel *sexText;
    UITextField *ageText;
    UITextField *exepText;
    UITextField *IDcardText;
    UITextField *cardNumber;
    UIImage *frontIMG;
    UIImage *backIMG;
    UIScrollView *scroll;
    UIActionSheet *AS;//选择性别
    NSString *titleID;
    NSString *certificateID;
}

@end

@implementation NextRegistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.933f green:0.933f blue:0.933f alpha:1.00f];
    [self _createView];
    self.title = @"注册";
    
    
    
}

- (void)_createView {
    scroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    nameText = [[UITextField alloc]initWithFrame:CGRectMake(30, 30, self.view.width-60, 40)];
    nameText.placeholder = @"姓名";
    nameText.textAlignment = NSTextAlignmentCenter;
    nameText.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:nameText];
    
    sexText = [[UILabel alloc]initWithFrame:CGRectMake(30, nameText.bottom+10, nameText.width/2-7, 40)];
    sexText.text = @"性别";
    sexText.textAlignment = NSTextAlignmentCenter;
    sexText.backgroundColor = [UIColor whiteColor];
    sexText.textColor = [UIColor colorWithRed:0.780f green:0.780f blue:0.804f alpha:1.00f];
    sexText.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectSex)];
    tap0.numberOfTapsRequired = 1;
    [sexText addGestureRecognizer:tap0];
    [scroll addSubview:sexText];
    
    ageText = [[UITextField alloc]initWithFrame:CGRectMake(sexText.right+14, nameText.bottom+10, sexText.width, 40)];
    ageText.placeholder = @"年龄";
    ageText.keyboardType = UIKeyboardTypeNumberPad;
    ageText.textAlignment = NSTextAlignmentCenter;
    ageText.backgroundColor = [UIColor whiteColor];
    ageText.delegate = self;
    [scroll addSubview:ageText];
    
    exepText = [[UITextField alloc]initWithFrame:CGRectMake(30, sexText.bottom+10, sexText.width, 40)];
    exepText.keyboardType = UIKeyboardTypeNumberPad;
    exepText.placeholder = @"从业经验";
    exepText.backgroundColor = [UIColor whiteColor];
    exepText.textAlignment = NSTextAlignmentCenter;
    [scroll addSubview:exepText];
    
    UILabel *yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(exepText.right-30, exepText.bottom-30, 30, 20)];
    yearLabel.text = @"年";
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.textColor = [UIColor blackColor];
    [scroll addSubview:yearLabel];
    
    proTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ageText.x, ageText.bottom+10, ageText.width, 40)];
    proTitleLabel.text = @"职称";
    proTitleLabel.textColor = [UIColor colorWithRed:0.780f green:0.780f blue:0.804f alpha:1.00f];
    proTitleLabel.textAlignment = NSTextAlignmentCenter;
    proTitleLabel.backgroundColor = [UIColor whiteColor];
    proTitleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectProTitle)];
    tap.numberOfTapsRequired = 1;
    [proTitleLabel addGestureRecognizer:tap];
    [scroll addSubview:proTitleLabel];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(proTitleLabel.right-30, proTitleLabel.top+10, 20, 20)];
    imgView.image = [UIImage imageNamed:@"下拉_xhdpi"];
    [scroll addSubview:imgView];
    
    
    IDcardText = [[UITextField alloc]initWithFrame:CGRectMake(30, exepText.bottom+10, nameText.width, 40)];
    IDcardText.placeholder = @"身份证号";
    IDcardText.delegate = self;
    IDcardText.keyboardType = UIKeyboardTypeASCIICapable;
    IDcardText.textAlignment = NSTextAlignmentCenter;
    IDcardText.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:IDcardText];
    
    
    //职业认证
    UILabel *occu = [[UILabel alloc]initWithFrame:CGRectMake(30, IDcardText.bottom+20, nameText.width, 20)];
    occu.text = @"职业认证";
    occu.backgroundColor = [UIColor clearColor];
    [scroll addSubview:occu];
    
    //证件类型
    cardType = [[UILabel alloc]initWithFrame:CGRectMake(30, occu.bottom+5, IDcardText.width, 40)];
    cardType.textAlignment = NSTextAlignmentCenter;
    cardType.text = @"请选择上传证件类型";
    cardType.backgroundColor = [UIColor whiteColor];
    cardType.textColor = [UIColor colorWithRed:0.780f green:0.780f blue:0.804f alpha:1.00f];
    cardType.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectCardType)];
    tap1.numberOfTapsRequired = 1;
    [cardType addGestureRecognizer:tap1];
    [scroll addSubview:cardType];
    
    UIImageView *cardTypeSelect = [[UIImageView alloc]initWithFrame:CGRectMake(cardType.right-30, cardType.top+10, 20, 20)];
    cardTypeSelect.image = [UIImage imageNamed:@"下拉_xhdpi"];
    [scroll addSubview:cardTypeSelect];
    
    cardNumber = [[UITextField alloc]initWithFrame:CGRectMake(30, cardType.bottom+10, cardType.width, 40)];
    cardNumber.placeholder = @"请输入证件号码";
    cardNumber.backgroundColor = [UIColor whiteColor];
    cardNumber.textAlignment = NSTextAlignmentCenter;
    cardNumber.delegate = self;
    cardNumber.keyboardType = UIKeyboardTypeASCIICapable;
    [scroll addSubview:cardNumber];
    
    frontSelect = [[UIImageView alloc]initWithFrame:CGRectMake(30, cardNumber.bottom+10, cardNumber.width/2-5, 80)];
    frontSelect.image = [UIImage imageNamed:@"正面_xhdpi"];
    frontSelect.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectFrontPic)];
    tap2.numberOfTapsRequired = 1;
    [frontSelect addGestureRecognizer:tap2];
    frontSelect.backgroundColor = [UIColor redColor];
    [scroll addSubview:frontSelect];
    
    backSelect = [[UIImageView alloc]initWithFrame:CGRectMake(frontSelect.right+10, frontSelect.y, frontSelect.width, 80)];
    backSelect.image = [UIImage imageNamed:@"反面_xhdpi"];
    backSelect.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBackPic)];
    tap3.numberOfTapsRequired = 1;
    [backSelect addGestureRecognizer:tap3];
    backSelect.backgroundColor = [UIColor redColor];
    [scroll addSubview:backSelect];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(30, frontSelect.bottom+10, nameText.width, 40);
    sureButton.backgroundColor = [UIColor colorWithRed:0.294f green:0.475f blue:0.925f alpha:1.00];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确 定" forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 4;
    [sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [scroll addSubview:sureButton];
    
    scroll.contentSize = CGSizeMake(self.view.width, nameText.height+10+sexText.height+10+exepText.height+10+IDcardText.height+20+occu.height+cardType.height+10+cardNumber.height+10+frontSelect.height+sureButton.height+50+64);
    [self.view addSubview:scroll];
                    
}

// 获取职称
- (void)getTitle {
    
    [DataService requestURL:@"getJobtitle" httpMethod:@"post" timeout:10 params:@{@"type":@0} responseSerializer:nil completion:^(id result, NSError *error) {
       
        if (error == nil) {
            
            if ([result[@"err"] isEqualToNumber:@0]) {
                
                proTitleArray = result[@"jobtitle_list"];
                [selectProTitleTableView reloadData];
                selectProTitleTableView.hidden = NO;
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:error.domain];
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



// 选择性别
- (void)selectSex {
    AS = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    [AS showInView:self.view];
}

//确定注册
- (void)sureButtonClick {
    if ([nameText.text isEqualToString:@""] || [sexText.text isEqualToString:@""] || [ageText.text isEqualToString:@""] || [exepText.text isEqualToString:@""] || [proTitleLabel.text isEqualToString:@""] || [IDcardText.text isEqualToString:@""] || [cardType.text isEqualToString:@"请选择上传证件类型"] || [cardNumber.text isEqualToString:@""] || frontIMG == nil || backIMG == nil) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    // 注册
    
    else {
        [SVProgressHUD showWithStatus:@"正在注册。。。"];
        NSDictionary *params = @{@"name":nameText.text,
                                 @"phone":_params[@"phone"],
                                 @"pwd":_params[@"pwd"],
                                 @"gender": [sexText.text isEqualToString:@"男"]? @"0":@"1",@"age":ageText.text,
                                 @"expe":exepText.text,
                                 @"idcard":IDcardText.text,
                                 @"city_id":_params[@"cityID"],
                                 @"hos_id":_params[@"hospitalID"],
                                 @"title_id":titleID,
                                 @"certificate_id":certificateID,
                                 @"certificate_code":cardNumber.text,
                                 @"certificate_img":@[[Utility base64FromImage:frontIMG],[Utility base64FromImage:backIMG]]};
        [DataService requestURL:@"register" httpMethod:@"post" timeout:10 params:params responseSerializer:nil completion:^(id result, NSError *error) {
           
            if (error == nil) {
                
                if ([result[@"err"] isEqualToNumber:@0]) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"注册成功，请登录"];
                    [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:nil afterDelay:1];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                }
            }
            else {
                [SVProgressHUD showErrorWithStatus:error.domain];
            }
        }];
    }
}

//选择反面图片
- (void)selectBackPic {
    actionSheet2 = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍摄照片" otherButtonTitles:@"从相册选取", nil];
    [actionSheet2 showInView:self.view];
}

//选择正面照片
- (void)selectFrontPic {
    actionSheet1 = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍摄照片" otherButtonTitles:@"从相册选取", nil];
    [actionSheet1 showInView:self.view];
}

//选择证件类型
- (void)selectCardType {
    [self.view endEditing:YES];
    selectProTitleTableView.hidden = YES;
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
        [scroll addSubview:selectCardTypeTableView];
        selectCardTypeTableView.hidden = NO;
    }
}

//职称选择
- (void)selectProTitle {
    [self.view endEditing:YES];
    selectCardTypeTableView.hidden = YES;
    selectProTitleTableView.hidden = !selectProTitleTableView.hidden;
    if (proTitleArray == nil) {
        
        [self getTitle];
    }
    if (selectProTitleTableView == nil) {
        selectProTitleTableView = [[UITableView alloc]initWithFrame:CGRectMake(proTitleLabel.x, proTitleLabel.bottom, proTitleLabel.width, 140) style:UITableViewStylePlain];
        selectProTitleTableView.dataSource = self;
        selectProTitleTableView.delegate = self;
        UIView *foot = [[UIView alloc]init];
        foot.backgroundColor = [UIColor clearColor];
        selectProTitleTableView.tableFooterView = foot;
        [selectProTitleTableView registerClass:[SelectCell class] forCellReuseIdentifier:@"proTitle_cell"];
        [scroll addSubview:selectProTitleTableView];
        selectProTitleTableView.hidden = YES;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == actionSheet1 && buttonIndex == 0) {
        BOOL isCamer = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        
        if (!isCamer) {
            
            NSLog(@"没有可用的摄像头");
            return;
        }
        
        pckerController = [[UIImagePickerController alloc] init];
        //指定sourceType 为拍照
        pckerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pckerController.allowsEditing = YES;
        pckerController.delegate = self;
        
        [self presentViewController:pckerController animated:YES completion:nil];
    }
    else if (actionSheet == actionSheet1 && buttonIndex == 1) {
        pckerController = [[UIImagePickerController alloc] init];
        
        //指定资源(照片、视频)的来源
        /*
         UIImagePickerControllerSourceTypePhotoLibrary : 系统相册中所有的文件夹
         UIImagePickerControllerSourceTypeSavedPhotosAlbum : 使用系统的文件夹
         */
        pckerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        pckerController.allowsEditing = YES;
        pckerController.delegate = self;
        
        
        [self presentViewController:pckerController animated:YES completion:nil];
    }
    else if (actionSheet == actionSheet2 && buttonIndex == 0) {
        BOOL isCamer = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        
        if (!isCamer) {
            
            NSLog(@"没有可用的摄像头");
            return;
        }
        
        
        pckerController1 = [[UIImagePickerController alloc] init];
        //指定sourceType 为拍照
        pckerController1.sourceType = UIImagePickerControllerSourceTypeCamera;
        pckerController1.allowsEditing = YES;
        pckerController1.delegate = self;
        
        [self presentViewController:pckerController1 animated:YES completion:nil];
    }
    else if (actionSheet == actionSheet2 && buttonIndex == 1) {
        pckerController1 = [[UIImagePickerController alloc] init];
        
        //指定资源(照片、视频)的来源
        /*
         UIImagePickerControllerSourceTypePhotoLibrary : 系统相册中所有的文件夹
         UIImagePickerControllerSourceTypeSavedPhotosAlbum : 使用系统的文件夹
         */
        pckerController1.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        pckerController1.allowsEditing = YES;
        pckerController1.delegate = self;
        
        
        [self presentViewController:pckerController1 animated:YES completion:nil];
    }
    else if (actionSheet == AS && buttonIndex == 0) {
        sexText.text = @"男";
        sexText.textColor = [UIColor blackColor];
    }
    else if (actionSheet == AS && buttonIndex == 1) {
        sexText.text = @"女";
        sexText.textColor = [UIColor blackColor];
    }
}
#pragma mark - UIImagePickerController delegate
//选择照片、拍照 完成之后调用的协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //    NSLog(@"%@",info);
    if (picker == pckerController) {
        NSString *mediaType = info[UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:@"public.image"]) {  //照片资源
            //取得选取的照片
            UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
            if (img == nil) {
                
                img = [info objectForKey:UIImagePickerControllerOriginalImage];
            }
            frontSelect.image = img;
            
            frontIMG = img;
            
            //判断照片是否来自摄像头
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                
                //保存到相册,@selector(image:didFinishSavingWithError:contextInfo:)  保存成功之后调用的方法
                UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                frontSelect.image = img;
                frontIMG = img;
            }
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];

    }
    else {
        NSString *mediaType = info[UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:@"public.image"]) {  //照片资源
            //取得选取的照片
            UIImage *img = info[@"UIImagePickerControllerEditedImage"];
            if (img == nil) {
                
                img = [info objectForKey:UIImagePickerControllerOriginalImage];
            }
            backSelect.image = img;
            backIMG = img;
            
            //判断照片是否来自摄像头
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                
                //保存到相册,@selector(image:didFinishSavingWithError:contextInfo:)  保存成功之后调用的方法
                UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                backSelect.image = img;
                backIMG = img;
            }
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//保存照片到相册成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    

    
}

//取消按钮的点击事件
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark talbeView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == selectCardTypeTableView) {
        return cardTypeArray.count;
    }
    return proTitleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == selectCardTypeTableView) {
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardtype_cell"];
        cell.textstring = cardTypeArray[indexPath.row][@"name"];
        return cell;
    }
    else if (tableView == selectProTitleTableView){
        SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"proTitle_cell"];
        cell.textstring = proTitleArray[indexPath.row][@"name"];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == selectCardTypeTableView) {
        cardType.text = cardTypeArray[indexPath.row][@"name"];
        cardType.textColor = [UIColor blackColor];
        certificateID = cardTypeArray[indexPath.row][@"id"];
        selectCardTypeTableView.hidden = YES;
    }
    else if (tableView == selectProTitleTableView) {
        proTitleLabel.textColor = [UIColor blackColor];
        proTitleLabel.text = proTitleArray[indexPath.row][@"name"];
        titleID = proTitleArray[indexPath.row][@"id"];
        selectProTitleTableView.hidden = YES;
    }
}

#pragma mark textfiled delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == ageText) {
        if ([textField.text integerValue]<18 || [textField.text integerValue]>60 || [textField.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"输入有误"];
            textField.text = @"";
        }
    }
    else if (textField == exepText) {
        if ([textField.text integerValue]<0 || [textField.text integerValue]>60 || [textField.text isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"输入有误"];
                        textField.text = @"";
        }
    }
    else if (textField == IDcardText) {
        
        if (![Utility isValidateIDCard:textField.text]) {
            [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号"];
                        textField.text = @"";
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == ageText) {
        return YES;
    }
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
    
}
@end
