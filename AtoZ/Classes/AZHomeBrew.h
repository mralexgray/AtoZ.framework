
@import AtoZUniversal;

typedef NS_ENUM(NSUI, BrewOperationType) {
	BrewOperationNone = 0,
	BrewFormulaeOutdated,
	BrewFormulaeAvailable,
	BrewFormulaeInstalled,
	BrewOperationSearch,
	BrewOperationInfo,
	BrewOperationUpdate,
	BrewOperationUpgrade,
	BrewOperationInstall,
	BrewOperationUninstall,
	BrewOperationDesc
};
typedef NS_OPTIONS(NSUInteger, AZInstallationStatus) {
	AZNotInstalled			= 0,
	AZInstalled				= 1 << 0,
	AZNeedsUpdate			= 1 << 1,
	//	UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
	//	UIViewAutoresizingFlexibleTopMargin	= 1 << 3,
	//	UIViewAutoresizingFlexibleHeight	   = 1 << 4,
	//	UIViewAutoresizingFlexibleBottomMargin = 1 << 5,
	AZInstalledNeedsUpdate 	= AZInstalled|AZNeedsUpdate
};


@interface	AZBrewFormula : BaseModel
@property 						BOOL	 googleGenerated;
@property 					   AZIS	 installStatus;
@property 		 (RONLY) 	 NSS * info;
@property (NATOM,STRNG) 	NSAS * fancyDesc;
@property (NATOM,STRNG) 	 NSS * url,
									     * name,
										  * desc,
										  * version;

+ (instancetype) instanceWithName: (NSS*)name;
@end

//#import "AtoZSingleton/AtoZSingleton.h"

@interface 			 AZHomeBrew : NSTreeController 

@property 		  (RONLY)  NSD * commands;
@property 		  (NATOM) BOOL   shouldExit,
										  shouldLog;
@property 					  NSI   exitCode;
@property (STRNG)  		  NSS * brewPath,
										* savePath;

@property (NATOM, STRNG) NSTN * available;

@property (NATOM, STRNG) NSMD * entriesToAdd;
@property (NATOM, STRNG)  NSD * reference;

-(void) setInfoForFormula:(AZBrewFormula*)formula;

@end
