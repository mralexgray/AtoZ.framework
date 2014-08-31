

#import "AGNSSplitView.h"
#import "AZLogConsole.h"


//@protocol AZWebKitProgressDelegate <NSObject>
//- (void) ebKitProgressDidChangeFinishedCount:(NSInteger)finishedCount ofTotalCount:(NSInteger)totalCount;
//@end

//@interface AZWebKitProgressController : NSObject
//@property (nonatomic, weak) IBOutlet id<AZWebKitProgressDelegate> delegate;
//@end


//@class AZURLBar;
//@protocol AZURLBarDelegate <NSObject>
//- (void) rlBar:(AZURLBar *)urlBar didRequestURL:(NSURL *)url;
//@optional
//- (void) rlBarColorConfig;
//@end
//@property (nonatomic, weak) id<AZURLBarDelegate> delegate;


typedef NS_ENUM(int, AZProgPhase) { AZProgNone,  AZProgPending,  AZProgDownloading};


@class AZWebView;
@interface AZURLBar : NSView
@property (weak) AZWebView *webView;
@property (nonatomic) double progress;
@property (nonatomic) AZProgPhase progressPhase;
@property (nonatomic,weak) NSString *addressString;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic,strong) NSColor *gradientColorTop, *gradientColorBottom, *borderColorTop, *borderColorBottom, *barColorPendingTop,  *barColorPendingBottom, *barColorDownloadingTop, *barColorDownloadingBottom;

@property (nonatomic, strong) NSArray *leftItems, *rightItems;

//- (instancetype)initWithDelegate:(id<AZURLBarDelegate>)delegate;


@end



@interface AZURLFormatter : NSFormatter
@end

@interface AZWebView : WebView //<AZURLBarDelegate>
@property AGNSSplitView *split, *consoleSplit;
@property AZLogConsoleView  *console;
@property (nonatomic, weak) IBOutlet AZURLBar *urlBar;
- (void)urlBar:(AZURLBar *)urlBar didRequestURL:(NSURL *)url;
- (BOOL)urlBar:(AZURLBar *)urlBar isValidRequestStringValue:(NSString *)requestString;

//@interface WebView (AZURLBar) <AZURLBarDelegate, AZWebKitProgressDelegate>

//@property (weak) IBOutlet AZURLBar *urlBar;
@end
