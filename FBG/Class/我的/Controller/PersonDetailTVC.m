//
//  PersonDetailTVC.m
//  FBG
//
//  Created by 贾仕海 on 2017/8/3.
//  Copyright © 2017年 ButtonRoot. All rights reserved.
//

#import "PersonDetailTVC.h"
#import "LXFPhotoHelper.h"
#import "ModifyNicknameVC.h"
#import "GenderSettingVC.h"
#import <AliyunOSSiOS/OSSService.h>

@interface PersonDetailTVC ()

@property (weak, nonatomic) IBOutlet UILabel *headerLB;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLB;
@property (weak, nonatomic) IBOutlet UILabel *genderLB;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameInfoLB;
@property (weak, nonatomic) IBOutlet UILabel *genderInfoLB;
@end

@implementation PersonDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人设置";
    self.view.backgroundColor = [UIColor backgroudColor];
    
    [self loadUserData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadUserData];
}

- (void)loadUserData
{
    [self.headImageView sdsetImageWithHeaderimg:[UserSignData share].user.img];
    self.nickNameInfoLB.text = [UserSignData share].user.nickname;
    self.genderInfoLB.text = [[UserSignData share].user.sex intValue] == 1 ? @"男" : @"女";
}

- (void)getSourceWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    LXFPhotoConfig *config = [[LXFPhotoConfig alloc] init];
    config.navBarTintColor = [UIColor whiteColor];
    config.navBarBgColor = [UIColor colorWithHexString:@"2f2f2f"];
    config.navBarTitleColor = [UIColor whiteColor];
    config.allowsEditing = YES;
    
    [[LXFPhotoHelper creatWithSourceType:sourceType config:config] getSourceWithSelectImageBlock:^(id data)
    {
        if ([data isKindOfClass:[UIImage class]])
        {
            //获取到图片
            NSString *endpoint = @"http://oss-cn-shenzhen.aliyuncs.com";
            
            id<OSSCredentialProvider> credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken *
            {
                // 构造请求访问您的业务server
                NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sts",APP_APIEHEAD]];
                NSURLRequest * request = [NSURLRequest requestWithURL:url];
                NSMutableURLRequest *mutableRequest = [request mutableCopy];    //拷贝request
                [mutableRequest addValue:[UserSignData share].user.token forHTTPHeaderField:@"ct"];
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
            request.bucketName = @"cryptobox";
            request.objectKey = [NSString stringWithFormat:@"ios_header_%@",timeString];
            request.uploadingData = UIImageJPEGRepresentation(data, 0.5); // 直接上传NSData
            
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
                    OSSTask * task1 = [client presignPublicURLWithBucketName:@"cryptobox"
                                                               withObjectKey:[NSString stringWithFormat:@"ios_header_%@",timeString]];
                    
                    if (!task1.error)
                    {
                        publicURL = task1.result;
                        
                        dispatch_queue_t mainQueue = dispatch_get_main_queue();
                        //异步返回主线程，根据获取的数据，更新UI
                        dispatch_async(mainQueue, ^
                                       {
                                           [self upUserWithImg:publicURL nickName:[UserSignData share].user.nickname sex:[UserSignData share].user.sex];
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
        else
        {
            [LCProgressHUD showFailure:@"所选内容非图片对象"];
        }
    }];
}

- (void)upUserWithImg:(NSString *)img nickName:(NSString *)nickName sex:(NSString *)sex
{
    if (nickName.length > 12)
    {
        [LCProgressHUD showMessage:@"请输入2~12位非特殊字符的昵称"];
        return;
    }
    if (![NSString isNickName:nickName])
    {
        [LCProgressHUD showMessage:@"请输入2~12位非特殊字符的昵称"];
        return;
    }
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject:nickName forKey:@"nickname"];
    [dic setObject:img forKey:@"img"];
    
    [PPNetworkHelper POST:@"user" parameters:dic hudString:nil success:^(id responseObject)
     {
         //更新本地数据
         [UserSignData share].user.img = img;
         [UserSignData share].user.nickname = nickName;
         [UserSignData share].user.sex = sex;
         [[UserSignData share] storageData:[UserSignData share].user];
         
         //显示在页面上
         [self loadUserData];
     } failure:^(NSString *error)
     {
         [LCProgressHUD showFailure:error];
     }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark --UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec = indexPath.section;
    NSInteger row = indexPath.row;
    if (sec == 0 && row == 0)
    {
        //头像
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *openCameraAction = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
             [self getSourceWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        
        UIAlertAction *openAlbumAction = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self getSourceWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:openCameraAction];
        [alertController addAction:openAlbumAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (sec == 1 && row == 0)
    {
        //昵称
        ModifyNicknameVC * vc = [[ModifyNicknameVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (sec == 1 && row == 1)
    {
        //性别
        GenderSettingVC * vc = [[GenderSettingVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
