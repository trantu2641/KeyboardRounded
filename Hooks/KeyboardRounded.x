#import <UIKit/UIKit.h>
#import <objc/message.h>

#pragma mark - Settings

static CGFloat KRKeyRadius(void) {
    return 12.0;
}

#pragma mark - Keyboard Render Factory

@interface UIKBRenderFactory10Key_Round : NSObject
- (BOOL)shouldUseRoundCornerForKey:(id)key;
- (int)roundCornersForKey:(id)key onKeyplane:(id)keyplane;
- (void)_customizeGeometry:(id)geometry
                    forKey:(id)key
                  contents:(id)contents
               onKeyplane:(id)keyplane;
@end

%hook UIKBRenderFactory10Key_Round

- (BOOL)shouldUseRoundCornerForKey:(id)key {
    return YES;
}

- (int)roundCornersForKey:(id)key
              onKeyplane:(id)keyplane {
    return 0xF;
}

- (void)_customizeGeometry:(id)geometry
                    forKey:(id)key
                  contents:(id)contents
               onKeyplane:(id)keyplane {

    %orig(geometry, key, contents, keyplane);

    if (geometry &&
        [geometry respondsToSelector:@selector(setRoundRectRadius:)]) {

        ((void (*)(id, SEL, CGFloat))objc_msgSend)(
            geometry,
            @selector(setRoundRectRadius:),
            KRKeyRadius()
        );
    }
}

%end

#pragma mark - Monolith Factory

@interface UIKBRenderFactory_Monolith : NSObject
- (void)configureCornersOnGeometry:(id)geometry
                            forKey:(id)key;
- (double)keyRoundRectRadius;
@end

%hook UIKBRenderFactory_Monolith

- (double)keyRoundRectRadius {
    return KRKeyRadius();
}

- (void)configureCornersOnGeometry:(id)geometry
                            forKey:(id)key {

    %orig(geometry, key);

    if (geometry &&
        [geometry respondsToSelector:@selector(setRoundRectRadius:)]) {

        ((void (*)(id, SEL, CGFloat))objc_msgSend)(
            geometry,
            @selector(setRoundRectRadius:),
            KRKeyRadius()
        );
    }
}

%end
