//
//  PEETokenProgressHud.h
//  EToken
//
//  Created by Relly on 2018/4/11.
//  Copyright © 2018年 Relly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEETokenProgressHud : UIView

//默认情况下，黑色区域在父视图的中心，但可以通过设置这两个属性，设置黑色区域偏离父视图中心的x、y距离。默认这两个值都是0
@property (nonatomic, assign) CGFloat yOffset;
@property (nonatomic, assign) CGFloat xOffset;
//1.创建添加标签、菊花等元素
+ (PEETokenProgressHud *) CHProgressViewHUDWithTitle:(NSString *)titleString toView:(UIView *)view;
//2.显示黑色区域
- (void) show;
//3.隐藏释放。隐藏后该对象既释放，不能再使用
- (void) hide;


@end
