

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
@property (NATOM,STRNG) NSAS 	*fancyDesc;
@property (NATOM,STRNG) NSS		*url, *info, *name, *desc, *version;
@property 				BOOL	googleGenerated;
@property 				AZIS	  installStatus;
+ (instancetype) instanceWithName: (NSS*)name;
@end


@interface AZHomeBrew : BaseModel
@property (NATOM) BOOL shouldExit, shouldLog;
@property NSI exitCode;
@property (NATOM, STRNG) NSS  	*brewPath, *savePath;
@property (NATOM, STRNG) NSMA 	*available;
@property (NATOM, STRNG) NSMD 	*entriesToAdd;
@property (NATOM, STRNG) NSD 	*reference;

-(NSS*)setInfoForFormula:(AZBrewFormula*)formula;

@end
