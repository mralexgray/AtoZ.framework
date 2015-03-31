
//#import <GHUnit/GHUnit.h>
#import <XCTest/XCTest.h>
#import <AtoZ/AtoZ.h>

@interface      ArrayLikeClass : NSO <ArrayLike> @end
CLANG_IGNORE_PROTOCOL
@implementation ArrayLikeClass
@end
CLANG_POP

@Kind_(ArrayLikeTests,XCTestCase)
   _P  ArrayLikeClass *arrayLike; ￭
@Plan  ArrayLikeTests

- (void) setUp { [super setUp]; _arrayLike = ArrayLikeClass.new; }

- (void) testStorage {

  XCTAssertTrue(_arrayLike.count == 0, @"count should be zero, it was %lu",_arrayLike.count);
  XCTAssertNoThrow([_arrayLike addObject:@"A"], @"can add");
  XCTAssertTrue(_arrayLike.count == 1, @"count should be 1, it was %lu",_arrayLike.count);
}
- (void) testKVO {

  __block NSS* a = @"A";
  __block id __arrayLike = _arrayLike;
  __block BOOL observationHappened = NO, doesContain = NO, wasArrayLike = NO;
  [_arrayLike addObserverForKeyPath:@"storage" task:^(id sender) {
    observationHappened = YES;
    wasArrayLike = [sender isEqual:__arrayLike];
    doesContain = [[sender vFK:@"storage"] containsObject:a];
  }];
  XCTAssertNoThrow([_arrayLike addObject:a], @"can add");
  XCTAssertTrue(observationHappened, @"Observation should have happened");
  XCTAssertTrue(wasArrayLike, @"sender should have bee _arraylike");
  XCTAssertTrue(doesContain, @"added value should have been present in storage array");

}

- (void) testFastEnumeration {

  NSA* colors = RANDOMPAL;
  NSUI ctr = 0;
  XCTAssertNoThrow([_arrayLike addObjects:colors], @"can add");
  XCTAssertTrue(_arrayLike.count == colors.count, @"count should equal added array object count");
  for (id x in _arrayLike) {
    ctr++;
    XCTAssertTrue(ISA(x,NSC), @"ALl objects are colors");
  }
  NSLog(@"Counted %lu objects during fast Enumeration",ctr);
  XCTAssertTrue(ctr == colors.count, @"ctr should have been iteated for each color");
}
@end

/*
@interface AZUITests : XCTestCase { IBOutlet NSOutlineView* ov; IBOutlet NSTreeController *tc; 
												NSA *objects, *colors; }
@end

@implementation AZUITests

- (void) setUpClass {
  // Run at start of all tests in the class
}

- (void) tearDownClass {
  // Run at end of all tests in the class
}

- (void) setUp {
	
		if (![NSBundle loadNibNamed:AZCLSSTR owner:self]) return NSLog(@"Couldn't load nib");
	
	objects = [[@0 to:@10]nmap:^id(id obj, NSUInteger i) {
		NSTreeNode *rootNode = [NSTreeNode treeNodeWithRepresentedObject:[NSString stringWithFormat:@"%lu",i]];
      for (int j=0;  j<4;  j++) {
            NSTreeNode *lev1Node = [NSTreeNode treeNodeWithRepresentedObject:[NSString stringWithFormat:@"%d",j]];
            [rootNode.mutableChildNodes addObject:lev1Node];
        }
		  return rootNode;
    }];
    colors = [RANDOMPAL withMin:objects.count max:objects.count];
    tc = [NSTreeController.alloc initWithContent:objects];
    tc.childrenKeyPath = @"childNodes";
	[ov.window makeKeyAndOrderFront:nil];
}

- (void) tearDown {
  // Run after each test method
}

- (void) testOK {

	ov.rowViewForItem = ^NSTableRowView*(NSOV*outline,id item) {
		
		return (id) nil;
	};
}

- (void) testFail {
//  GHAssertTrue(NO, nil);
}

@end
*/

//@interface AtoZTests : GHTestCase
//- (GBApplicationSettingsProvider *)settingsByRunningWithArgs:(NSString *)first, ... NS_REQUIRES_NIL_TERMINATION;
//@property (readonly) NSString *currentPath;
//@end
//
//// These unit tests verify DDCli KVC methods and properties are implemented and properly mapped to GBApplicationSettingsProvider
//@implementation GBAppledocApplicationTesting
//
//#pragma mark Helper methods testing
//
//- (void) testStandardizeCurrentDirectoryForPath_shouldConvertDotToCurrentDir {
//	// setup
//	GBAppledocApplication *app = GBAppledocApplication.new;
//	//execute & verify
//	assertThat([app standardizeCurrentDirectoryForPath:@"."], is(self.currentPath));
//	assertThat([app standardizeCurrentDirectoryForPath:@"./path/subpath"], is([NSString stringWithFormat:@"%@/path/subpath", self.currentPath]));
//	assertThat([app standardizeCurrentDirectoryForPath:@"path.with/dots/."], is(@"path.with/dots/."));
//	assertThat([app standardizeCurrentDirectoryForPath:@".."], is(@".."));
//	assertThat([app standardizeCurrentDirectoryForPath:@"../path/subpath"], is(@"../path/subpath"));
//}
//
//#pragma mark Paths settings testing
//
//- (void) testOutput_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--output", @"path", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--output", @".", nil];
//	// verify
//	assertThat(settings1.outputPath, is(@"path"));
//	assertThat(settings2.outputPath, is(self.currentPath));
//}
//
//- (void) testTemplates_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--templates", @"path", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--templates", @".", nil];
//	// verify
//	assertThat(settings1.templatesPath, is(@"path"));
//	assertThat(settings2.templatesPath, is(self.currentPath));
//}
//
//- (void) testDocsetInstallPath_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--docset-install-path", @"path", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--docset-install-path", @".", nil];
//	// verify
//	assertThat(settings1.docsetInstallPath, is(@"path"));
//	assertThat(settings2.docsetInstallPath, is(self.currentPath));
//}
//
//- (void) testXcrunPath_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--xcrun-path", @"path", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--xcrun-path", @".", nil];
//	// verify
//	assertThat(settings1.xcrunPath, is(@"path"));
//	assertThat(settings2.xcrunPath, is(self.currentPath));
//}
//
//- (void) testIndexDesc_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--index-desc", @"path/file.txt", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--index-desc", @".", nil];
//	// verify
//	assertThat(settings1.indexDescriptionPath, is(@"path/file.txt"));
//	assertThat(settings2.indexDescriptionPath, is(self.currentPath));
//}
//
//- (void) testInclude_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--include", @"path", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--include", @".", nil];
//	// verify - note that ignore should not convert dot to current path; this would prevent .m being parsed properly!
//	assertThatInteger([settings1.includePaths count], equalToInteger(1));
//	assertThatBool([settings1.includePaths containsObject:@"path"], equalToBool(YES));
//	assertThatBool([settings2.includePaths containsObject:self.currentPath], equalToBool(YES));
//}
//
//- (void) testInclude_shouldAssignMutlipleValuesToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--include", @"path1", @"--include", @"path2", @"--include", @"path3", nil];
//	// verify
//	assertThatInteger([settings.includePaths count], equalToInteger(3));
//	assertThatBool([settings.includePaths containsObject:@"path1"], equalToBool(YES));
//	assertThatBool([settings.includePaths containsObject:@"path2"], equalToBool(YES));
//	assertThatBool([settings.includePaths containsObject:@"path3"], equalToBool(YES));
//}
//
//- (void) testIgnore_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--ignore", @"path", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--ignore", @".", nil];
//	// verify - note that ignore should not convert dot to current path; this would prevent .m being parsed properly!
//	assertThatInteger([settings1.ignoredPaths count], equalToInteger(1));
//	assertThatBool([settings1.ignoredPaths containsObject:@"path"], equalToBool(YES));
//	assertThatBool([settings2.ignoredPaths containsObject:@"."], equalToBool(YES));
//}
//
//- (void) testIgnore_shouldAssignMutlipleValuesToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--ignore", @"path1", @"--ignore", @"path2", @"--ignore", @"path3", nil];
//	// verify
//	assertThatInteger([settings.ignoredPaths count], equalToInteger(3));
//	assertThatBool([settings.ignoredPaths containsObject:@"path1"], equalToBool(YES));
//	assertThatBool([settings.ignoredPaths containsObject:@"path2"], equalToBool(YES));
//	assertThatBool([settings.ignoredPaths containsObject:@"path3"], equalToBool(YES));
//}
//
//#pragma mark Project settings testing
//
//- (void) testProjectName_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--project-name", @"value", nil];
//	// verify
//	assertThat(settings.projectName, is(@"value"));
//}
//
//- (void) testProjectVersion_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--project-version", @"value", nil];
//	// verify
//	assertThat(settings.projectVersion, is(@"value"));
//}
//
//- (void) testProjectCompany_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--project-company", @"value", nil];
//	// verify
//	assertThat(settings.projectCompany, is(@"value"));
//}
//
//- (void) testCompanyIdentifier_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--company-id", @"value", nil];
//	// verify
//	assertThat(settings.companyIdentifier, is(@"value"));
//}
//
//#pragma mark Behavior settings testing
//
//- (void) testCleanOutput_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--clean-output", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-clean-output", nil];
//	// verify
//	assertThatBool(settings1.cleanupOutputPathBeforeRunning, equalToBool(YES));
//	assertThatBool(settings2.cleanupOutputPathBeforeRunning, equalToBool(NO));
//}
//
//- (void) testCreateHTML_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--create-html", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-create-html", nil];
//	// verify
//	assertThatBool(settings1.createHTML, equalToBool(YES));
//	assertThatBool(settings2.createHTML, equalToBool(NO));
//	assertThatBool(settings2.createDocSet, equalToBool(NO));
//	assertThatBool(settings2.installDocSet, equalToBool(NO));
//	assertThatBool(settings2.publishDocSet, equalToBool(NO));
//}
//
//- (void) testCreateDocSet_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--create-docset", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-create-docset", nil];
//	// verify
//	assertThatBool(settings1.createHTML, equalToBool(YES));
//	assertThatBool(settings2.createDocSet, equalToBool(NO));
//	assertThatBool(settings1.createDocSet, equalToBool(YES));
//	assertThatBool(settings2.installDocSet, equalToBool(NO));
//	assertThatBool(settings2.publishDocSet, equalToBool(NO));
//}
//
//- (void) testInstallDocSet_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--install-docset", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-install-docset", nil];
//	// verify
//	assertThatBool(settings1.createHTML, equalToBool(YES));
//	assertThatBool(settings1.createDocSet, equalToBool(YES));
//	assertThatBool(settings1.installDocSet, equalToBool(YES));
//	assertThatBool(settings2.installDocSet, equalToBool(NO));
//	assertThatBool(settings2.publishDocSet, equalToBool(NO));
//}
//
//- (void) testPublishDocSet_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--publish-docset", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-publish-docset", nil];
//	// verify
//	assertThatBool(settings1.createHTML, equalToBool(YES));
//	assertThatBool(settings1.createDocSet, equalToBool(YES));
//	assertThatBool(settings1.installDocSet, equalToBool(YES));
//	assertThatBool(settings1.publishDocSet, equalToBool(YES));
//	assertThatBool(settings2.publishDocSet, equalToBool(NO));
//}
//
//- (void) testUseAppleAnchors_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--html-anchors", @"appledoc", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--html-anchors", @"apple", nil];
//	GBApplicationSettingsProvider *settings3 = [self settingsByRunningWithArgs:nil];
//	// verify
//	assertThatBool(settings1.htmlAnchorFormat, equalToInt(GBHTMLAnchorFormatAppleDoc));
//	assertThatBool(settings2.htmlAnchorFormat, equalToInt(GBHTMLAnchorFormatApple));
//	assertThatBool(settings3.htmlAnchorFormat, equalToInt(GBHTMLAnchorFormatAppleDoc));
//}
//
//- (void) testKeepIntermediateFiles_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--keep-intermediate-files", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-keep-intermediate-files", nil];
//	// verify
//	assertThatBool(settings1.keepIntermediateFiles, equalToBool(YES));
//	assertThatBool(settings2.keepIntermediateFiles, equalToBool(NO));
//}
//
//- (void) testKeepUndocumentedObjects_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--keep-undocumented-objects", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-keep-undocumented-objects", nil];
//	// verify
//	assertThatBool(settings1.keepUndocumentedObjects, equalToBool(YES));
//	assertThatBool(settings2.keepUndocumentedObjects, equalToBool(NO));
//}
//
//- (void) testKeepUndocumentedMembers_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--keep-undocumented-members", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-keep-undocumented-members", nil];
//	// verify
//	assertThatBool(settings1.keepUndocumentedMembers, equalToBool(YES));
//	assertThatBool(settings2.keepUndocumentedMembers, equalToBool(NO));
//}
//
//- (void) testFindUndocumentedMembersDocumentation_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--search-undocumented-doc", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-search-undocumented-doc", nil];
//	// verify
//	assertThatBool(settings1.findUndocumentedMembersDocumentation, equalToBool(YES));
//	assertThatBool(settings2.findUndocumentedMembersDocumentation, equalToBool(NO));
//}
//
//- (void) testRepeatFirstParagraph_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--repeat-first-par", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-repeat-first-par", nil];
//	// verify
//	assertThatBool(settings1.repeatFirstParagraphForMemberDescription, equalToBool(YES));
//	assertThatBool(settings2.repeatFirstParagraphForMemberDescription, equalToBool(NO));
//}
//
//- (void) testPreprocessHeaderDoc_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--preprocess-headerdoc", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-preprocess-headerdoc", nil];
//	// verify
//	assertThatBool(settings1.preprocessHeaderDoc, equalToBool(YES));
//	assertThatBool(settings2.preprocessHeaderDoc, equalToBool(NO));
//}
//
//- (void) testUseSingleStarForBold_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--use-single-star", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-use-single-star", nil];
//	// verify
//	assertThatBool(settings1.useSingleStarForBold, equalToBool(YES));
//	assertThatBool(settings2.useSingleStarForBold, equalToBool(NO));
//}
//
//- (void) testMergeCategoriesToClasses_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--merge-categories", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-merge-categories", nil];
//	// verify
//	assertThatBool(settings1.mergeCategoriesToClasses, equalToBool(YES));
//	assertThatBool(settings2.mergeCategoriesToClasses, equalToBool(NO));
//}
//
//- (void) testMergeCategoryCommentToClass_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--merge-category-comment", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-merge-category-comment", nil];
//	// verify
//	assertThatBool(settings1.mergeCategoryCommentToClass, equalToBool(YES));
//	assertThatBool(settings2.mergeCategoryCommentToClass, equalToBool(NO));
//}
//
//- (void) testKeepMergedCategoriesSections_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--keep-merged-sections", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-keep-merged-sections", nil];
//	// verify
//	assertThatBool(settings1.keepMergedCategoriesSections, equalToBool(YES));
//	assertThatBool(settings2.keepMergedCategoriesSections, equalToBool(NO));
//}
//
//- (void) testPrefixMergedCategoriesSectionsWithCategoryName_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--prefix-merged-sections", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-prefix-merged-sections", nil];
//	// verify
//	assertThatBool(settings1.prefixMergedCategoriesSectionsWithCategoryName, equalToBool(YES));
//	assertThatBool(settings2.prefixMergedCategoriesSectionsWithCategoryName, equalToBool(NO));
//}
//
//- (void) testExplicitCrossRef_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--explicit-crossref", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-explicit-crossref", nil];
//	// verify
//	assertThat(settings1.commentComponents.crossReferenceMarkersTemplate, is(@"<%@>"));
//	assertThat(settings2.commentComponents.crossReferenceMarkersTemplate, is(@"<?%@>?"));
//}
//
//- (void) testCrossRefFormat_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--crossref-format", @"FORMAT", nil];
//	// verify
//	assertThat(settings.commentComponents.crossReferenceMarkersTemplate, is(@"FORMAT"));
//}
//
//- (void) testExitCodeThreshold_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--exit-threshold", @"2", nil];
//	// verify
//	assertThatInteger(settings.exitCodeThreshold, equalToInteger(2));
//}
//
//#pragma mark Warnings settings testing
//
//- (void) testWarnOnMissingOutputPath_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--warn-missing-output-path", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-warn-missing-output-path", nil];
//	// verify
//	assertThatBool(settings1.warnOnMissingOutputPathArgument, equalToBool(YES));
//	assertThatBool(settings2.warnOnMissingOutputPathArgument, equalToBool(NO));
//}
//
//- (void) testWarnOnMissingCompanyIdentifier_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--warn-missing-company-id", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-warn-missing-company-id", nil];
//	// verify
//	assertThatBool(settings1.warnOnMissingCompanyIdentifier, equalToBool(YES));
//	assertThatBool(settings2.warnOnMissingCompanyIdentifier, equalToBool(NO));
//}
//
//- (void) testWarnOnUndocumentedObject_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--warn-undocumented-object", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-warn-undocumented-object", nil];
//	// verify
//	assertThatBool(settings1.warnOnUndocumentedObject, equalToBool(YES));
//	assertThatBool(settings2.warnOnUndocumentedObject, equalToBool(NO));
//}
//
//- (void) testWarnOnUndocumentedMember_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--warn-undocumented-member", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-warn-undocumented-member", nil];
//	// verify
//	assertThatBool(settings1.warnOnUndocumentedMember, equalToBool(YES));
//	assertThatBool(settings2.warnOnUndocumentedMember, equalToBool(NO));
//}
//
//- (void) testWarnOnEmptyDescription_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--warn-empty-description", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-warn-empty-description", nil];
//	// verify
//	assertThatBool(settings1.warnOnEmptyDescription, equalToBool(YES));
//	assertThatBool(settings2.warnOnEmptyDescription, equalToBool(NO));
//}
//
//- (void) testWarnOnUnknownDirective_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--warn-unknown-directive", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-warn-unknown-directive", nil];
//	// verify
//	assertThatBool(settings1.warnOnUnknownDirective, equalToBool(YES));
//	assertThatBool(settings2.warnOnUnknownDirective, equalToBool(NO));
//}
//
//- (void) testWarnOnInvalidCrossReference_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--warn-invalid-crossref", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-warn-invalid-crossref", nil];
//	// verify
//	assertThatBool(settings1.warnOnInvalidCrossReference, equalToBool(YES));
//	assertThatBool(settings2.warnOnInvalidCrossReference, equalToBool(NO));
//}
//
//- (void) testWarnOnMissingMethodArgument_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--warn-missing-arg", nil];
//	GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--no-warn-missing-arg", nil];
//	// verify
//	assertThatBool(settings1.warnOnMissingMethodArgument, equalToBool(YES));
//	assertThatBool(settings2.warnOnMissingMethodArgument, equalToBool(NO));
//}
//
//#pragma mark Documentation set settings testing
//
//- (void) testDocSetBudnleIdentifier_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-bundle-id", @"value", nil];
//	// verify
//	assertThat(settings.docsetBundleIdentifier, is(@"value"));
//}
//
//- (void) testDocSetBundleName_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-bundle-name", @"value", nil];
//	// verify
//	assertThat(settings.docsetBundleName, is(@"value"));
//}
//
//- (void) testDocSetDescription_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-desc", @"value", nil];
//	// verify
//	assertThat(settings.docsetDescription, is(@"value"));
//}
//
//- (void) testDocSetCopyright_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-copyright", @"value", nil];
//	// verify
//	assertThat(settings.docsetCopyrightMessage, is(@"value"));
//}
//
//- (void) testDocSetFeedName_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-feed-name", @"value", nil];
//	// verify
//	assertThat(settings.docsetFeedName, is(@"value"));
//}
//
//- (void) testDocSetFeedURL_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-feed-url", @"value", nil];
//	// verify
//	assertThat(settings.docsetFeedURL, is(@"value"));
//}
//
//- (void) testDocSetFeedFormat_shouldAssignValueToSettings {
//    // setup & execute
//    GBApplicationSettingsProvider *settings1 = [self settingsByRunningWithArgs:@"--docset-feed-formats", @"value", nil];
//    GBApplicationSettingsProvider *settings2 = [self settingsByRunningWithArgs:@"--docset-feed-formats", @"atom", nil];
//    GBApplicationSettingsProvider *settings3 = [self settingsByRunningWithArgs:@"--docset-feed-formats", @"xml", nil];
//    GBApplicationSettingsProvider *settings4 = [self settingsByRunningWithArgs:@"--docset-feed-formats", @"atom,xml", nil];
//    GBApplicationSettingsProvider *settings5 = [self settingsByRunningWithArgs:@"--docset-feed-formats", @"xml,atom", nil];
//    // verify
//    assertThatInteger(settings1.docsetFeedFormats, equalToInteger(0));
//    assertThatInteger(settings2.docsetFeedFormats, equalToInteger(GBPublishedFeedFormatAtom));
//    assertThatInteger(settings3.docsetFeedFormats, equalToInteger(GBPublishedFeedFormatXML));
//    assertThatInteger(settings4.docsetFeedFormats, equalToInteger(GBPublishedFeedFormatAtom | GBPublishedFeedFormatXML));
//    assertThatInteger(settings5.docsetFeedFormats, equalToInteger(GBPublishedFeedFormatAtom | GBPublishedFeedFormatXML));
//}
//
//- (void) testDocSetPackageURL_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-package-url", @"value", nil];
//	// verify
//	assertThat(settings.docsetPackageURL, is(@"value"));
//}
//
//- (void) testDocSetFallbackURL_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-fallback-url", @"value", nil];
//	// verify
//	assertThat(settings.docsetFallbackURL, is(@"value"));
//}
//
//- (void) testDocSetPublisherIdentifier_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-publisher-id", @"value", nil];
//	// verify
//	assertThat(settings.docsetPublisherIdentifier, is(@"value"));
//}
//
//- (void) testDocSetPublisherName_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-publisher-name", @"value", nil];
//	// verify
//	assertThat(settings.docsetPublisherName, is(@"value"));
//}
//
//- (void) testDocSetMinXcodeVersion_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-min-xcode-version", @"value", nil];
//	// verify
//	assertThat(settings.docsetMinimumXcodeVersion, is(@"value"));
//}
//
//- (void) testDocSetPlatformFamily_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-platform-family", @"value", nil];
//	// verify
//	assertThat(settings.docsetPlatformFamily, is(@"value"));
//}
//
//- (void) testDocSetCertificateIssuer_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-cert-issuer", @"value", nil];
//	// verify
//	assertThat(settings.docsetCertificateIssuer, is(@"value"));
//}
//
//- (void) testDocSetCertificateSigner_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-cert-signer", @"value", nil];
//	// verify
//	assertThat(settings.docsetCertificateSigner, is(@"value"));
//}
//
//- (void) testDocSetBundleFilename_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-bundle-filename", @"value", nil];
//	// verify
//	assertThat(settings.docsetBundleFilename, is(@"value"));
//}
//
//- (void) testDocSetAtomFilename_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-atom-filename", @"value", nil];
//	// verify
//	assertThat(settings.docsetAtomFilename, is(@"value"));
//}
//
//- (void) testDocSetXMLFilename_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-xml-filename", @"value", nil];
//	// verify
//	assertThat(settings.docsetXMLFilename, is(@"value"));
//}
//
//- (void) testDocSetPackageFilename_shouldAssignValueToSettings {
//	// setup & execute
//	GBApplicationSettingsProvider *settings = [self settingsByRunningWithArgs:@"--docset-package-filename", @"value", nil];
//	// verify
//	assertThat(settings.docsetPackageFilename, is(@"value"));
//}
//
//#pragma mark Creation methods
//
//- (GBApplicationSettingsProvider *)settingsByRunningWithArgs:(NSString *)first, ... {
//	// Basically this method allows testing whether the application properly maps command line arguments to settings. The method is a hack - it partially duplicates the internal workings of DDGetoptLongParser. First thing it constructs GBAppledocApplication object and injects it custom settings. Then it converts the given list of command line options to appropriate KVC messages and sends them to the application object - it uses DDGetoptLongParser to get the name of the KVC key for each option (some additions were required in order to expose the method that converts arguments to keys). As application more or less maps each command line option to specific property of it's settings, we can then use the injected settings to check whether all properties have correct values.
//	// Note that this might easily be broken if internal workings of DDCli changes. In fact at first I did try to use DDCliRunApplication, but this only worked the first time used, it failed to extract options in all subsequent tests. And even then, DDCli code required some additions so that I was able passing it arbitrary list of arguments. On the other hand, the whole DDCli source code copy is used by appledoc, so any change to it is predictable...
//	// Also note that we could go without changing any of DDCli code by simply using keys instead of command line arguments, but that would make unit tests less obvious... Another way would be to create the code that converts cli argument to key manually, but current solution seemed quite acceptable.
//
//	// get arguments
//	NSMutableArray *arguments = [NSMutableArray array];
//	va_list args;
//	va_start(args, first);
//	for (NSString *arg=first; arg != nil; arg=va_arg(args, NSString*)) {
//		[arguments addObject:arg];
//	}
//	va_end(args);
//	
//	// setup the application and inject settings to it.
//	GBAppledocApplication *application = [[GBAppledocApplication.alloc init] autorelease];
//	GBApplicationSettingsProvider *result = [GBApplicationSettingsProvider provider];
//	[application setValue:result forKey:@"settings"];
//	
//	// send all KVC messages for all options
//	for (NSUInteger i=0; i<[arguments count]; i++) {
//		NSString *arg = [arguments objectAtIndex:i];
//		if ([arg hasPrefix:@"--"]) {
//			// get the key corresponding to the argument
//			NSString *key = [DDGetoptLongParser keyFromOption:arg];
//            
//            // When passed --docset-xml-filename, +[DDGetoptLongParser keyFromOption:] will
//            // return docsetXmlFilename but we need instead of docsetXMLFilename.
//            key = [key stringByReplacingOccurrencesOfString:@"Xml" withString:@"XML"];
//            key = [key stringByReplacingOccurrencesOfString:@"xcrun" withString:@"xCRun"];
//			
//			// if we have a value following, use it for KVC, otherwise just send YES
//			if (i < [arguments count] - 1) {
//				NSString *value = [arguments objectAtIndex:i+1];
//				if (![value hasPrefix:@"--"]) {
//					[application setValue:value forKey:key];
//					i++;
//					continue;
//				}
//			}
//			[application setValue:[NSNumber numberWithBool:YES] forKey:key];
//		}
//	}	
//	
//	// return settings for validation these should now contain all values application passed from KVC messages
//	return result;
//}
//
//- (NSString *)currentPath {
//	return [[NSFileManager defaultManager] currentDirectoryPath];
//}
//
//@end
