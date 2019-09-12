//
//  ExclusiveButton.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/15.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "ExclusiveButton.h"

@interface ExclusiveButton()    

@property (strong, nonatomic, readwrite) NSMutableArray<UIButton *> *buttons;
@property (strong, nonatomic, readwrite) UIButton *oldInvalidButton;
@property (strong, nonatomic, readwrite) UIButton *invalidButton;
@end

@implementation ExclusiveButton
@synthesize allButtons = _allButtons;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _useEnbleOfInvalid = YES;
    }
    
    return self;
}
- (instancetype)initWithUseEnbleInvalid:(BOOL)useEnble {
    self = [super init];
    
    if (self) {
        _useEnbleOfInvalid = useEnble;
    }
    
    return self;
}

- (void)appendButton:(UIButton *)button invalid:(BOOL)invalid {
    NSParameterAssert(button);
    
    if (!button) return;
    if (![button isKindOfClass:[UIButton class]]) return;
    
    if (invalid) {
        self.invalidButton = button;
    }
    
    [button addTarget:self action:@selector(clickTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:button];
}
- (void)setButtonInvalid:(UIButton *)button {
    
    if ([self.allButtons containsObject:button]) {
        [self clickTheButton:button];
    }
}

- (void)clickTheButton:(UIButton *)sender {
    
    self.invalidButton = sender;
}

- (void)setInvalidButton:(UIButton *)invalidButton {
    
    if ([_invalidButton isEqual:invalidButton]) return;

    self.oldInvalidButton = _invalidButton;

    @synchronized(self) {
        
        !self.invalidButtonWillChangeBlock ? : self.invalidButtonWillChangeBlock(invalidButton);
        
        if (self.useEnbleOfInvalid) {
            _invalidButton.enabled = YES;
            invalidButton.enabled = NO;
        } else {
            _invalidButton.userInteractionEnabled = YES;
            invalidButton.userInteractionEnabled = NO;
        }
        id tmp = _invalidButton;
        _invalidButton = invalidButton;
        
        !self.invalidButtonDidChangeBlock ? : self.invalidButtonDidChangeBlock(tmp);
    }
}
- (void)setAllButtons:(NSArray *)allButtons {
    
    [_buttons removeAllObjects];
    _oldInvalidButton = nil;
    _invalidButton = nil;
    for (UIButton *button in allButtons) {
        if ([button isKindOfClass:[UIButton class]]) {
            
            [self appendButton:button invalid: (!button.userInteractionEnabled | !button.enabled) ];
        }
    }
}
- (NSMutableArray *)buttons {
    
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}
- (NSArray *)allButtons {
    
    return self.buttons;
}

@end
