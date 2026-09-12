#import <UIKit/UIKit.h>
#import <objc/message.h>

static CGFloat KRKeyRadius(void) {
    return 8.0;
}

@interface UIKBRenderGeometry : NSObject
@property(nonatomic) double roundRectRadius;
@property(nonatomic) int roundRectCorners;
@end

@interface UIKBRenderTraits : NSObject
- (id)geometry;
@end

@interface UIKBRenderer : NSObject
- (void)renderBackgroundTraits:(id)traits allowCaching:(BOOL)allowCaching;
@end

%hook UIKBRenderer

- (void)renderBackgroundTraits:(id)traits
                  allowCaching:(BOOL)allowCaching
{
    id geometry = nil;

    if (traits &&
        [traits respondsToSelector:@selector(geometry)]) {
        geometry = ((id (*)(id, SEL))objc_msgSend)(
            traits,
            @selector(geometry)
        );
    }

    if (geometry) {
        if ([geometry respondsToSelector:@selector(setRoundRectRadius:)]) {
            ((void (*)(id, SEL, double))objc_msgSend)(
                geometry,
                @selector(setRoundRectRadius:),
                (double)KRKeyRadius()
            );
        }

        if ([geometry respondsToSelector:@selector(setRoundRectCorners:)]) {
            ((void (*)(id, SEL, int))objc_msgSend)(
                geometry,
                @selector(setRoundRectCorners:),
                0xF
            );
        }
    }

    %orig(traits, allowCaching);
}

%end
