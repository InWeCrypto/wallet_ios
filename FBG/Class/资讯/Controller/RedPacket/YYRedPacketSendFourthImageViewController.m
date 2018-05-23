//
//  YYRedPacketSendFourthImageViewController.m
//  FBG
//
//  Created by yy on 2018/4/25.
//  Copyright © 2018年 ButtonRoot. All rights reserved.
//

#import "YYRedPacketSendFourthImageViewController.h"
#import "DBHPlaceHolderTextView.h"
#import <AliyunOSSiOS/OSSService.h>
#import "TZImagePickerController.h"
#import "YYRedPacketPreviewViewController.h"

@interface YYRedPacketSendFourthImageViewController ()<TZImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@property (weak, nonatomic) IBOutlet UIView *senderView;
@property (weak, nonatomic) IBOutlet UITextField *senderNameTextField;

@property (weak, nonatomic) IBOutlet UIView *bestView;
@property (weak, nonatomic) IBOutlet DBHPlaceHolderTextView *bestTextView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *deletePhotoBtn;
@property (assign, nonatomic) BOOL isSendRedBag;

@property (copy, nonatomic) NSString *selectedImageURL;

@end

@implementation YYRedPacketSendFourthImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self redPacketNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

/**
 父类方法
 */
- (void)setNavigationBarTitleColor {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WHITE_COLOR, NSFontAttributeName:FONT(18)}];
}

#pragma mark ------- SetUI ---------
- (void)setUI {
    self.title = DBHGetStringWithKeyFromTable(@"Send Red Packet", nil);
    
    [self.senderNameTextField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    self.bestTextView.delegate = self;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 4);
    layer.backgroundColor = COLORFROM16(0x029857, 1).CGColor;
    [self.progressView.layer addSublayer:layer];
    
    self.fourthLabel.text = [NSString stringWithFormat:@"%@：", DBHGetStringWithKeyFromTable(@"Fourth", nil)];
    self.tipLabel.text = DBHGetStringWithKeyFromTable(@"Generate style, Preview And Share", nil);
    
    self.styleLabel.text = self.styleStr;
    
    [self.senderView setBorderWidth:0.5f color:COLORFROM16(0xD9D9D9, 1)];
    [self.bestView setBorderWidth:0.5f color:COLORFROM16(0xD9D9D9, 1)];
    
    self.senderNameTextField.placeholder = DBHGetStringWithKeyFromTable(@"Sender's Name", nil);
    self.bestTextView.placeholder = DBHGetStringWithKeyFromTable(@"Wishes / Messages", nil);
    
    [self.shareBtn setBackgroundColor:COLORFROM16(0xD5D5D5, 1) forState:UIControlStateDisabled];
    [self.shareBtn setBackgroundColor:COLORFROM16(0xEA6204, 1) forState:UIControlStateNormal];
    
    self.shareBtn.enabled = NO;
    [self.shareBtn setCorner:2];
    [self.shareBtn setTitle:DBHGetStringWithKeyFromTable(@"Preview And Share", nil) forState:UIControlStateNormal];
    
    self.photoView.layer.cornerRadius = AUTOLAYOUTSIZE(2);
    self.photoView.layer.masksToBounds = YES;
    self.deletePhotoBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark ------ TZImagePickerControllerDelegate ------
/**
 选择照片回调
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    //获取到图片
    NSString *endpoint = @"http://oss-cn-shanghai.aliyuncs.com";
    
    WEAKSELF
    id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken *
                                             {
                                                 // 构造请求访问您的业务server
                                                 NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sts",APP_APIEHEAD]];
                                                 NSURLRequest * request = [NSURLRequest requestWithURL:url];
                                                 NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
                                                 [mutableRequest addValue:[UserSignData share].user.token forHTTPHeaderField:@"Authorization"];
                                                 request = [mutableRequest copy];
                                                 OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
                                                 NSURLSession * session = [NSURLSession sharedSession];
                                                 // 发送请求
                                                 NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                                                                   {
                                                                                       if (error)
                                                                                       {
                                                                                           [tcs setError:error];
                                                                                           return;
                                                                                       }
                                                                                       [tcs setResult:data];
                                                                                   }];
                                                 [sessionTask resume];
                                                 // 需要阻塞等待请求返回
                                                 [tcs.task waitUntilFinished];
                                                 // 解析结果
                                                 if (tcs.task.error)
                                                 {
                                                     return nil;
                                                 } else
                                                 {
                                                     // 返回数据是json格式，需要解析得到token的各个字段
                                                     NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                                                             options:kNilOptions
                                                                                                               error:nil];
                                                     NSDictionary * dic = [[object objectForKey:@"data"] objectForKey:@"Credentials"];
                                                     OSSFederationToken * token = [OSSFederationToken new];
                                                     token.tAccessKey = [dic objectForKey:@"AccessKeyId"];
                                                     token.tSecretKey = [dic objectForKey:@"AccessKeySecret"];
                                                     token.tToken = [dic objectForKey:@"SecurityToken"];
                                                     token.expirationTimeInGMTFormat = [dic objectForKey:@"Expiration"];
                                                     NSLog(@"get token: %@", token);
                                                     return token;
                                                 }
                                             }];
    
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential2];
    
    // 上传后通知回调
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    OSSPutObjectRequest * request = [OSSPutObjectRequest new];
    request.bucketName = @"inwecrypto-china";
    request.objectKey = [NSString stringWithFormat:@"ios_header_%@.jpeg",timeString];
    request.uploadingData = UIImageJPEGRepresentation(photos.firstObject, 0.5); // 直接上传NSData
    
    request.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * task = [client putObject:request];
    [task continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            OSSLogError(@"%@", task.error);
        } else {
            OSSPutObjectResult * result = task.result;
            NSLog(@"Result - requestId: %@, headerFields: %@, servercallback: %@",
                  result.requestId,
                  result.httpResponseHeaderFields,
                  result.serverReturnJsonString);
            
            // sign public url
            NSString * publicURL = nil;
            OSSTask * task1 = [client presignPublicURLWithBucketName:request.bucketName
                                                       withObjectKey:[NSString stringWithFormat:@"ios_header_%@.jpeg",timeString]];
            
            if (!task1.error)
            {
                publicURL = task1.result;
                
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                //异步返回主线程，根据获取的数据，更新UI
                dispatch_async(mainQueue, ^
                               {
                                   weakSelf.photoView.hidden = NO;
                                   weakSelf.addPhotoBtn.hidden = YES;
                                   
                                   [weakSelf.photoImageView sdsetImageWithURL:publicURL placeholderImage:nil];
                                   
                                   weakSelf.selectedImageURL = publicURL;
                               });
            }
            else
            {
                NSLog(@"sign url error: %@", task.error);
            }
        }
        return nil;
    }];
}

#pragma mark ------- text field and text view ---------
- (void)textFieldTextChange:(UITextField *)textField {
    if (textField.text.length != 0 && self.bestTextView.text.length != 0 && self.selectedImageURL.length > 0) {
        self.shareBtn.enabled = YES;
    } else {
        self.shareBtn.enabled = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length != 0 && self.senderNameTextField.text.length != 0 && self.selectedImageURL.length > 0) {
        self.shareBtn.enabled = YES;
    } else {
        self.shareBtn.enabled = NO;
    }
}

#pragma mark ----- Setters And Getters ---------
- (void)setSelectedImageURL:(NSString *)selectedImageURL {
    _selectedImageURL = selectedImageURL;
    if (selectedImageURL.length > 0 && self.bestTextView.text.length > 0 && self.senderNameTextField.text.length > 0) {
        self.shareBtn.enabled = YES;
    } else {
        self.shareBtn.enabled = NO;
    }
}

#pragma mark ------- Data ---------
- (void)sendRedPacket:(NSString *)senderName best:(NSString *)best {
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             0), ^{
        NSString *urlStr = [NSString stringWithFormat:@"redbag/send/%@/%@", @(self.model.redPacketId), self.model.redbag_addr];
        
        if ([NSObject isNulllWithObject:self.selectedImageURL]) {
            _selectedImageURL = @"";
        }
        
        NSDictionary *params = @{
                                 @"share_type" : @"1", // 红包分享类型,1.图片,2.文字,3.url,4code
                                 @"share_attr" : _selectedImageURL, // 红包分享内容,图片链接,文章内容,url
                                 @"share_user" : senderName, // 红包分享用户
                                 @"share_msg" : best, // 红包分享消息
                                 };
        WEAKSELF
        [PPNetworkHelper POST:urlStr baseUrlType:3 parameters:params hudString:DBHGetStringWithKeyFromTable(@"Loading...", nil) success:^(id responseObject) {
            [weakSelf handleResponse:responseObject];
        } failure:^(NSString *error) {
            [LCProgressHUD showFailure:error];
        }];
    });
}

- (void)handleResponse:(id)responseObj {
    if ([NSObject isNulllWithObject:responseObj]) {
        return;
    }
    
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        _isSendRedBag = YES;
        self.backIndex = 2;
        
        YYRedPacketDetailModel *model = [YYRedPacketDetailModel mj_objectWithKeyValues:responseObj];
        self.model = model;
        
        [self pushToPreviewVC];
    }
}

#pragma mark ------- Push VC ---------
- (void)pushToPreviewVC {
    YYRedPacketPreviewViewController *previewVC = [[YYRedPacketPreviewViewController alloc] init];
    previewVC.detailModel = self.model;
    previewVC.from = PreViewVCFromSendRedPacket;
    [self.navigationController pushViewController:previewVC animated:YES];
}

#pragma mark ----- RespondsToSelector ---------
- (IBAction)respondsToShareBtn:(UIButton *)sender {
    if (_isSendRedBag) {
        [self pushToPreviewVC];
        return;
    }
    NSString *bestStr = self.bestTextView.text;
    NSString *senderName = self.senderNameTextField.text;
    
    if ([NSObject isNulllWithObject:bestStr]) {
        bestStr = @"";
    }
    
    if ([NSObject isNulllWithObject:senderName]) {
        senderName = @"";
    }
    
    [self sendRedPacket:senderName best:bestStr];
}

- (IBAction)respondsToAddPhotoBtn:(UIButton *)sender {
    TZImagePickerController *imagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)respondsToDeletePhotoBtn:(UIButton *)sender {
    self.photoView.hidden = YES;
    self.addPhotoBtn.hidden = NO;
    
    self.selectedImageURL = nil;
}
@end
