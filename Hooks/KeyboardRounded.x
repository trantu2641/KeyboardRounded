#import <UIKit/UIKit.h>

#pragma mark - Settings

// Radius mong muốn cho tất cả key
static CGFloat KRKeyRadius(void) {
    return 12.0;
}

// Radius của nền ngoài keyboard
static CGFloat KRKeyboardRadius(void) {
    return 28.0;
}

#pragma mark - Keyboard Render Factories

@interface UIKBRenderFactory10Key_Round : NSObject
- (double)keyCornerRadius;
@end

@interface UIKBRenderFactory_Monolith : NSObject
- (double)keyRoundRectRadius;
@end

/*
 * Đây là phần quan trọng nhất.
 *
 * WERTY / ASDF... / ZXCV... được tạo bởi keyboard
 * render factory. Override keyCornerRadius để đưa
 * radius về cùng một giá trị với Q/P/A/L.
 */

%hook UIKBRenderFactory10Key_Round

- (double)keyCornerRadius {
    return KRKeyRadius();
}

%end


/*
 * Một số keyplane/layout khác sử dụng
 * keyRoundRectRadius thay vì keyCornerRadius.
 */

%hook UIKBRenderFactory_Monolith

- (double)keyRoundRectRadius {
    return KRKeyRadius();
}

%end


#pragma mark - Keyboard Background

@interface UIKBBackdropView : UIView
@end

@interface UIKBVisualEffectView : UIView
@end

static void KRApplyKeyboardBackgroundRadius(UIView *view) {

    if (!view)
        return;

    CALayer *layer = view.layer;

    if (!layer)
        return;

    layer.cornerRadius = KRKeyboardRadius();
    layer.masksToBounds = YES;
}

#pragma mark - Backdrop

%hook UIKBBackdropView

- (void)layoutSubviews {

    %orig;

    KRApplyKeyboardBackgroundRadius(self);
}

%end

#pragma mark - Visual Effect

%hook UIKBVisualEffectView

- (void)layoutSubviews {

    %orig;

    KRApplyKeyboardBackgroundRadius(self);
}

%end
