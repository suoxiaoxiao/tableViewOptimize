//
//  FriendsterTableViewCell.m
//  UITableViewOptimize
//
//  Created by 索晓晓 on 2017/11/12.
//  Copyright © 2017年 SXiao.RR. All rights reserved.
//

#import "FriendsterTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "FriendsterModel.h"

@interface FriendsterTableViewCell()

@property (nonatomic ,strong)UIImageView *icon;
@property (nonatomic ,strong)UIImageView *content_image;
@property (nonatomic ,strong)UILabel *content_label;
@property (nonatomic ,strong)UILabel *name_label;

@end

@implementation FriendsterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.icon = [UIImageView new];
        self.content_image = [UIImageView new];
        self.content_image.backgroundColor = [UIColor colorWithRed:105 green:105 blue:105 alpha:1.0];
        self.name_label = [UILabel new];
        self.name_label.textColor = [UIColor blueColor];
        self.name_label.numberOfLines = 0;
        self.name_label.font = [UIFont systemFontOfSize:14];
        self.content_label = [UILabel new];
        self.content_label.numberOfLines = 0;
        self.content_label.font = [UIFont systemFontOfSize:14];
        self.content_label.textColor = [UIColor blueColor];
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.content_label];
        [self.contentView addSubview:self.name_label];
        [self.contentView addSubview:self.content_image];
    }
    return self;
}

- (void)setNoImageModel:(FriendsterModel *)noImageModel
{
    _noImageModel = noImageModel;
    _model = noImageModel;
    
    [self.icon setImage:nil];
    [self.content_image setImage:nil];
    
    if (noImageModel.iconImage) {
        [self.icon setImage:noImageModel.iconImage];
    }else
        [self.icon setImage:[UIImage imageNamed:@"image"]];
    
    self.name_label.text = noImageModel.name;
    
    switch (noImageModel.cellType) {
        case FriendsterCellTypeImage:
        {
            self.content_label.hidden = YES;
            self.content_image.hidden = NO;
            
            [self.content_image setImage:nil];
        }
            break;
        case FriendsterCellContent:
        {
            self.content_image.hidden = YES;
            self.content_label.hidden = NO;
            self.content_label.text = noImageModel.content;
        }
            break;
        case FriendsterCellTypeAll:
        {
            self.content_label.hidden = NO;
            self.content_image.hidden = NO;
            self.content_label.text = noImageModel.content;
            [self.content_image setImage:nil];
        }
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setModel:(FriendsterModel *)model
{
    _model = model;
    
    [self.icon setImage:[UIImage new]];
    [self.content_image setImage:[UIImage new]];
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon_url] placeholderImage:[UIImage new] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       
        _model.iconImage = image;
        
    }];
    
    self.name_label.text = model.name;
    
    switch (model.cellType) {
        case FriendsterCellTypeImage:
        {
            self.content_label.hidden = YES;
            self.content_image.hidden = NO;
            
            [self.content_image sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage new] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                if (_model.isAnimation) {
                    [UIView beginAnimations:@"FadeIn" context:nil];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
                    [UIView setAnimationDuration:.5];
                    self.content_image.alpha = 0.2;
                    self.content_image.image = image;
                    self.content_image.alpha = 1;
                    [UIView commitAnimations];
                }
                
            }];
        }
            break;
        case FriendsterCellContent:
        {
            self.content_image.hidden = YES;
            self.content_label.hidden = NO;
            self.content_label.text = model.content;
        }
            break;
        case FriendsterCellTypeAll:
        {
            self.content_label.hidden = NO;
            self.content_image.hidden = NO;
            self.content_label.text = model.content;
            [self.content_image sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage new] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (_model.isAnimation) {
                    [UIView beginAnimations:@"FadeIn" context:nil];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
                    [UIView setAnimationDuration:.5];
                    self.content_image.alpha = 0.2;
                    self.content_image.image = image;
                    self.content_image.alpha = 1;
                    [UIView commitAnimations];
                }
            }];
        }
            break;
        default:
            break;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    self.model.isAnimation = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.icon.frame = self.model.iconF;
    self.name_label.frame = self.model.nameF;
    switch (self.model.cellType) {
        case FriendsterCellContent:
        {
            self.content_label.frame = self.model.contentF;
        }
            break;
        case FriendsterCellTypeImage:
        {
            self.content_image.frame = self.model.imgF;
        }
            break;
        case FriendsterCellTypeAll:
        {
            
            self.content_label.frame = self.model.contentF;
            self.content_image.frame = self.model.imgF;
        }
            break;
            
        default:
            break;
    }
    
}




@end
