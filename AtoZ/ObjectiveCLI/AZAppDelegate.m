
#import "AZAppDelegate.h"
#define MYGHUSER @"mralexgray"
#define MYGHPASS @"ag979390"

@implementation AZAppDelegate

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector { return NO; }

- (void) awakeFromNib {
	[_webView setDrawsBackground:YES];
//	[_webView.mainFrame loadHTMLString:@"<!DOCTYPE html><html><head></head><body></body></html>" baseURL:nil];
	[_webView setPostsBoundsChangedNotifications:YES];
	[_webView observeFrameChange:^(NSV *v) {
		CGF base = v.width/5.;
		NSS*toEval = $(@"$('.gridly').css({'height':'%fpx','width':'%fpx','background-color':'#%@'});\
		$('.brick.snall').css({'height':'%fpx','width':'%fpx'});\
		$('.gridly').gridly({ base:%f,columns: %i});",v.height,v.width,[RANDOMCOLOR toHex],base,base,base,5);
		XX(toEval);
		[(WebView*)v evaluate:toEval];
	}];
	[_webView.mainFrame.frameView setAllowsScrolling: YES];

	[_webView.windowScriptObject setValue:self forKey:@"ObjC"];
	[_webView appendTag:@"section" attrs:@{@"class":@"example"} inner:
	@"<div class='gridly'>\
			<div class='brick small'></div><div class='brick small'></div>\
			<div class='brick large'></div><div class='brick small'></div>\
			<div class='brick small'></div><div class='brick large'></div>\
	</div>\
	<p class='actions'><a class='add button' href='#'>Add</a></p>"];
	[_webView injectCSSAt:@"http://mrgray.com/js/jquery-gridly/gridly.css"];
	[_webView injectCSSAt:@"http://mrgray.com/js/jquery-gridly/stylesheets/sample.css"];

//	[_webView injectCSS:@".gridly {  position: relative;  width: 960px; } .brick.small {  width: 140px; height: 140px; }\
  .brick.large { width: 300px;  height: 300px;  }"];
	[_webView evaluateScriptAt:@"http://mrgray.com/js/jquery-gridly/javascripts/jquery.gridly.js"];
	[_webView evaluateScriptAt:@"http://mrgray.com/js/jquery-gridly/javascripts/sample.js"];
//	[_webView evaluate:@"$('.gridly').gridly({    base: 60, gutter: 20,  columns: 12  });"];
}
//- (void) gridWasClicked:(
//- (void) pplicationDidFinishLaunching:(NSNOT*)n {

//	[_ov setOVSelectionDidChange:^(NSOV*outline) {	XX(outline);	id selectedNode = _gistController.selectedRepresentedObject;
//
//		NSUI row = outline.selectedRow;
//
//		if ( row != NSNotFound) {
//			id select = [_gistController.content[0] childNodes][row];
//			XX(NSStringFromClass([select class]));
//		}
//		self.attributedLog = [JATExpand(@"{0} \n\nselectedNode:{selectedNode} class:{2} {3}",
//		[selectedNode representedObject],selectedNode, NSStringFromClass([selectedNode class]), [selectedNode childNodes])
//		attributedWithFont:AtoZ.controlFont andColor:RANDOMCOLOR];
////		self.attributedLog = [[selectedNode childNodes] reduce:NSMAS.new withBlock:^id(NSMAS* sum, id obj) {
////			NSS* key = [obj allKeys][0];
////			[sum appendAttributedString:[JATExpand(@"{0}:{1}\n", key, [selectedNode key]) attributedWithFont:AtoZ.controlFont andColor:RANDOMCOLOR]];
////			return sum;
////		}];
//	}];

//	self.engine = [UAGithubEngine.alloc initWithUsername:MYGHUSER password:MYGHPASS withReachability:YES];
//	[AZSSOQ addOperationWithBlock:^{
//		[_engine gistsForUser:MYGHUSER success:^(id gists) {
//			[_ov beginUpdates];
//			[_gistController addGists:gists];
//			[_ov endUpdates];
//			
////		XX([gists class]);//[_gistController.content count]);
//		} failure:^(NSError *b) { }];
//	}];
//}
//- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item{ NSLog(@"is group:%@", item);
//	return [item ISKINDA:AZGist.class];
//}
//- (NSV*)outlineView:(NSOV*)ov dataCellForTableColumn:(NSTC*)tc item:(id)x {
//		return  [ov makeViewWithIdentifier:[x ISKINDA:AZGist.class] ? @"HeaderCell" : @"DataCell" owner:self];
//}
//- (NSV*)outlineView:(NSOV*)ov viewForTableColumn:(NSTableColumn*)tc item:(id)x {
//
//		return  [ov makeViewWithIdentifier:[x ISKINDA:AZGist.class] ? @"HeaderCell" : @"DataCell" owner:self];
//
////	return [BLKVIEW viewWithFrame:AZRectBy(ov.width,tc.it <#CGFloat boundY#>) opaque:<#(BOOL)#> drawnUsingBlock:<#^(BNRBlockView *v, NSRect r)drawBlock#>]
//
//	 // [ov makeViewWithIdentifier:[x ISKINDA:AZGist.class] ? @"HeaderCell" : @"DataCell" owner:self];
//}


@end
