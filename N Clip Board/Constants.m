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

@implementation NThemeConfig

@synthesize complementaryColor = _complementaryColor;
@synthesize name = _name;
@synthesize primaryColor = _primaryColor;
@synthesize background = _background;

- (id)init:(NSString *)name primaryColor:(NSColor *)primaryColor background:(NSArray<NSColor *> *)background complementaryColor:(NSColor *)complementaryColor {
    _name = name;
    _primaryColor = primaryColor;
    _background = background;
    _complementaryColor = complementaryColor;
    
    return self;
}

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
+ (NThemeConfig *)themeGolden {
    NSArray<NSColor*> *background = @[[NSColor colorWithCalibratedRed:0.260 green:0.270 blue:0.314 alpha:1], [NSColor colorWithCalibratedRed:0.2109375 green:0.21875 blue:0.2421875 alpha:1]];
    NSColor* golden = [NSColor colorWithCalibratedRed:0.984375 green:0.9765625 blue:0.53515625 alpha:1];
    NSColor* complementaryColor = [NSColor colorWithCalibratedRed:0.26953125 green:0.26953125 blue:0.26953125 alpha:1];
    
    return [[NThemeConfig alloc]init:@"golden" primaryColor:golden background:background complementaryColor:complementaryColor];
}
//+ (NSArray<NThemeConfig *> *)themeList {
//    // golden
//
//    return @[
//        [[NThemeConfig alloc]init:@"golden" primaryColor:golden background:goldenBg]
//    ];
//}
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
