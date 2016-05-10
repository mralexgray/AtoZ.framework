


got back:var serial = require('serial');
var argparse = require('argparse');
function getArrFromStr(args, kwargs) {
  var output,binStr,inputList;
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["serialData"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("getArrFromStr", __sig__, args, kwargs);
  var serialData = __args__['serialData'];
    try {
output = [];
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 3: output = []");
throw new RuntimeError("line 3: output = []");

}
    try {
inputList = __split_method(serialData, " ");
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 4: inputList = serialData.split(\" \")");
console.error("line 4: inputList = serialData.split(\" \")");
throw new RuntimeError("line 4: inputList = serialData.split(\" \")");

}
  var value,__iterator__0;
  __iterator__0 = __get__(__get__(inputList, "__iter__", "no iterator - line 5: for value in inputList:"), "__call__")([], __NULL_OBJECT__);
  var __next__0;
  __next__0 = __get__(__iterator__0, "next");
  while (( __iterator__0.index ) < __iterator__0.length) {
    value = __next__0();
        try {
binStr = __get__(__get__(bin, "__call__")([__get__(int, "__call__")([value], { base:16 })], __NULL_OBJECT__), "__getslice__")([2, undefined, undefined], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 6: binStr = bin(int(value, base=16))[2:]");
throw new RuntimeError("line 6: binStr = bin(int(value, base=16))[2:]");

}
    var i,__iterator__1;
    var i__end__;
    i = 0;
    i__end__ = (8 - __get__(len, "__call__")([binStr], __NULL_OBJECT__));
    while (( i ) < i__end__) {
            try {
var __left0,__right1;
__left0 = "0";
__right1 = binStr;
binStr = ((( typeof(__left0) ) == "number") ? (__left0 + __right1) : __add_op(__left0, __right1));
      } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 8: binStr = '0' + binStr");
throw new RuntimeError("line 8: binStr = '0' + binStr");

}
      i += 1;
    }
        try {
__get__(__get__(output, "append", "missing attribute `append` - line 9: output.append(binStr)"), "__call__")([binStr], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 9: output.append(binStr)");
throw new RuntimeError("line 9: output.append(binStr)");

}
  }
  return output;
}
;getArrFromStr.is_wrapper = true;
function processDigit(args, kwargs) {
  var bin,decimalPointBool,digitDict,digitValue;
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitNumber", "binArray"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("processDigit", __sig__, args, kwargs);
  var digitNumber = __args__['digitNumber'];
  var binArray = __args__['binArray'];
    try {
decimalPointBool = false;
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 12: decimalPointBool = False");
throw new RuntimeError("line 12: decimalPointBool = False");

}
    try {
digitValue = -1;
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 13: digitValue = -1");
throw new RuntimeError("line 13: digitValue = -1");

}
    try {
bin = [];
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 14: bin = []");
throw new RuntimeError("line 14: bin = []");

}
  if (( digitNumber ) == 4) {
        try {
__get__(__get__(bin, "append", "missing attribute `append` - line 16: bin.append(binArray[2][::-1])"), "__call__")([__get__(((binArray instanceof Array) ? binArray[2] : __get__(binArray, "__getitem__", "line 16: bin.append(binArray[2][::-1])")([2], __NULL_OBJECT__)), "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__)], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 16: bin.append(binArray[2][::-1])");
throw new RuntimeError("line 16: bin.append(binArray[2][::-1])");

}
        try {
__get__(__get__(bin, "append", "missing attribute `append` - line 17: bin.append(binArray[3][::-1])"), "__call__")([__get__(((binArray instanceof Array) ? binArray[3] : __get__(binArray, "__getitem__", "line 17: bin.append(binArray[3][::-1])")([3], __NULL_OBJECT__)), "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__)], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 17: bin.append(binArray[3][::-1])");
throw new RuntimeError("line 17: bin.append(binArray[3][::-1])");

}
  }
  if (( digitNumber ) == 3) {
        try {
__get__(__get__(bin, "append", "missing attribute `append` - line 19: bin.append(binArray[4][::-1])"), "__call__")([__get__(((binArray instanceof Array) ? binArray[4] : __get__(binArray, "__getitem__", "line 19: bin.append(binArray[4][::-1])")([4], __NULL_OBJECT__)), "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__)], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 19: bin.append(binArray[4][::-1])");
throw new RuntimeError("line 19: bin.append(binArray[4][::-1])");

}
        try {
__get__(__get__(bin, "append", "missing attribute `append` - line 20: bin.append(binArray[5][::-1])"), "__call__")([__get__(((binArray instanceof Array) ? binArray[5] : __get__(binArray, "__getitem__", "line 20: bin.append(binArray[5][::-1])")([5], __NULL_OBJECT__)), "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__)], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 20: bin.append(binArray[5][::-1])");
throw new RuntimeError("line 20: bin.append(binArray[5][::-1])");

}
  }
  if (( digitNumber ) == 2) {
        try {
__get__(__get__(bin, "append", "missing attribute `append` - line 22: bin.append(binArray[6][::-1])"), "__call__")([__get__(((binArray instanceof Array) ? binArray[6] : __get__(binArray, "__getitem__", "line 22: bin.append(binArray[6][::-1])")([6], __NULL_OBJECT__)), "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__)], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 22: bin.append(binArray[6][::-1])");
throw new RuntimeError("line 22: bin.append(binArray[6][::-1])");

}
        try {
__get__(__get__(bin, "append", "missing attribute `append` - line 23: bin.append(binArray[7][::-1])"), "__call__")([__get__(((binArray instanceof Array) ? binArray[7] : __get__(binArray, "__getitem__", "line 23: bin.append(binArray[7][::-1])")([7], __NULL_OBJECT__)), "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__)], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 23: bin.append(binArray[7][::-1])");
throw new RuntimeError("line 23: bin.append(binArray[7][::-1])");

}
  }
  if (( digitNumber ) == 1) {
        try {
__get__(__get__(bin, "append", "missing attribute `append` - line 25: bin.append(binArray[8][::-1])"), "__call__")([__get__(((binArray instanceof Array) ? binArray[8] : __get__(binArray, "__getitem__", "line 25: bin.append(binArray[8][::-1])")([8], __NULL_OBJECT__)), "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__)], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 25: bin.append(binArray[8][::-1])");
throw new RuntimeError("line 25: bin.append(binArray[8][::-1])");

}
        try {
__get__(__get__(bin, "append", "missing attribute `append` - line 26: bin.append(binArray[9][::-1])"), "__call__")([__get__(((binArray instanceof Array) ? binArray[9] : __get__(binArray, "__getitem__", "line 26: bin.append(binArray[9][::-1])")([9], __NULL_OBJECT__)), "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__)], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 26: bin.append(binArray[9][::-1])");
throw new RuntimeError("line 26: bin.append(binArray[9][::-1])");

}
  }
  console.log("working with bin");
  console.log(bin);
    try {
digitDict = __get__(dict, "__call__")([], { "js_object":[] });
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 29: digitDict = {}");
throw new RuntimeError("line 29: digitDict = {}");

}
    try {
__get__(__get__(digitDict, "__setitem__"), "__call__")(["A", __get__(int, "__call__")([__get__(__get__(bin, "__getitem__")([0], __NULL_OBJECT__), "__getitem__", "line 30: digitDict['A'] = int(bin[0][0])")([0], __NULL_OBJECT__)], __NULL_OBJECT__)], {});
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 30: digitDict['A'] = int(bin[0][0])");
throw new RuntimeError("line 30: digitDict['A'] = int(bin[0][0])");

}
    try {
__get__(__get__(digitDict, "__setitem__"), "__call__")(["F", __get__(int, "__call__")([__get__(__get__(bin, "__getitem__")([0], __NULL_OBJECT__), "__getitem__", "line 31: digitDict['F'] = int(bin[0][1])")([1], __NULL_OBJECT__)], __NULL_OBJECT__)], {});
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 31: digitDict['F'] = int(bin[0][1])");
throw new RuntimeError("line 31: digitDict['F'] = int(bin[0][1])");

}
    try {
__get__(__get__(digitDict, "__setitem__"), "__call__")(["E", __get__(int, "__call__")([__get__(__get__(bin, "__getitem__")([0], __NULL_OBJECT__), "__getitem__", "line 32: digitDict['E'] = int(bin[0][2])")([2], __NULL_OBJECT__)], __NULL_OBJECT__)], {});
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 32: digitDict['E'] = int(bin[0][2])");
throw new RuntimeError("line 32: digitDict['E'] = int(bin[0][2])");

}
    try {
__get__(__get__(digitDict, "__setitem__"), "__call__")(["B", __get__(int, "__call__")([__get__(__get__(bin, "__getitem__")([1], __NULL_OBJECT__), "__getitem__", "line 33: digitDict['B'] = int(bin[1][0])")([0], __NULL_OBJECT__)], __NULL_OBJECT__)], {});
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 33: digitDict['B'] = int(bin[1][0])");
throw new RuntimeError("line 33: digitDict['B'] = int(bin[1][0])");

}
    try {
__get__(__get__(digitDict, "__setitem__"), "__call__")(["G", __get__(int, "__call__")([__get__(__get__(bin, "__getitem__")([1], __NULL_OBJECT__), "__getitem__", "line 34: digitDict['G'] = int(bin[1][1])")([1], __NULL_OBJECT__)], __NULL_OBJECT__)], {});
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 34: digitDict['G'] = int(bin[1][1])");
throw new RuntimeError("line 34: digitDict['G'] = int(bin[1][1])");

}
    try {
__get__(__get__(digitDict, "__setitem__"), "__call__")(["C", __get__(int, "__call__")([__get__(__get__(bin, "__getitem__")([1], __NULL_OBJECT__), "__getitem__", "line 35: digitDict['C'] = int(bin[1][2])")([2], __NULL_OBJECT__)], __NULL_OBJECT__)], {});
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 35: digitDict['C'] = int(bin[1][2])");
throw new RuntimeError("line 35: digitDict['C'] = int(bin[1][2])");

}
    try {
__get__(__get__(digitDict, "__setitem__"), "__call__")(["D", __get__(int, "__call__")([__get__(__get__(bin, "__getitem__")([1], __NULL_OBJECT__), "__getitem__", "line 36: digitDict['D'] = int(bin[1][3])")([3], __NULL_OBJECT__)], __NULL_OBJECT__)], {});
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 36: digitDict['D'] = int(bin[1][3])");
throw new RuntimeError("line 36: digitDict['D'] = int(bin[1][3])");

}
    try {
digitValue = __get__(getCharFromDigitDict, "__call__")([digitDict], __NULL_OBJECT__);
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 37: digitValue = getCharFromDigitDict(digitDict)");
throw new RuntimeError("line 37: digitValue = getCharFromDigitDict(digitDict)");

}
    try {
decimalPointBool = __get__(bool, "__call__")([__get__(int, "__call__")([__get__(__get__(bin, "__getitem__")([0], __NULL_OBJECT__), "__getitem__", "line 38: decimalPointBool = bool(int(bin[0][3]))")([3], __NULL_OBJECT__)], __NULL_OBJECT__)], __NULL_OBJECT__);
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 38: decimalPointBool = bool(int(bin[0][3]))");
throw new RuntimeError("line 38: decimalPointBool = bool(int(bin[0][3]))");

}
  if (( digitNumber ) == 4) {
        try {
decimalPointBool = false;
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 40: decimalPointBool = False");
throw new RuntimeError("line 40: decimalPointBool = False");

}
  }
  console.log(["decimalPointBool:%d digitValue: %d", decimalPointBool, digitValue]);
  return [decimalPointBool, digitValue];
}
;processDigit.is_wrapper = true;
function getCharFromDigitDict(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("getCharFromDigitDict", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  return null;
}
;getCharFromDigitDict.is_wrapper = true;
function isE(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("isE", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 0 && ( __dict___getitem__([digitDict, "C"], {}) ) == 0 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;isE.is_wrapper = true;
function isN(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("isN", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 0 && ( __dict___getitem__([digitDict, "F"], {}) ) == 0 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 0 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 0 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;isN.is_wrapper = true;
function isL(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("isL", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 0 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 0 && ( __dict___getitem__([digitDict, "B"], {}) ) == 0 && ( __dict___getitem__([digitDict, "C"], {}) ) == 0 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;isL.is_wrapper = true;
function isP(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("isP", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 1 && ( __dict___getitem__([digitDict, "C"], {}) ) == 0 && ( __dict___getitem__([digitDict, "D"], {}) ) == 0 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;isP.is_wrapper = true;
function isF(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("isF", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 0 && ( __dict___getitem__([digitDict, "C"], {}) ) == 0 && ( __dict___getitem__([digitDict, "D"], {}) ) == 0 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;isF.is_wrapper = true;
function isC(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("isC", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 0 && ( __dict___getitem__([digitDict, "B"], {}) ) == 0 && ( __dict___getitem__([digitDict, "C"], {}) ) == 0 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;isC.is_wrapper = true;
function is9(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is9", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 1 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 0)) {
    return true;
  }
  return false;
}
;is9.is_wrapper = true;
function is8(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is8", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 1 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;is8.is_wrapper = true;
function is7(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is7", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 0 && ( __dict___getitem__([digitDict, "G"], {}) ) == 0 && ( __dict___getitem__([digitDict, "B"], {}) ) == 1 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 0 && ( __dict___getitem__([digitDict, "E"], {}) ) == 0)) {
    return true;
  }
  return false;
}
;is7.is_wrapper = true;
function is6(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is6", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 0 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;is6.is_wrapper = true;
function is5(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is5", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 0 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 0)) {
    return true;
  }
  return false;
}
;is5.is_wrapper = true;
function is4(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is4", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 0 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 1 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 0 && ( __dict___getitem__([digitDict, "E"], {}) ) == 0)) {
    return true;
  }
  return false;
}
;is4.is_wrapper = true;
function is3(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is3", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 0 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 1 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 0)) {
    return true;
  }
  return false;
}
;is3.is_wrapper = true;
function is2(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is2", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 0 && ( __dict___getitem__([digitDict, "G"], {}) ) == 1 && ( __dict___getitem__([digitDict, "B"], {}) ) == 1 && ( __dict___getitem__([digitDict, "C"], {}) ) == 0 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;is2.is_wrapper = true;
function is1(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is1", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 0 && ( __dict___getitem__([digitDict, "F"], {}) ) == 0 && ( __dict___getitem__([digitDict, "G"], {}) ) == 0 && ( __dict___getitem__([digitDict, "B"], {}) ) == 1 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 0 && ( __dict___getitem__([digitDict, "E"], {}) ) == 0)) {
    return true;
  }
  return false;
}
;is1.is_wrapper = true;
function is0(args, kwargs) {
  
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["digitDict"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("is0", __sig__, args, kwargs);
  var digitDict = __args__['digitDict'];
  if (__test_if_true__(( __dict___getitem__([digitDict, "A"], {}) ) == 1 && ( __dict___getitem__([digitDict, "F"], {}) ) == 1 && ( __dict___getitem__([digitDict, "G"], {}) ) == 0 && ( __dict___getitem__([digitDict, "B"], {}) ) == 1 && ( __dict___getitem__([digitDict, "C"], {}) ) == 1 && ( __dict___getitem__([digitDict, "D"], {}) ) == 1 && ( __dict___getitem__([digitDict, "E"], {}) ) == 1)) {
    return true;
  }
  return false;
}
;is0.is_wrapper = true;
try {
debug = false;
} catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 149: debug = False");
throw new RuntimeError("line 149: debug = False");

}
function strToFlags(args, kwargs) {
  var flagopts,flags,binArray;
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["strOfBytes"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("strToFlags", __sig__, args, kwargs);
  var strOfBytes = __args__['strOfBytes'];
    try {
flags = [];
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 151: flags = []");
throw new RuntimeError("line 151: flags = []");

}
    try {
binArray = getArrFromStr([strOfBytes], __NULL_OBJECT__);
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 152: binArray = getArrFromStr(strOfBytes)");
throw new RuntimeError("line 152: binArray = getArrFromStr(strOfBytes)");

}
  if (__test_if_true__(debug)) {
    console.log(["strToFlags. strOfBytes: {0}\
 binarray: {1}", strOfBytes, binArray]);
  }
  var index;
  index = 0;
  var binStr,__iterator__2;
  __iterator__2 = __get__(__get__(binArray, "__iter__", "no iterator - line 154: for index, binStr in enumerate(binArray): binArray[index] = binStr[::-1]"), "__call__")([], __NULL_OBJECT__);
  var __next__2;
  __next__2 = __get__(__iterator__2, "next");
  while (( __iterator__2.index ) < __iterator__2.length) {
    binStr = __next__2();
        try {
__get__(__get__(binArray, "__setitem__"), "__call__")([index, __get__(binStr, "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__)], {});
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 154: for index, binStr in enumerate(binArray): binArray[index] = binStr[::-1]");
throw new RuntimeError("line 154: for index, binStr in enumerate(binArray): binArray[index] = binStr[::-1]");

}
    index += 1;
  }
    try {
flagopts = [["AUTO", 0, 0], ["CONTINUITY", 1, 3], ["DIODE", 1, 2], ["LOW BATTERY", 1, 1], ["HOLD", 1, 0], ["MIN", 10, 0], ["REL DELTA", 10, 1], ["HFE", 10, 2], ["Percent", 10, 3], ["SECONDS", 11, 0], ["dBm", 11, 1], ["n (1e-9)", 11, 2], ["u (1e-6)", 11, 3], ["m (1e-3)", 12, 0], ["VOLTS", 12, 1], ["AMPS", 12, 2], ["FARADS", 12, 3], ["M (1e6)", 13, 0], ["K (1e3)", 13, 1], ["OHMS", 13, 2], ["Hz", 13, 3], ["AC", 0, 2]];
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 155: flagopts = [['AUTO', 0, 0],         ['CONTINUITY',1,3],   ['DIODE', 1, 2],");
throw new RuntimeError("line 155: flagopts = [['AUTO', 0, 0],         ['CONTINUITY',1,3],   ['DIODE', 1, 2],");

}
  var flag,__iterator__3;
  __iterator__3 = __get__(__get__(flagopts, "__iter__", "no iterator - line 162: for flag in flagopts:"), "__call__")([], __NULL_OBJECT__);
  var __next__3;
  __next__3 = __get__(__iterator__3, "next");
  while (( __iterator__3.index ) < __iterator__3.length) {
    flag = __next__3();
    if (( __get__(((binArray instanceof Array) ? binArray[((flag instanceof Array) ? flag[1] : __get__(flag, "__getitem__", "line 163: if binArray[flag[1]][flag[2]] == '1': flags.append(flag[0])")([1], __NULL_OBJECT__))] : __get__(binArray, "__getitem__", "line 163: if binArray[flag[1]][flag[2]] == '1': flags.append(flag[0])")([((flag instanceof Array) ? flag[1] : __get__(flag, "__getitem__", "line 163: if binArray[flag[1]][flag[2]] == '1': flags.append(flag[0])")([1], __NULL_OBJECT__))], __NULL_OBJECT__)), "__getitem__", "line 163: if binArray[flag[1]][flag[2]] == '1': flags.append(flag[0])")([((flag instanceof Array) ? flag[2] : __get__(flag, "__getitem__", "line 163: if binArray[flag[1]][flag[2]] == '1': flags.append(flag[0])")([2], __NULL_OBJECT__))], __NULL_OBJECT__) ) == "1") {
            try {
__get__(__get__(flags, "append", "missing attribute `append` - line 163: if binArray[flag[1]][flag[2]] == '1': flags.append(flag[0])"), "__call__")([((flag instanceof Array) ? flag[0] : __get__(flag, "__getitem__", "line 163: if binArray[flag[1]][flag[2]] == '1': flags.append(flag[0])")([0], __NULL_OBJECT__))], __NULL_OBJECT__);
      } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 163: if binArray[flag[1]][flag[2]] == '1': flags.append(flag[0])");
throw new RuntimeError("line 163: if binArray[flag[1]][flag[2]] == '1': flags.append(flag[0])");

}
    }
  }
  return flags;
}
;strToFlags.is_wrapper = true;
function strToDigits(args, kwargs) {
  var digits,minusBool,binArray,out;
  var __sig__,__args__;
  __sig__ = { kwargs:{},args:["strOfBytes"] };
  if (args instanceof Array && ( Object.prototype.toString.call(kwargs) ) == "[object Object]" && ( arguments.length ) == 2) {
    /*pass*/
  } else {
    args = Array.prototype.slice.call(arguments, 0, __sig__.args.length);
    kwargs = {};
  }
  __args__ = __getargs__("strToDigits", __sig__, args, kwargs);
  var strOfBytes = __args__['strOfBytes'];
    try {
binArray = getArrFromStr([strOfBytes], __NULL_OBJECT__);
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 166: binArray = getArrFromStr(strOfBytes)");
throw new RuntimeError("line 166: binArray = getArrFromStr(strOfBytes)");

}
    try {
digits = "";
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 167: digits = \"\"");
throw new RuntimeError("line 167: digits = \"\"");

}
  var number,__iterator__4;
  __iterator__4 = __get__(__get__(__get__(reversed, "__call__")([__get__(range, "__call__")([1, 5], __NULL_OBJECT__)], __NULL_OBJECT__), "__iter__", "no iterator - line 168: for number in reversed(range(1, 5)):"), "__call__")([], __NULL_OBJECT__);
  var __next__4;
  __next__4 = __get__(__iterator__4, "next");
  while (( __iterator__4.index ) < __iterator__4.length) {
    number = __next__4();
        try {
out = processDigit([number, binArray], __NULL_OBJECT__);
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 169: out = processDigit(number, binArray)");
throw new RuntimeError("line 169: out = processDigit(number, binArray)");

}
    if (( ((out instanceof Array) ? out[1] : __get__(out, "__getitem__", "line 170: if out[1] == -1:")([1], __NULL_OBJECT__)) ) == -1) {
      var __left2,__right3;
      __left2 = "Protocol Error: Please start an issue here:                 https://github.com/ddworken/2200087-Serial-Protocol/issues                 and include the following data: '";
      __right3 = strOfBytes;
      var __left4,__right5;
      __left4 = ((( typeof(__left2) ) == "number") ? (__left2 + __right3) : __add_op(__left2, __right3));
      __right5 = "'";
      console.log(((( typeof(__left4) ) == "number") ? (__left4 + __right5) : __add_op(__left4, __right5)));
            try {
__get__(__get__(sys, "exit", "missing attribute `exit` - line 174: sys.exit(1)"), "__call__")([1], __NULL_OBJECT__);
      } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 174: sys.exit(1)");
throw new RuntimeError("line 174: sys.exit(1)");

}
    }
    if (__test_if_true__(((out instanceof Array) ? out[0] : __get__(out, "__getitem__", "line 175: if out[0]:")([0], __NULL_OBJECT__)))) {
      digits += ".";
    }
    digits += __get__(str, "__call__")([((out instanceof Array) ? out[1] : __get__(out, "__getitem__", "line 177: digits += str(out[1])")([1], __NULL_OBJECT__))], __NULL_OBJECT__);
  }
    try {
minusBool = __get__(bool, "__call__")([__get__(int, "__call__")([__get__(__get__(((binArray instanceof Array) ? binArray[0] : __get__(binArray, "__getitem__", "line 178: minusBool = bool(int(binArray[0][::-1][3]))")([0], __NULL_OBJECT__)), "__getslice__")([undefined, undefined, -1], __NULL_OBJECT__), "__getitem__", "line 178: minusBool = bool(int(binArray[0][::-1][3]))")([3], __NULL_OBJECT__)], __NULL_OBJECT__)], __NULL_OBJECT__);
  } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 178: minusBool = bool(int(binArray[0][::-1][3]))");
throw new RuntimeError("line 178: minusBool = bool(int(binArray[0][::-1][3]))");

}
  if (__test_if_true__(minusBool)) {
        try {
var __left6,__right7;
__left6 = "-";
__right7 = digits;
digits = ((( typeof(__left6) ) == "number") ? (__left6 + __right7) : __add_op(__left6, __right7));
    } catch(__exception__) {
console.trace();
console.error(__exception__, __exception__.message);
console.error("line 180: digits = '-' + digits");
throw new RuntimeError("line 180: digits = '-' + digits");

}
  }
  return digits;
}
;strToDigits.is_wrapper = true;
