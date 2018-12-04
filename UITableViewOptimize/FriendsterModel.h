//
//  FriendsterModel.h
//  UITableViewOptimize
//
//  Created by 索晓晓 on 2017/11/12.
//  Copyright © 2017年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    FriendsterCellTypeNone = -1,//错误码  不存在
    FriendsterCellTypeAll  = 0 ,//default
    FriendsterCellTypeImage,
    FriendsterCellContent,
} FriendsterCellType;


@interface FriendsterModel : NSObject

@property (nonatomic ,strong)NSString *icon_url;
@property (nonatomic , assign)CGRect iconF;
@property (nonatomic ,strong)UIImage *iconImage;

@property (nonatomic ,strong)NSString *content;
@property (nonatomic , assign)CGRect contentF;

@property (nonatomic ,strong)NSString *name;
@property (nonatomic , assign)CGRect nameF;

@property (nonatomic ,strong)NSString *img_url;
@property (nonatomic , assign)CGRect imgF;

@property (nonatomic , assign)CGFloat cellHeight;






@property (nonatomic , assign)FriendsterCellType cellType;
@property (nonatomic , assign)BOOL isAnimation;

+ (instancetype)friendsterWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
