//
//  PreView.m
//  HotalSystem
//
//  Created by mac-mini on 2016/12/16.
//  Copyright © 2016年 Podul. All rights reserved.
//

#import "PreView.h"

@implementation PreView
- (instancetype)initWithFrame:(CGRect)frame andNavItem:(UINavigationItem *)navItem{
    if (self = [super initWithFrame:frame]) {
        [navItem setRightBarButtonItem:self.addBarItem];
    }
    return self;
}

- (UIBarButtonItem *)addBarItem{
    if (_addBarItem == nil) {
        _addBarItem = [[UIBarButtonItem alloc]init];
        [_addBarItem setTitle:@"添加"];
    }
    return _addBarItem;
}

- (UILabel *)noInfoLabel{
    if (_noInfoLabel == nil) {
        _noInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        _noInfoLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:96.0/255.0 alpha:1.0];
        [_noInfoLabel setCenter:self.center];
        [_noInfoLabel setTextAlignment:NSTextAlignmentCenter];
        [_noInfoLabel setHidden:YES];
        [self addSubview:_noInfoLabel];
    }
    return _noInfoLabel;
}

- (void)createPreView:(id)object{
    [self.addBarItem setTarget:object];
    [self.addBarItem setAction:@selector(addPre:)];
}
@end
