#include <substrate.h>

@interface BBSectionInfo : NSObject
@property(copy, nonatomic) NSString *sectionID;
@end

@interface PSSpecifier : NSObject
+ (instancetype)preferenceSpecifierNamed:(NSString *)name target:(id)target set:(SEL)setter get:(SEL)getter detail:(Class)detailControllerClass cell:(int)cellType edit:(Class)editPaneClass;
- (id)propertyForKey:(id<NSCopying>)key;
- (void)setProperty:(id)value forKey:(id<NSCopying>)key;
@end

@interface PSTableCell : UITableViewCell
+ (int)cellTypeFromString:(NSString *)cellType;
- (void)setCellEnabled:(BOOL)enabled;
@end

@interface NSArray (PreferencesAdditions)
- (PSSpecifier *)specifierForID:(NSString *)identifier;
@end

@interface BulletinBoardAppDetailController : UIViewController
@property (retain, nonatomic, getter=__btnotificationenabler_bluetooth_specifier, setter=__btnotificationenabler_set_bluetooth_specifier:) PSSpecifier *bluetoothSpecifier;
- (BBSectionInfo *)effectiveSectionInfo;
- (PSSpecifier *)specifierForID:(NSString *)identifier;
- (id)getViewInLockScreen:(PSSpecifier *)specifier;
@end

extern NSString * const PSDefaultsKey;
extern NSString * const PSKeyNameKey;
extern NSString * const PSDefaultValueKey;
extern NSString * const PSValueChangedNotificationKey;
extern NSString * const PSTableCellKey;

static NSString * const kViewInLockscreenSpecifierID = @"VIEW_IN_LOCK_SCREEN_ID";

static char bluetoothSpecifierKey;

%hook BulletinBoardAppDetailController

%new(v@:@)
- (void)__btnotificationenabler_set_bluetooth_specifier:(id)object {
    objc_setAssociatedObject(self, &bluetoothSpecifierKey, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%new(@@:)
- (id)__btnotificationenabler_bluetooth_specifier {
    return objc_getAssociatedObject(self, &bluetoothSpecifierKey);
}

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

    self.bluetoothSpecifier = bluetoothSpecifier;

    return specifiers;
}

- (void)setViewInLockScreen:(id)value specifier:(PSSpecifier *)specifier {
    %orig();
    
    PSTableCell *cell = [self.bluetoothSpecifier propertyForKey:PSTableCellKey];
    [cell setCellEnabled:[value boolValue]];
}

- (UITableViewCell *)tableView:(UITableView *)view cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableCell *cell = (PSTableCell *)%orig();
    
    if ([cell isEqual:[self.bluetoothSpecifier propertyForKey:PSTableCellKey]]) {
        BOOL showsInLockScreen = [[self getViewInLockScreen:[self specifierForID:kViewInLockscreenSpecifierID]] boolValue];
        [cell setCellEnabled:showsInLockScreen];
    }
    
    return cell;
}


%end