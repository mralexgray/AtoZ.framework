

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


@interface 			 AZHomeBrew : NSTreeController <IBSingleton>

@property 		  (RONLY)  NSD * commands;
@property 		  (NATOM) BOOL   shouldExit,
										  shouldLog;
@property 					  NSI   exitCode;
@property (STRNG)  		  NSS * brewPath,
										* savePath;

@property (NATOM, STRNG) NSTN * available;

@property (NATOM, STRNG) NSMD * entriesToAdd;
@property (NATOM, STRNG)  NSD * reference;

-(NSS*) setInfoForFormula:(AZBrewFormula*)formula;

@end
