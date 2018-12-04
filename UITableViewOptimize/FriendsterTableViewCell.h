//
//  FriendsterTableViewCell.h
//  UITableViewOptimize
//
//  Created by 索晓晓 on 2017/11/12.
//  Copyright © 2017年 SXiao.RR. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsterModel;

@interface FriendsterTableViewCell : UITableViewCell

@property (nonatomic ,strong)FriendsterModel *model;

//不设置照片
@property (nonatomic ,strong)FriendsterModel *noImageModel;

@end
