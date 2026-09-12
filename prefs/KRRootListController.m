#import "KRRootListController.h"

@implementation KRRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root"
                                                 target:self];
    }

    return _specifiers;
}

@end
