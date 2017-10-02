//
//  UIImageView+SDSetImage.m
//  PandaTravel
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 lykj. All rights reserved.
//

#import "UIImageView+SDSetImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SDSetImage)

- (void)sdsetImageWithHeaderimg:(NSString *)img
{
    if ([img containsString:@"http"])
    {
        [self sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:Default_Person_Image];
    }
    else
    {
        [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,img]] placeholderImage:Default_Person_Image];
    }
}

- (void)sdsetImageWithURL:(NSString *)url placeholderImage:(UIImage *)placeholder
{
    if ([url containsString:@"http"])
    {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder];
    }
    else
    {
        [self sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEHEAD,url]] placeholderImage:placeholder];
    }
}

@end
