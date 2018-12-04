//
//  NSString+LabelWH.h
//  CategorySet
//
//  Created by 索晓晓 on 16/3/16.
//  Copyright © 2016年 索晓晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Tool)

- (BOOL)sh_containsString:(NSString *)str;
/**MD5*/
- (NSString *)MD5_CachedFileName;
@end


@interface NSString (LabelWH)


/**
 * 获取单行文本宽度 (bold)
 */
- (CGFloat)getBoldCurrentTextSingleWidthFont:(CGFloat)font;
/**
 * 获取单行文本高度 (bold)
 */
- (CGFloat)getBoldCurrentTextSingleHeightFont:(CGFloat)font;
/**
 * 获取文本宽高 (bold)
 */
- (CGRect)getBoldCurrentTextRectWithFont:(CGFloat)font WithWidth:(CGFloat)width WithHeight:(CGFloat)height;
/**
 * 获取单行文字高度 (system)
 */
- (CGFloat)getSystemSingleHeightWithFont:(CGFloat)font;
/**
 * 获取单行文字宽度 (system)
 */
- (CGFloat)getSystemSingleWidthWithFont:(CGFloat)font;
/**
 * 获取文本宽高 (system)
 */
- (CGRect)getSystemTextWidthAndHeightWithSystemFont:(CGFloat)fontSize WithWidth:(CGFloat)width height:(CGFloat)height;
/**
 * 获取单行文字高度 (custom)自定义字体
 */
- (CGFloat)getCustomSingleHeightWithFont:(UIFont *)font;
/**
 * 获取单行文字宽度 (custom)自定义字体
 */
- (CGFloat)getCustomSingleWidthWithFont:(UIFont *)font;
/**
 * 获取文本宽高 (custom)自定义字体
 */
- (CGRect)getCustomTextWidthAndHeightWithSystemFont:(UIFont *)font WithWidth:(CGFloat)width height:(CGFloat)height;


@end
