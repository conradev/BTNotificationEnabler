#include <substrate.h>

@interface BBSectionInfo : NSObject
@property(copy, nonatomic) NSString *sectionID;
@end

@interface BulletinBoardAppDetailController : UIViewController
- (BBSectionInfo *)effectiveSectionInfo;
@end

@interface PSSpecifier : NSObject
+ (instancetype)preferenceSpecifierNamed:(NSString *)name target:(id)target set:(SEL)setter get:(SEL)getter detail:(Class)detailControllerClass cell:(int)cellType edit:(Class)editPaneClass;
- (void)setProperty:(id)value forKey:(id<NSCopying>)key;
@end

@interface PSTableCell : UITableViewCell
+ (int)cellTypeFromString:(NSString *)cellType;
@end

@interface NSArray (PreferencesAdditions)
- (PSSpecifier *)specifierForID:(NSString *)identifier;
@end

extern NSString * const PSDefaultsKey;
extern NSString * const PSKeyNameKey;
extern NSString * const PSDefaultValueKey;
extern NSString * const PSValueChangedNotificationKey;

static NSString * const kViewInLockscreenSpecifierID = @"VIEW_IN_LOCK_SCREEN_ID";

%hook BulletinBoardAppDetailController

- (NSMutableArray *)specifiers {
    // Exit if the specifiers are already initialized
    if (MSHookIvar<NSMutableArray *>(self, "_specifiers") != nil) return %orig();
    
    NSMutableArray *specifiers = %orig();
    
    // Exit if the list does not have a "View in Lockscreen" toggle
    NSUInteger insertionIndex = [specifiers indexOfObject:[specifiers specifierForID:kViewInLockscreenSpecifierID]];
    if (insertionIndex == NSNotFound) return specifiers;
    insertionIndex++;

    BBSectionInfo *sectionInfo = [self effectiveSectionInfo];
    NSString *key = [NSString stringWithFormat:@"%@%@", BT_ENABLED_PREFIX, sectionInfo.sectionID];
    
    PSSpecifier *bluetoothSpecifier = [PSSpecifier preferenceSpecifierNamed:@"View over Bluetooth" target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:[PSTableCell cellTypeFromString:@"PSSwitchCell"] edit:nil];
    [bluetoothSpecifier setProperty:BT_DEFAULTS_VALUE forKey:PSDefaultsKey];
    [bluetoothSpecifier setProperty:key forKey:PSKeyNameKey];
    [bluetoothSpecifier setProperty:@YES forKey:PSDefaultValueKey];
    [bluetoothSpecifier setProperty:BT_CHANGE_NOTIFICATION forKey:PSValueChangedNotificationKey];
        
    [specifiers insertObject:bluetoothSpecifier atIndex:insertionIndex];

    return specifiers;
}

%end