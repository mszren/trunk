//
//  CommonFunctions.m
//  Dolphin
//
//  Created by wang fengquan on 3/16/11.
//  Copyright 2011 baina. All rights reserved.
//

#import "CommonFunctions.h"
#import "NSString+URLEncoding.h"
#import <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import "DeviceUtils.h"
#import "Debug.h"
#import "UIColor+Components.h"

#define UIACTIVITYINDICATORVIEW_TAG 100000000
#define TOAST_BOTTOM_MARGIN_PAD 150
#define TOAST_BOTTOM_MARGIN_PHONE 80
#define ERROR_DOMAIN @"CommonFunctions"
#define ERROR_CODE_MOVE_FILE_FAILED -101
#define MAX_GIF_IMAGE_AREA (100 * 80 * 60)

#define SECONDS_IN_DAY 86400

@implementation CommonFunctions

#pragma mark - Mail
+ (void)sendEmailTo:(NSString*)to withSubject:(NSString*)subject withBody:(NSString*)body
{
    NSString* mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
                                     [to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                     [subject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                     [body stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

#pragma mark -
#pragma mark File
+ (NSString*)getTempFilePath:(NSString*)name
{
    NSString* documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Temp"];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:name];

    return filePath;
}

+ (NSString*)getDocumentsFilePath:(NSString*)name //User can view this folder in iTunes
{
    NSString* documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:name];

    return filePath;
}

+ (NSString*)getLibraryFilePath:(NSString*)name //User cannot view this folder in iTunes
{
    NSString* documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSString* filePath = [documentsDirectory stringByAppendingPathComponent:name];

    return filePath;
}

+ (BOOL)fileExistsAtFullPath:(NSString*)name
{
    return [[NSFileManager defaultManager] fileExistsAtPath:name];
}

+ (BOOL)fileExistsAtDocumentsPath:(NSString*)name
{
    return [CommonFunctions fileExistsAtFullPath:[CommonFunctions getDocumentsFilePath:name]];
}

+ (BOOL)fileExistsAtLibraryPath:(NSString*)name
{
    return [CommonFunctions fileExistsAtFullPath:[CommonFunctions getLibraryFilePath:name]];
}

+ (void)createFolderAtDocumentsPathIfNotExist:(NSString*)folderName
{
    NSString* directoryPath = [CommonFunctions getDocumentsFilePath:folderName];
    BOOL isDirectory = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:&isDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)createFileAtDocumentsPath:(NSString*)fileString
{
    [[NSFileManager defaultManager] createFileAtPath:[CommonFunctions getDocumentsFilePath:fileString] contents:nil attributes:nil];
}

+ (void)deleteFileAtFullPath:(NSString*)fileString
{
    if (fileString != nil && [CommonFunctions fileExistsAtFullPath:fileString]) {
        [[NSFileManager defaultManager] removeItemAtPath:fileString error:nil];
    }
}

+ (void)deleteFileAtDocumentsPath:(NSString*)fileString
{
    [CommonFunctions deleteFileAtFullPath:[CommonFunctions getDocumentsFilePath:fileString]];
}

+ (void)deleteFileAtLibraryPath:(NSString*)fileString
{
    [CommonFunctions deleteFileAtFullPath:[CommonFunctions getLibraryFilePath:fileString]];
}

+ (void)moveFileAtFullPath:(NSString*)oldFileString toNewFullPath:(NSString*)newFileString
{
    if ([CommonFunctions fileExistsAtFullPath:oldFileString]) {
        NSError* error = [NSError errorWithDomain:ERROR_DOMAIN code:ERROR_CODE_MOVE_FILE_FAILED userInfo:nil];
        BOOL retVal = [[NSFileManager defaultManager] moveItemAtPath:oldFileString toPath:newFileString error:&error];
        if (!retVal) {
            DebugLog(@"Move File \nfrom [%@] \nto [%@]\n failed.", oldFileString, newFileString);
        }
    }
}

+ (void)moveFileAtDocumentsPath:(NSString*)oldFileString toNewDocumentsPath:(NSString*)newFileString
{
    [CommonFunctions moveFileAtFullPath:[CommonFunctions getDocumentsFilePath:oldFileString] toNewFullPath:[CommonFunctions getDocumentsFilePath:newFileString]];
}

+ (long long)convertSecondToMillisecond:(NSTimeInterval)second
{
    return second * 1000;
}

// Get full name of given file name and extend.
+ (NSString*)getFullName:(NSString*)fileName extend:(NSString*)fileExtend
{
    if (fileExtend == nil || [fileExtend length] == 0) {
        return fileName;
    }
    else {
        return [NSString stringWithFormat:@"%@.%@", fileName, fileExtend];
    }
}

+ (NSString*)getUniqueFileName:(NSString*)folderName fileName:(NSString*)fileName fileExtend:(NSString*)fileExtend;
{
    NSString* folderPath = [CommonFunctions getDocumentsFilePath:folderName];
    NSString* fileNameString;
    NSString* fullPathString = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, fileExtend]];

    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathString]) {
        int i = 1;
        while (TRUE) {
            fileNameString = [NSString stringWithFormat:@"%@(%d)", fileName, i];
            fullPathString = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileNameString, fileExtend]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:fullPathString]) {
                return fileNameString;
            }
            i++;
        }
    }

    return fileName;
}

+ (NSArray*)getFileNameAndExtend:(NSString*)fileNameString
{
    NSString* fileName = @"";
    NSString* fileExtend;

    NSRange range = [fileNameString rangeOfString:@"." options:NSBackwardsSearch];
    if (range.length != 0) {
        fileName = [fileNameString substringToIndex:range.location];
        if (range.location + 1 < [fileNameString length]) {
            fileExtend = [fileNameString substringFromIndex:range.location + 1];
        }
        else {
            fileExtend = @"";
        }
    }
    else {
        fileName = ((fileNameString != nil) ? fileNameString : @"");
        fileExtend = @"";
    }

    return [NSArray arrayWithObjects:fileName, fileExtend, nil];
}

+ (void)alertFileExists
{
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@""
                                                     message:NSLocalizedString(@"file exist", nil)
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"button ok", @"OK")
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

+ (void)alertFileNameEmpty
{
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@""
                                                     message:NSLocalizedString(@"fileName empty", nil)
                                                    delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"button ok", @"OK")
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

+ (NSString*)stringWithContentOfResource:(NSString*)resource ofType:(NSString*)type
{
    NSString* path = [[NSBundle mainBundle] pathForResource:resource ofType:type];

    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    return content;
}

+ (void)showViewFrame:(UIView*)view tipSring:(NSString*)tipString
{
    NSLog(@"%@ : %lf %lf %lf %lf", tipString, view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}

#pragma mark -
#pragma mark UI
+ (UIButton*)createButtonWith:(NSString*)title imageName:(NSString*)imageName highlightedImage:(NSString*)highlightedImage
                       target:(id)target
                       action:(SEL)action
{
    UIButton* button = [CommonFunctions createButtonWithImageName:imageName
                                                 highlightedImage:highlightedImage
                                                           target:target
                                                           action:action];

    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

+ (UIButton*)createButtonWithImageName:(NSString*)imageName highlightedImage:(NSString*)highlightedImage disabledImage:(NSString*)disabledImage target:(id)target action:(SEL)action
{
    UIButton* button = [CommonFunctions createButtonWithImageName:imageName target:target action:action];
    if (highlightedImage)
        [button setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    if (disabledImage)
        [button setBackgroundImage:[UIImage imageNamed:disabledImage] forState:UIControlStateDisabled];
    return button;
}

+ (UIButton*)createButtonWithImageName:(NSString*)imageName highlightedImage:(NSString*)highlightedImage target:(id)target action:(SEL)action
{
    return [CommonFunctions createButtonWithImageName:imageName highlightedImage:highlightedImage disabledImage:nil target:target action:action];
}

+ (UIButton*)createButtonWithImageName:(NSString*)imageName disabledImage:(NSString*)disabledImage target:(id)target action:(SEL)action
{
    return [CommonFunctions createButtonWithImageName:imageName highlightedImage:nil disabledImage:disabledImage target:target action:action];
}

+ (UIButton*)createButton:(NSString*)title target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton*)createButtonWithImageName:(NSString*)imageName target:(id)target action:(SEL)action setStrechable:(BOOL)isSetStretchable
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton*)createButtonWithImageName:(NSString*)imageName target:(id)target action:(SEL)action
{
    return [self createButtonWithImageName:imageName target:target action:action setStrechable:YES];
}

+ (UIButton*)createButton:(NSString*)title buttonType:(UIButtonType)buttonType target:(id)target action:(SEL)action
{
    UIButton* button = [UIButton buttonWithType:buttonType];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton*)createButtonWithImageName:(NSString*)imageName target:(id)target action:(SEL)action imageInset:(UIEdgeInsets)insets
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = insets;
    return button;
}

+ (UIButton*)createButtonWithImageName:(NSString*)imageName target:(id)target action:(SEL)action leftCapWidth:(float)leftCapWidth topCapHeight:(float)topCapHeight
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UIButton*)createButton:(NSString*)title WithImageName:(NSString*)imageName highlightedImage:(NSString*)highlightedImage target:(id)target action:(SEL)action leftCapWidth:(float)leftCapWidth topCapHeight:(float)topCapHeight
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight] forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:highlightedImage] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UITextField*)createTextFieldWithKeyboardType:(UIKeyboardType)keyboardType
{
    UITextField* urlTextField = [[[UITextField alloc] init] autorelease];
    urlTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    urlTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    urlTextField.rightViewMode = UITextFieldViewModeAlways;

    urlTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    urlTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    urlTextField.keyboardType = keyboardType;
    return urlTextField;
}

+ (UITextField*)createNormalTextField
{
    return [CommonFunctions createTextFieldWithKeyboardType:UIKeyboardTypeDefault];
}

+ (UITextField*)createUrlTextField
{
    return [CommonFunctions createTextFieldWithKeyboardType:UIKeyboardTypeURL];
}

+ (UITextField*)createUrlTextFieldWithFrame:(CGRect)frame
{
    UITextField* urlTextField = [[[UITextField alloc] initWithFrame:frame] autorelease];
    urlTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    urlTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    urlTextField.rightViewMode = UITextFieldViewModeAlways;

    urlTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    urlTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    urlTextField.keyboardType = UIKeyboardTypeURL;
    return urlTextField;
}

+ (void)addUIActivityIndicatorView:(UIView*)viewContainer withSize:(CGSize)size
{
    UIActivityIndicatorView* indicatorView = (UIActivityIndicatorView*)[viewContainer viewWithTag:UIACTIVITYINDICATORVIEW_TAG];
    if (indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.tag = UIACTIVITYINDICATORVIEW_TAG;
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        indicatorView.frame = CGRectMake(0, 0, size.width, size.height);
        indicatorView.center = CGPointMake(viewContainer.bounds.size.width / 2, viewContainer.bounds.size.height / 2);
        [viewContainer addSubview:indicatorView];
        [indicatorView release];
    }

    [indicatorView startAnimating];
}

+ (void)addUIActivityIndicatorView:(UIView*)viewContainer
{
    [CommonFunctions addUIActivityIndicatorView:viewContainer withSize:CGSizeMake(30, 30)];
}

+ (void)removeUIActivityIndicatorView:(UIView*)viewContainer
{
    UIActivityIndicatorView* indicatorView = (UIActivityIndicatorView*)[viewContainer viewWithTag:UIACTIVITYINDICATORVIEW_TAG];
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
}

#pragma mark present modal view controller.

+ (UINavigationController*)presentViewControllerWithNavigation:(UIViewController*)viewController inParent:(UIViewController*)parentViewController
{
    UINavigationController* navigationViewController = [[UINavigationController alloc]
        initWithRootViewController:viewController];
    navigationViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    navigationViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    [parentViewController presentViewController:navigationViewController animated:YES completion:nil];
    [navigationViewController release];

    /*
     
     //Old color [UIColor colorWithRed:0.8 green:0.83 blue:0.79 alpha:1.0]
     return [CommonFunctions colorFromInt:0xff2d9b14];
     return [UIImage imageNamed:@"navigation_bar_background.png"];
     */
    if (!([DeviceUtils isIPadMini] || [DeviceUtils isPad])) {
        if (IsAtLeastiOSVersion(@"5.0")) {
            [[navigationViewController navigationBar] setBackgroundImage:[UIImage imageNamed:@"navigation_bar_background.png"] forBarMetrics:UIBarMetricsDefault];
        }
        else {
            navigationViewController.navigationBar.tintColor = [CommonFunctions colorFromInt:0xff2d9b14];
        }
    }

    return navigationViewController;
}

+ (UINavigationController*)presentViewControllerWithNavigation:(UIViewController*)viewController
                                                          size:(CGSize)size
                                                      inParent:(UIViewController*)rootViewController
{
    UINavigationController* nav = [CommonFunctions presentViewControllerWithNavigation:viewController inParent:rootViewController];

    if ([DeviceUtils isPad]) {
        // Try to make the view is popup in center.
        float windowWidth, windowHeight;

        UIView* superOfNav = nav.view.superview;
        CGSize superOfSuperSize = [[superOfNav superview] frame].size;

        // I have to use statusBarOrientation to get the correct window size.
        // It looks strange here. Tried to get the windows directly but it's not correct in landscape orientation.
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            windowWidth = MIN(superOfSuperSize.width, superOfSuperSize.height);
            windowHeight = MAX(superOfSuperSize.width, superOfSuperSize.height);
        }
        else {
            windowWidth = MAX(superOfSuperSize.width, superOfSuperSize.height);
            windowHeight = MIN(superOfSuperSize.width, superOfSuperSize.height);
        }

        superOfNav.frame = CGRectMake((windowWidth - size.width) / 2,
            (windowHeight - size.height) / 2,
            size.width, size.height);
        superOfNav.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
            | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }

    return nav;
}

+ (NSInteger)getNumberInBundle:(NSInteger)currentNumber minNumber:(NSInteger)min maxNumber:(NSInteger)max
{
    if (currentNumber < min) {
        return min;
    }

    if (currentNumber > max) {
        return max;
    }

    return currentNumber;
}

+ (NSMutableArray*)append:(NSArray*)array1 with:(NSArray*)array2
{
    NSMutableArray* result = [NSMutableArray arrayWithArray:array1];
    for (int i = 0; i < [array2 count]; i++) {
        [result addObject:[array2 objectAtIndex:i]];
    }
    return result;
}

+ (BOOL)isDataNullOrEmpty:(NSData*)data
{
    return (nil == data) || ([data length] == 0);
}

+ (BOOL)isArrayNullOrEmpty:(NSArray*)array
{
    return (nil == array) || ([array count] == 0);
}

+ (NSArray*)checkArray:(NSObject*)arrayObject
{
    if ([arrayObject isKindOfClass:[NSArray class]]) {
        return (NSArray*)arrayObject;
    }
    else //Juse return a empty array
    {
        return [NSArray array];
    }
}

+ (NSString*)stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil); //create a new UUID

    //get the string representation of the UUID
    NSString* uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);

    return [uuidString autorelease];
}

+ (void)ensureString:(NSString**)str
{
    if (*str == nil || [*str isKindOfClass:[NSNull class]]) {
        *str = @"";
    }
}

+ (NSString*)boolToString:(BOOL)value
{
    return value ? @"1" : @"0";
}

+ (BOOL)stringToBool:(NSString*)value
{
    return [value boolValue];
}

+ (UITableViewCell*)findParentCell:(UIView*)subView
{
    UIView* parent = subView.superview;
    while (parent != nil && ![parent isKindOfClass:[UITableViewCell class]]) {
        parent = parent.superview;
    }

    return (UITableViewCell*)parent;
}

+ (void)dismissPopoverViewCallDelete:(UIPopoverController*)popover
{
    [popover dismissPopoverAnimated:YES];

    // Here we need to manually call the delete, as dismissPopoverAnimated doesn't trigger the delegate.
    [popover.delegate popoverControllerDidDismissPopover:popover];
}

#pragma mark -
#pragma mark Group Table
+ (BOOL)isInToday:(NSDate*)otherDate
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components;

    components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate* currentDate = [cal dateFromComponents:components];
    components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:otherDate];
    NSDate* newDate = [cal dateFromComponents:components];

    if ([currentDate isEqualToDate:newDate]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isInYesterday:(NSDate*)otherDate
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components;

    components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[[NSDate date] dateByAddingTimeInterval:-SECONDS_IN_DAY]];
    NSDate* yesterdayDate = [cal dateFromComponents:components];
    components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:otherDate];
    NSDate* newDate = [cal dateFromComponents:components];

    if ([yesterdayDate isEqualToDate:newDate]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isInSevenDays:(NSDate*)otherDate
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components;

    components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[[NSDate date] dateByAddingTimeInterval:-7 * SECONDS_IN_DAY]];
    NSDate* sevenDayDate = [cal dateFromComponents:components];
    components = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:otherDate];
    NSDate* newDate = [cal dateFromComponents:components];

    if ([newDate timeIntervalSinceDate:sevenDayDate] > 0 && [newDate timeIntervalSinceDate:[NSDate date]] < 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isInSameMonth:(NSDate*)firstDate secondDate:(NSDate*)secondDate
{
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* components1 = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:firstDate];
    NSDateComponents* components2 = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:secondDate];
    if ([components1 year] == [components2 year] && [components1 month] == [components2 month]) {
        return YES;
    }
    return NO;
}

#pragma mark String

// Get the prefix substring that not longer then maxLength.
+ (NSString*)getSubStringof:(NSString*)string maxLength:(int)maxLength
{
    if ([string length] > maxLength) {
        return [string substringToIndex:maxLength];
    }
    else {
        return string;
    }
}

+ (BOOL)isNullOrUndefined:(NSString*)str
{
    return [CommonFunctions isNullOrEmpty:str] || [str isEqualToString:@"undefined"];
}

+ (BOOL)isNullOrEmpty:(NSString*)str
{
    //Many blank shoud be treat as empty eg:" ","    "
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str == nil || [str isKindOfClass:[NSNull class]] || [str length] == 0;
}

+ (NSString*)nullToEmpty:(NSString*)src
{
    return (nil == src) ? @"" : src;
}

+ (BOOL)isEmptyAfterTrim:(NSString*)str
{
    if ([CommonFunctions isNullOrEmpty:str]) {
        return YES;
    }
    else {
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([str length] == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

+ (void)copyToClipboard:(NSString*)str
{
    [[UIPasteboard generalPasteboard] setValue:str
                             forPasteboardType:@"public.utf8-plain-text"];
}

//static NSString* urlRegex = @"(http|https)\\://[a-zA-Z0-9\\-\\.]+\\.[a-zA-Z]{2,3}(:[a-zA-Z0-9]*)?\
/?([a-zA-Z0-9\\-\\._\\?\\,\\'/\\\\\\+&amp;%\\$#@\\=~])*";

//URL Regex
//Reference From Android 2.2 src code android.util.Patterns
#define WEB_URL_REGEX @"((?:(http|https|Http|Https):\\/\\/(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,25})?\\@)?)?((?:(?:[a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF][a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]{0,64}\\.)+(?:(?:aero|arpa|asia|a[cdefgilmnoqrstuwxz])|(?:biz|b[abdefghijmnorstvwyz])|(?:cat|com|coop|c[acdfghiklmnoruvxyz])|d[ejkmoz]|(?:edu|e[cegrstu])|f[ijkmor]|(?:gov|g[abdefghilmnpqrstuwy])|h[kmnrtu]|(?:info|int|i[delmnoqrst])|(?:jobs|j[emop])|k[eghimnprwyz]|l[abcikrstuvy]|(?:mil|mobi|museum|m[acdeghklmnopqrstuvwxyz])|(?:name|net|n[acefgilopruz])|(?:org|om)|(?:pro|p[aefghklmnrstwy])|qa|r[eosuw]|s[abcdeghijklmnortuvyz]|(?:tel|travel|t[cdfghjklmnoprtvwz])|u[agksyz]|v[aceginu]|w[fs]|(?:xn\\-\\-0zwm56d|xn\\-\\-11b5bs3a9aj6g|xn\\-\\-80akhbyknj4f|xn\\-\\-9t4b11yi5a|xn\\-\\-deba0ad|xn\\-\\-g6w251d|xn\\-\\-hgbk6aj7f53bba|xn\\-\\-hlcj6aya9esc7a|xn\\-\\-jxalpdlp|xn\\-\\-kgbechtv|xn\\-\\-zckzah)|y[etu]|z[amw]))|(?:(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(?:25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9])))(?:\\:\\d{1,5})?)(\\/(?:(?:[a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF\\;\\/\\?\\:\\@\\&\\=\\#\\~\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%[a-fA-F0-9]{2}))*)?(?:\\b|$)"

//+ (BOOL)isValidUrl:(NSString*)str
//{
//    NSRange maxRange;
//    maxRange.location = 0;
//    maxRange.length = [str length];
//    return str!=nil && [str isMatchedByRegex:WEB_URL_REGEX options:RKLCaseless inRange:maxRange error:nil];
//}

//static NSString* urlExtractRegex = nil;

//+ (NSString*)extractUrl:(NSString*)text
//{
//    if(urlExtractRegex == nil)
//    {
//        urlExtractRegex = [[NSString stringWithFormat:@"(%@)%@", urlRegex, @"([^a-zA-Z0-9+&@#/%?=~_-|!:.]|$)"] retain];
//    }
//
//    NSString* result = nil;
//    if(![CommonFunctions isNullOrEmpty:text])
//    {
//        result = [text stringByMatching:urlExtractRegex
//                                options:RKLCaseless
//                                inRange:NSMakeRange(0, [text length])
//                                capture:1 error:nil];
//    }
//
//    if(result != nil)
//    {
//        // This handle some special case for twitter,
//        // that the url get truncated at the end.
//        // In this case we are not able to get the correct url.
//        if([text hasSuffix:[NSString stringWithFormat:@"%@...", result]])
//        {
//            result = nil;
//        }
//
//        NSURL* url = [NSURL URLWithString:result];
//        if(url == nil)
//        {
//            result = nil;
//        }
//    }
//
//    return result;
//}

+ (NSString*)URLStringWithHTTP:(NSString*)urlString
{
    if (![[self class] isNullOrEmpty:urlString] && [[self class] isValidUrl:urlString]) {
        //If no scheme, we give it a scheme
        NSUInteger colonIndex = [urlString rangeOfString:@":"].location;
        if (colonIndex == NSNotFound) {
            return [NSString stringWithFormat:@"http://%@", urlString];
        }
    }
    return urlString;
}

+ (NSString*)getFavIconFromUrl:(NSString*)urlString
{
    NSURL* url = [NSURL URLWithString:urlString];

    return [NSString stringWithFormat:@"http://%@/favicon.ico", [url host]];
}

//http://www.cnblogs.com/wubin264/archive/2009/10/30/1592805.html
+ (NSString*)replaceBadCharOfFileName:(NSString*)filename
{
    return [filename stringByReplacingOccurrencesOfRegex:@"[\\\\/:*?\"<>|]" withString:@" "];
}

#pragma mark Positions
+ (CGPoint)getCenter:(CGRect)rect
{
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

+ (void)alertError:(NSString*)title message:(NSString*)message
{
    [CommonFunctions alertError:title message:message delegate:nil];
}

+ (UIAlertView*)alertError:(NSString*)title message:(NSString*)message delegate:(id)delegate
{
    UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:delegate
                                           cancelButtonTitle:NSLocalizedString(@"button ok", nil)
                                           otherButtonTitles:nil] autorelease];
    [alert show];

    return alert;
}

+ (void)alertConform:(NSString*)title message:(NSString*)message delegate:(id)delegate
{
    [CommonFunctions alertConform:title message:message buttonText:title delegate:delegate];
}

+ (void)alertConform:(NSString*)title message:(NSString*)message buttonText:(NSString*)buttonText delegate:(id<UIAlertViewDelegate>)delegate
{
    [CommonFunctions alertConform:title message:message buttonText:buttonText delegate:delegate tag:0];
}

+ (void)alertConform:(NSString*)title message:(NSString*)message buttonText:(NSString*)buttonText delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag
{
    if (![CommonFunctions isNullOrEmpty:title] && ![CommonFunctions isNullOrEmpty:message] && ![CommonFunctions isNullOrEmpty:buttonText]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:delegate
                                               cancelButtonTitle:buttonText // This is actually not a cancel button. Cancel is index 1.
                                               otherButtonTitles:NSLocalizedString(@"cancel", nil), nil] autorelease];
        alert.cancelButtonIndex = ALERT_VIEW_CANCEL_BUTTON_INDEX;
        alert.tag = tag;
        [alert show];
    }
}

static const float kColorRangeTopValue = 255.F;

// color format 0xFFFFFFFF   ARGB
+ (UIColor*)colorFromInt:(long)intColor
{
    long alp = (intColor >> 24) & 0x000000FF;
    long red = (intColor >> 16) & 0x000000FF;
    long green = (intColor >> 8) & 0x000000FF;
    long blue = intColor & 0x000000FF;
    return [UIColor colorWithRed:red / kColorRangeTopValue green:green / kColorRangeTopValue blue:blue / kColorRangeTopValue alpha:alp / kColorRangeTopValue];
}

+ (long)intFromColor:(UIColor*)color
{
    CGFloat red = 0.f;
    CGFloat green = 0.f;
    CGFloat blue = 0.f;
    CGFloat alpha = 0.f;

    if ([[DeviceUtils deviceOSVersion] floatValue] >= 5.0f) {
        //http://stackoverflow.com/questions/10699385/uidevicergbcolor-getredgreenbluealpha-unrecognized-selector-not-due-to-mem

        if ([color getRed:&red green:&green blue:&blue alpha:&alpha]) {
            red *= kColorRangeTopValue;
            green *= kColorRangeTopValue;
            blue *= kColorRangeTopValue;
            alpha *= kColorRangeTopValue;

            return ((int)alpha << 24) + ((int)red << 16) + ((int)green << 8) + (int)blue;
        }
    }
    else {
        //http://stackoverflow.com/questions/816828/extracting-rgb-from-uicolor
        long numComponents = CGColorGetNumberOfComponents(color.CGColor);

        if (numComponents == 4) {
            const CGFloat* components = CGColorGetComponents(color.CGColor);
            red = components[0] * kColorRangeTopValue;
            green = components[1] * kColorRangeTopValue;
            blue = components[2] * kColorRangeTopValue;
            alpha = components[3] * kColorRangeTopValue;

            return ((int)alpha << 24) + ((int)red << 16) + ((int)green << 8) + (int)blue;
        }
    }
    return 0;
}

+ (UIImage*)imageFromColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (int)getRandomBetween:(int)min max:(int)max
{
    int random = arc4random() % (max - min);
    return min + random;
}

+ (UIImage*)imageFromView:(UIView*)view withHighQuality:(BOOL)highQuality
{
    return [self imageFromView:view withBounds:view.bounds withHighQuality:highQuality];
}

+ (UIImage*)imageFromView:(UIView*)view withBounds:(CGRect)bounds withHighQuality:(BOOL)highQuality
{
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!highQuality) {
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGContextSetShouldAntialias(context, NO);
        CGContextSetShouldSmoothFonts(context, NO);
        CGContextSetShouldSubpixelPositionFonts(context, NO);
        CGContextSetShouldSubpixelQuantizeFonts(context, NO);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

+ (BOOL)areRect:(CGRect)aRect equalToRect:(CGRect)anotherRect
{
    return [CommonFunctions areRect:aRect equalToRect:anotherRect withPrecision:FLT_EPSILON];
}

+ (BOOL)areRect:(CGRect)aRect equalToRect:(CGRect)anotherRect withPrecision:(float)precision
{
    return (ABS(aRect.origin.x - anotherRect.origin.x) < precision && ABS(aRect.origin.y - anotherRect.origin.y) < precision
        && ABS(aRect.size.width - anotherRect.size.width) < precision && ABS(aRect.size.height - anotherRect.size.height) < precision);
}

+ (BOOL)areSize:(CGSize)size1 equal:(CGSize)size2
{
    return fequal(size1.width, size2.width) && fequal(size1.height, size2.height);
}

+ (BOOL)arePoint:(CGPoint)aPoint equalToPoint:(CGPoint)anotherPoint withPrecision:(float)precision
{
    return ABS(aPoint.x - anotherPoint.x) < precision && ABS(aPoint.y - anotherPoint.y) < precision;
}

+ (BOOL)isPoint:(CGPoint)point inRect:(CGRect)rect withExtendedSize:(CGSize)size
{
    CGRect extendedRect = CGRectMake(rect.origin.x - size.width, rect.origin.y - size.height, rect.size.width + size.width * 2, rect.size.height + size.height * 2);
    return point.x >= extendedRect.origin.x && point.x <= extendedRect.origin.x + extendedRect.size.width && point.y >= extendedRect.origin.y && point.y <= extendedRect.origin.y + extendedRect.size.height;
}

+ (BOOL)CFRangeContainsRange:(CFRange)aRange anotherRange:(CFRange)anotherRange
{
    if (aRange.location <= anotherRange.location && (aRange.location + aRange.length) >= (anotherRange.location + anotherRange.length)) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (UIView*)hittestWithDescendantView:(UIView*)descendant point:(CGPoint)point rawHitView:(UIView*)rawHitView enlargedSize:(float)size viewToEnlarge:(UIView*)viewToEnlarge
{
    return [self hittestWithDescendantView:descendant point:point rawHitView:rawHitView enlargedSize:size viewsToEnlarge:[NSArray arrayWithObject:viewToEnlarge]];
}

+ (UIView*)hittestWithDescendantView:(UIView*)descendant point:(CGPoint)point rawHitView:(UIView*)rawHitView enlargedSize:(float)size viewsToEnlarge:(NSArray*)viewsToEnlarge
{
    if ([descendant isDescendantOfView:rawHitView]) {
        for (UIView* view in viewsToEnlarge) {
            if (!view.hidden && view.alpha >= 0.01 && [self isPoint:point inRect:view.frame withExtendedSize:CGSizeMake(size, size)]) {
                return view;
            }
        }
    }

    return rawHitView;
}

static NSDateFormatter* timeFormatter = nil;

+ (NSString*)formatTime:(NSDate*)time
{
    if (nil == timeFormatter) {
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setAMSymbol:@"AM"];
        [timeFormatter setPMSymbol:@"PM"];
        [timeFormatter setDateFormat:@"MM/dd HH:mm a"];
    }
    return [timeFormatter stringFromDate:time];
}

static NSDateFormatter* timeHasYearFormatter = nil;

+ (NSString*)formatTimeHasYear:(NSDate*)time
{
    if (nil == timeHasYearFormatter) {
        timeHasYearFormatter = [[NSDateFormatter alloc] init];
        [timeHasYearFormatter setAMSymbol:@"AM"];
        [timeHasYearFormatter setPMSymbol:@"PM"];
        [timeHasYearFormatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    }
    return [timeHasYearFormatter stringFromDate:time];
}

+ (BOOL)isWebzineEffectiveDate:(NSDate*)date
{
    BOOL result = NO;
    if (date != nil) {
        NSCalendar* cal = [NSCalendar currentCalendar];
        NSDateComponents* components = [cal components:NSCalendarUnitYear fromDate:date];
        if ([components year] > 1970) {
            result = YES;
        }
    }
    return result;
}

+ (NSString*)formatWebzineTime:(NSDate*)time
{
    NSString* strTime = @"";

    if ([self isWebzineEffectiveDate:time]) {
        NSTimeInterval timeInterval = abs([time timeIntervalSinceNow]);
        long minutes = (long)(timeInterval / 60.0);
        long hours = (long)(timeInterval / (60.0 * 60));
        long days = (long)(timeInterval / (60.0 * 60 * 24));
        if (minutes < 60) {
            strTime = [NSString stringWithFormat:@"%ld %@", minutes, NSLocalizedString(@"minutes ago", @"minutes ago")];
        }
        else if (hours < 24) {
            strTime = [NSString stringWithFormat:@"%ld %@", hours, NSLocalizedString(@"hours ago", @"hours ago")];
        }
        else if (days < 7) {
            strTime = [NSString stringWithFormat:@"%ld %@", days, NSLocalizedString(@"days ago", @"days ago")];
        }
        else {
            strTime = [self formatTimeHasYear:time];
        }
    }
    return strTime;
}

+ (CGRect)getImageViewContentRect:(UIImageView*)imageView
{
    CGRect contentRect = CGRectMake(0, 0, 0, 0);
    if (imageView != nil && imageView.image != nil && imageView.image.size.width != 0 && imageView.image.size.height != 0) {
        CGSize imageSize = imageView.image.size;
        if (imageSize.width > imageView.bounds.size.width || imageSize.height > imageView.bounds.size.height) {
            CGFloat factor = 1.0;
            factor = MIN(imageView.bounds.size.width / imageSize.width, imageView.bounds.size.height / imageSize.height);
            imageSize.width *= factor;
            imageSize.height *= factor;
        }

        contentRect = CGRectMake(imageView.bounds.origin.x + (imageView.bounds.size.width - imageSize.width) / 2, imageView.bounds.origin.y + (imageView.bounds.size.height - imageSize.height) / 2, imageSize.width, imageSize.height);
    }
    return contentRect;
}

+ (UIImage*)getResizableImageWithCapInsets:(UIEdgeInsets)capInsets forImage:(UIImage*)image
{
    if (IsAtLeastiOSVersion(@"5.0")) {
        return [image resizableImageWithCapInsets:capInsets];
    }
    else {
        return [image stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
}

+ (CGSize)textSizeOfLabel:(UILabel*)label
{
    NSString* text = label.text;
    return [text sizeWithFont:label.font];
}

+ (CGSize)textSizeOfLabel:(UILabel*)label maxWidth:(CGFloat)maxWidth
{
    CGSize textSize = [CommonFunctions textSizeOfLabel:label];
    return (textSize.width < maxWidth) ? textSize : CGSizeMake(maxWidth, textSize.height);
}

+ (CGSize)textSizeOfLabel:(UILabel*)label maxSize:(CGSize)maxSize
{
    NSString* text = label.text;
    return [text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
}

+ (BOOL)isNullOrEmptyArray:(NSArray*)array
{
    return array == nil || [array count] == 0;
}

+ (NSString*)trackStringOfUrl:(NSURL*)url
{
    if ([CommonFunctions isValidUrl:[url absoluteString]]) {

        NSString* trackLabel;
        NSArray* urlParts = [url pathComponents];
        if (![CommonFunctions isNullOrEmptyArray:urlParts]) {

            //there is three circumstances, first is like "www.sina.com/news/didid.html" which only tracks "www.sina.com/news"
            //second is url like "www.sina.com/index.html" or "www.sina.com/", which tracks "www.sina.com/"
            if ([urlParts count] > 2) {
                trackLabel = [NSString stringWithFormat:@"%@://%@/%@/", [url scheme], [url host], [urlParts objectAtIndex:1]];
            }
            else {
                trackLabel = [NSString stringWithFormat:@"%@://%@/", [url scheme], [url host]];
            }
        }
        else {
            //if the url is like "www.sina.com",  just track "www.sina.com"
            trackLabel = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
        }

        return trackLabel;
    }
    return nil;
}

#pragma mark caculate time interval
NSTimeInterval registedTimeInterval;

+ (void)startRegisterTime
{
    registedTimeInterval = [NSDate timeIntervalSinceReferenceDate];
}

+ (void)printTimeInterval:(NSString*)tagName
{
    DebugLog(@"%@:%lf", tagName, [NSDate timeIntervalSinceReferenceDate] - registedTimeInterval);
}

+ (BOOL)isCNPhoneNumber:(NSString*)num
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString* mobileRegex = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString* cmRegex = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString* cuRegex = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString* ctRegex = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString* phoneRege = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    return [num isMatchedByRegex:mobileRegex] || [num isMatchedByRegex:cmRegex] || [num isMatchedByRegex:cuRegex] || [num isMatchedByRegex:ctRegex] || [num isMatchedByRegex:phoneRege];
}

+ (BOOL)isENPhoneNum:(NSString*)num
{
    NSString* regex = @"^011(999|998|997|996|995|994|993|992|991| 990|979|978|977|976|975|974|973|972|971|970| 969|968|967|966|965|964|963|962|961|960|899| 898|897|896|895|894|893|892|891|890|889|888| 887|886|885|884|883|882|881|880|879|878|877| 876|875|874|873|872|871|870|859|858|857|856| 855|854|853|852|851|850|839|838|837|836|835| 834|833|832|831|830|809|808|807|806|805|804| 803|802|801|800|699|698|697|696|695|694|693| 692|691|690|689|688|687|686|685|684|683|682| 681|680|679|678|677|676|675|674|673|672|671| 670|599|598|597|596|595|594|593|592|591|590| 509|508|507|506|505|504|503|502|501|500|429| 428|427|426|425|424|423|422|421|420|389|388| 387|386|385|384|383|382|381|380|379|378|377| 376|375|374|373|372|371|370|359|358|357|356| 355|354|353|352|351|350|299|298|297|296|295| 294|293|292|291|290|289|288|287|286|285|284| 283|282|281|280|269|268|267|266|265|264|263| 262|261|260|259|258|257|256|255|254|253|252| 251|250|249|248|247|246|245|244|243|242|241| 240|239|238|237|236|235|234|233|232|231|230| 229|228|227|226|225|224|223|222|221|220|219| 218|217|216|215|214|213|212|211|210|98|95|94| 93|92|91|90|86|84|82|81|66|65|64|63|62|61|60| 58|57|56|55|54|53|52|51|49|48|47|46|45|44|43| 41|40|39|36|34|33|32|31|30|27|20|7|1)[0-9]{0, 14}$";

    return [num isMatchedByRegex:regex];
}

+ (BOOL)isPhoneNum:(NSString*)num
{
    return [CommonFunctions isCNPhoneNumber:num] || [CommonFunctions isENPhoneNum:num];
}

@end
