

@interface AssetsViewController : NSViewController

@property (WK) IBOutlet	NSArrayController * assetController;
@property (WK) IBOutlet		   NSTableView * assetTable;


@property (NATOM, STRNG) AssetCollection *javaScripts, *styleSheets;

@property (WK) IBOutlet NSPathControl *jsPathBar, *cssPathBar, *htmlPathBar;

@end
