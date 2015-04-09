
//  NSBag.h
//  AtoZ
//
//  Created by Alex Gray on 9/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

  _Kind           NSBag _ NObj

+ _Kind_   bagWithArray _ _List_ a ___
+ _Kind_            bag ___
+ _Kind_ bagWithObjects _ z __ ... ___

- _Void_            add _ x ___
- _Void_     addObjects _ z __ ... ___

- _Void_         remove _ x ___
- _SInt_  occurrencesOf _ x ___

_RO _List objects __ uniqueObjects __ sortedObjects ___

@Stop

