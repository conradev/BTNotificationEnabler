#include <substrate.h>

@interface BBSectionInfo : NSObject
@property(copy, nonatomic) NSString *sectionID;
@end

@interface BBBulletin : NSObject
@property(copy, nonatomic) NSString *sectionID;
@end

static NSArray *disabledSections = nil;

%hook BulletinHandler

- (void)observer:(id)observer addBulletin:(BBBulletin *)bulletin forFeed:(NSUInteger)feed {
    NSMutableArray *interestingSections = MSHookIvar<NSMutableArray *>(self, "fInterestingSections");
    [interestingSections removeAllObjects];

    NSString *sectionID = bulletin.sectionID;
    if (![disabledSections containsObject:sectionID]) {
        [interestingSections addObject:sectionID];
    }

    %orig();

    [interestingSections removeObject:sectionID];
}

%end

void BTValueChangedNotificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSString *preferencesPath = [NSString stringWithFormat:@"/private/var/mobile/Library/Preferences/%@.plist", BT_DEFAULTS_VALUE];
    NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:preferencesPath];

    NSString *prefix = BT_ENABLED_PREFIX;
    NSSet *disabledKeys = [preferences keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop) {
        return (BOOL)([key hasPrefix:prefix] && [obj isEqualToNumber:@NO]);
    }];

    NSMutableArray *mutableDisabledSections = [NSMutableArray arrayWithCapacity:disabledKeys.count];
    [disabledKeys enumerateObjectsUsingBlock:^(NSString *key, BOOL *stop) {
        [mutableDisabledSections addObject:[key substringFromIndex:prefix.length]];
    }];

    [disabledSections release];
    disabledSections = [mutableDisabledSections copy];
}

%ctor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    %init();

    BTValueChangedNotificationCallback(NULL, nil, NULL, nil, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)&BTValueChangedNotificationCallback, (CFStringRef)BT_CHANGE_NOTIFICATION, NULL, 0);

    [pool release];
}