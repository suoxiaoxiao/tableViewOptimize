//
//  FriendsterModel.m
//  UITableViewOptimize
//
//  Created by 索晓晓 on 2017/11/12.
//  Copyright © 2017年 SXiao.RR. All rights reserved.
//

#import "FriendsterModel.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageDownloader.h>
#import "NSString+LabelWH.h"

#define Dict_getValue(dict,key) dict[key]?:@""

@implementation FriendsterModel
+ (instancetype)friendsterWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self= [super init]) {
        self.isAnimation = YES;
        self.icon_url = Dict_getValue(dict, @"icon");
        self.name = Dict_getValue(dict,@"name");
        self.content = Dict_getValue(dict,@"content");
        self.img_url = Dict_getValue(dict,@"image");
        if (self.content.length) {
            self.cellType = FriendsterCellContent;
            if (self.img_url && self.img_url.length) {
                self.cellType = FriendsterCellTypeAll;
            }
        }else{
            if (self.img_url && self.img_url.length) {
                self.cellType = FriendsterCellTypeImage;
            }
        }
        
        if (self.cellType == FriendsterCellTypeNone) {
            self.cellHeight = 0;
        }else{
            
            CGFloat spaceunit = 15;
            CGFloat iconWH = 40;
            CGFloat SCREEN_WIDTH  = [UIScreen mainScreen].bounds.size.width;
//            CGFloat SCREEN_HEIGHT  = [UIScreen mainScreen].bounds.size.height;
            CGFloat contentW = SCREEN_WIDTH - 4 * spaceunit - iconWH;
            
            self.iconF = CGRectMake(spaceunit, spaceunit, iconWH, iconWH);
            self.nameF = CGRectMake(CGRectGetMaxX(self.iconF) + spaceunit, spaceunit,contentW , [self.name getSystemSingleHeightWithFont:14]);
            
            
            if (self.cellType == FriendsterCellContent ) {
                
                self.contentF = CGRectMake(CGRectGetMaxX(self.iconF) + spaceunit, CGRectGetMaxY(self.nameF) + spaceunit, contentW, [self.content getSystemTextWidthAndHeightWithSystemFont:14 WithWidth:contentW height:MAXFLOAT].size.height);
                self.cellHeight = CGRectGetMaxY(self.contentF) + spaceunit;
            }else if (self.cellType == FriendsterCellTypeImage) {
                self.imgF = CGRectMake(CGRectGetMaxX(self.iconF) + spaceunit,CGRectGetMaxY(self.nameF) + spaceunit , contentW, 200);
                 self.cellHeight = CGRectGetMaxY(self.imgF) + spaceunit;
            }else{
                 self.contentF = CGRectMake(CGRectGetMaxX(self.iconF) + spaceunit, CGRectGetMaxY(self.nameF) + spaceunit, contentW, [self.content getSystemTextWidthAndHeightWithSystemFont:14 WithWidth:contentW height:MAXFLOAT].size.height);
                self.imgF = CGRectMake(CGRectGetMaxX(self.iconF) + spaceunit,CGRectGetMaxY(self.contentF) + spaceunit , contentW, 200);
                 self.cellHeight = CGRectGetMaxY(self.imgF) + spaceunit;
            }
            
        }
    }
    return self;
}
@end
