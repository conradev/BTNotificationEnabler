#include <substrate.h>

@interface BBSectionInfo : NSObject
@property(copy, nonatomic) NSString *sectionID;
@end

@interface BBBulletin : NSObject
@property(copy, nonatomic) NSString *sectionID;
@end

%hook BulletinHandler

- (void)observer:(id)observer addBulletin:(BBBulletin *)bulletin forFeed:(NSUInteger)feed {
    NSMutableArray *interestingSections = MSHookIvar<NSMutableArray *>(self, "fInterestingSections");
    [interestingSections addObject:bulletin.sectionID];

    %orig();

    [interestingSections removeObject:bulletin.sectionID];
}

- (void)observer:(id)observer updateSectionInfo:(BBSectionInfo *)sectionInfo {
    NSMutableArray *interestingSections = MSHookIvar<NSMutableArray *>(self, "fInterestingSections");
    [interestingSections addObject:sectionInfo.sectionID];

    %orig();

    [interestingSections removeObject:sectionInfo.sectionID];    
}


%end
