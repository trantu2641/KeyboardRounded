#import <UIKit/UIKit.h>
#import <objc/message.h>

@interface UIKBRenderer : NSObject
- (void)renderBackgroundTraits:(id)traits allowCaching:(BOOL)allowCaching;
@end

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) CGFloat roundRectRadius;
@end

static CGFloat KRKeyRadius(void) {
    // Tuned for the large, softly-rounded key shape in the reference image.
    // Safe range for iOS 16 keyboard geometry.
    return 12.0;
}

%hook UIKBRenderer

- (void)renderBackgroundTraits:(id)traits allowCaching:(BOOL)allowCaching {
    id geometry = nil;
    if ([traits respondsToSelector:@selector(geometry)]) {
        geometry = ((id (*)(id, SEL))objc_msgSend)(traits, @selector(geometry));
    }

    SEL getter = @selector(roundRectRadius);
    SEL setter = @selector(setRoundRectRadius:);
    BOOL canRound = geometry &&
        [geometry respondsToSelector:getter] &&
        [geometry respondsToSelector:setter];

    CGFloat oldRadius = 0.0;
    if (canRound) {
        oldRadius = ((CGFloat (*)(id, SEL))objc_msgSend)(geometry, getter);
        ((void (*)(id, SEL, CGFloat))objc_msgSend)(geometry, setter, KRKeyRadius());
    }

    @try {
        %orig(traits, allowCaching);
    } @finally {
        if (canRound) {
            ((void (*)(id, SEL, CGFloat))objc_msgSend)(geometry, setter, oldRadius);
        }
    }
}

%end
