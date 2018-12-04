//
//  NSString+LabelWH.m
//  CategorySet
//
//  Created by 索晓晓 on 16/3/16.
//  Copyright © 2016年 索晓晓. All rights reserved.
//

#import "NSString+LabelWH.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Tool)

- (BOOL)sh_containsString:(NSString *)str
{
    NSAssert(str == nil || [str isKindOfClass:[NSString class]] || str.length == 0, @"传进来的值不是NSString");
    
    if (str == nil || ![str isKindOfClass:[NSString class]] || str.length == 0) {
        return NO;
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
        return [self containsString:str];
    }else{
        return [self rangeOfString:str].location != NSNotFound;
    }
}

- (NSString *)MD5_CachedFileName {
    const char *str = [self UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

@end


@implementation NSString (LabelWH)

- (CGFloat)getBoldCurrentTextSingleWidthFont:(CGFloat)font
{
    return [self getTextWidthAndHeightWithBoldFont:font withWidth:MAXFLOAT height:MAXFLOAT].size.width;
}

- (CGFloat)getBoldCurrentTextSingleHeightFont:(CGFloat)font
{
    return [self getTextWidthAndHeightWithBoldFont:font withWidth:MAXFLOAT height:MAXFLOAT].size.height;
}

- (CGRect)getBoldCurrentTextRectWithFont:(CGFloat)font WithWidth:(CGFloat)width WithHeight:(CGFloat)height
{
    return [self getTextWidthAndHeightWithBoldFont:font withWidth:width height:height];
}

- (CGFloat)getSystemSingleHeightWithFont:(CGFloat)font
{
    return [self getSystemTextWidthAndHeightWithSystemFont:font WithWidth:MAXFLOAT height:MAXFLOAT].size.height;
}
- (CGFloat)getSystemSingleWidthWithFont:(CGFloat)font
{
    return [self getSystemTextWidthAndHeightWithSystemFont:font WithWidth:MAXFLOAT height:MAXFLOAT].size.width;
}
- (CGFloat)getCustomSingleHeightWithFont:(UIFont *)font
{
    return [self getCustomTextWidthAndHeightWithSystemFont:font WithWidth:MAXFLOAT height:MAXFLOAT].size.height;
}
- (CGFloat)getCustomSingleWidthWithFont:(UIFont *)font
{
    return [self getCustomTextWidthAndHeightWithSystemFont:font WithWidth:MAXFLOAT height:MAXFLOAT].size.width;
}
- (CGRect)getCustomTextWidthAndHeightWithSystemFont:(UIFont *)font WithWidth:(CGFloat)width height:(CGFloat)height
{
    CGSize size = CGSizeMake(width, height);
    
    return [self handleCoreComputeFont:font Size:size];
}


- (CGRect)getSystemTextWidthAndHeightWithSystemFont:(CGFloat)fontSize WithWidth:(CGFloat)width height:(CGFloat)height
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    CGSize size = CGSizeMake(width, height);
    
     return [self handleCoreComputeFont:font Size:size];
}

- (CGRect)getTextWidthAndHeightWithBoldFont:(float)fontSize  withWidth:(float)width height:(float)height
{
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    
    CGSize size = CGSizeMake(width, height);
    
    return [self handleCoreComputeFont:font Size:size];
    
}

- (CGRect)handleCoreComputeFont:(UIFont *)font Size:(CGSize)size
{
    //适配
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
    {
        
        CGRect labelRect = [self boundingRectWithSize:size
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]
                                              context:nil];
        return labelRect;
    }
    
    else
    {
        NSAttributedString*attriStr=[[NSAttributedString alloc]initWithString:self attributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
        CGRect lableRect=[attriStr boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        return lableRect;
        
    }
    
    
    return CGRectZero;
}


@end
