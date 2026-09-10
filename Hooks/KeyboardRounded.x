#import <UIKit/UIKit.h>

static CGFloat KRKeyRadius(void) {
    return 12.0;
}

@interface UIKBKeyView : UIView
@end

%hook UIKBKeyView

- (void)layoutSubviews {
    %orig;

    CALayer *layer = self.layer;

    if (layer) {
        layer.cornerRadius = KRKeyRadius();
        layer.masksToBounds = YES;
    }
}

%end
