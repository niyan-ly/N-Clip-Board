//
//  Constants.m
//  N Clip Board
//
//  Created by branson on 2019/11/15.
//  Copyright © 2019 branson. All rights reserved.
//

#import "Constants.h"

static NSString *BundleName = @"poor-branson.N-Clip-Board";

@implementation _UserDefaults

- (NSString *)ActivationHotKeyDict { return @"ActivationHotKeyDict"; }
- (NSString *)LaunchOnStartUp { return @"LaunchOnStartUp"; }
- (NSString *)KeepClipBoardItemUntil { return @"KeepClipBoardItemUntil"; }
- (NSString *)ShowCleanUpMenuItem { return @"ShowCleanUpMenuItem"; }
- (NSString *)PollingInterval { return @"PollingInterval"; }
- (NSString *)ShowPollingIntervalLabel { return @"ShowPollingIntervalLabel"; }
- (NSString *)ExcludedAppDict { return @"ExcludedAppDict"; }

@end

@implementation Constants
+ (NSString *)MainBundleName {
    return BundleName;
}
+ (NSString *)LauncherBundleName {
    return [NSString stringWithFormat: @"Launcher.%@", BundleName];
}
+ (NSDictionary<NSString *,NSNumber *> *)defaultActivationHotKey {
    return @{@"modifier": @1179648, @"keyCode": @9};
}
+ (NSArray<NSPasteboardType> *)supportedPasteboardType {
    return @[NSPasteboardTypeString, NSPasteboardTypePNG, NSPasteboardTypeColor];
}
+ (NSString *)stringTypeRawValue {
    return NSPasteboardTypeString;
}
+ (_UserDefaults *)Userdefaults { return [[_UserDefaults alloc]init]; }
+ (NSArray<NSSortDescriptor *> *)genSortDescriptor {
    return [self genSortDescriptor:false];
}
+ (NSArray<NSSortDescriptor *> *)genSortDescriptor: (BOOL) descending {
    return @[
        [[NSSortDescriptor alloc]initWithKey:@"createdAt" ascending:true comparator:^NSComparisonResult(id  _Nonnull rawLHS, id  _Nonnull rawRHS) {
            NSDate *lhs = ((NSDate *)rawLHS);
            NSDate *rhs = ((NSDate *)rawRHS);
            if (descending) {
                return [lhs compare:rhs];
            }
            return [rhs compare:lhs];
        }]
    ];
}
@end
