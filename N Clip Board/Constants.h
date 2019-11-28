//
//  Constants.h
//  N Clip Board
//
//  Created by branson on 2019/11/15.
//  Copyright © 2019 branson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SearchPanelViewType) {
    All = 0,
    ClipBoard,
    Snippet
};

@interface NThemeConfig : NSObject
{
    @private
    NSString *_name;
    NSColor *_primaryColor;
    NSColor *_complementaryColor;
    NSArray<NSColor *> *_background;
}

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSColor *primaryColor;
@property (readonly, nonatomic) NSArray<NSColor *> *background;
@property (readonly, nonatomic) NSColor *complementaryColor;
- (id)init: (NSString*) name primaryColor:(NSColor*) primaryColor background:(NSArray<NSColor *>*) background complementaryColor:(NSColor*) complementaryColor;
@end

@interface _UserDefaults : NSObject
@property (readonly)NSString *LaunchOnStartUp NS_SWIFT_NAME(LaunchOnStartUp);
@property (readonly)NSString *KeepClipBoardItemUntil NS_SWIFT_NAME(KeepClipBoardItemUntil);
@property (readonly)NSString *ShowCleanUpMenuItem NS_SWIFT_NAME(ShowCleanUpMenuItem);
@property (readonly)NSString *PollingInterval NS_SWIFT_NAME(PollingInterval);
@property (readonly)NSString *ShowPollingIntervalLabel NS_SWIFT_NAME(ShowPollingIntervalLabel);
@property (readonly)NSString *ExcludedAppDict NS_SWIFT_NAME(ExcludedAppDict);
@property (readonly)NSString *ActivationHotKeyDict NS_SWIFT_NAME(ActivationHotKeyDict);

@end

@interface Constants : NSObject
@property (class, readonly) NSString *MainBundleName NS_SWIFT_NAME(MainBundleName);
@property (class, readonly) NSString *LauncherBundleName NS_SWIFT_NAME(LauncherBundleName);
@property (class, readonly) NSDictionary<NSString *, NSNumber *> *defaultActivationHotKey;
@property (class, readonly) NSArray<NSPasteboardType> *supportedPasteboardType;
@property (class, readonly) NSString *stringTypeRawValue;
@property (class, readonly) NThemeConfig *themeGolden;

@property (class, readonly) _UserDefaults *Userdefaults NS_SWIFT_NAME(Userdefaults);

+ (NSArray<NSSortDescriptor *>*)genSortDescriptor;
+ (NSArray<NSSortDescriptor *>*)genSortDescriptor: (BOOL) descending;
@end

NS_ASSUME_NONNULL_END
