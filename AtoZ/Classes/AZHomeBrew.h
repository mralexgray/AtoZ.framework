
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
@property 		 (RO) 	 NSS * info;
@property (NATOM,STR) 	NSAS * fancyDesc;
@property (NATOM,STR) 	 NSS * url,
									     * name,
										  * desc,
										  * version;

+ (instancetype) instanceWithName: (NSS*)name;
@end

//#import "AtoZSingleton/AtoZSingleton.h"

@interface 			 AZHomeBrew : NSTreeController 

@property 		  (RO)  NSD * commands;
@property 		  (NATOM) BOOL   shouldExit,
										  shouldLog;
@property 					  NSI   exitCode;
@property (STR)  		  NSS * brewPath,
										* savePath;

@property (NATOM, STR) NSTN * available;

@property (NATOM, STR) NSMD * entriesToAdd;
@property (NATOM, STR)  NSD * reference;

-(void) setInfoForFormula:(AZBrewFormula*)formula;

@end
