//
//  CDParseCppTests.mm
//  ClassDumpTests
//
//  Created by Leptos on 1/1/20.
//  Copyright © 2020 Leptos. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "../ClassDump/ClassDump.h"
#import "../ClassDump/Services/CDTypeParser.h"

@interface CDParseCppTests : XCTestCase

@end

@implementation CDParseCppTests

class User {
    char *name;
    unsigned level;
};
class SuperUser : User {
    unsigned permissions;
};

template<class _T>
class BinaryArray {
    _T inlineArray[2];
};

namespace ClassDump {
    class Chocolate {
        float cocoaPercent;
    };
}

- (void)testClass {
    CDParseType *type = [CDTypeParser typeForEncoding:@encode(SuperUser)];
    XCTAssert([[type stringForVariableName:@"var"] isEqualToString:@"struct SuperUser { "
               "char *x0; unsigned int x1; unsigned int x2; "
               "} var"]);
}

- (void)testGenerics {
    CDParseType *type = [CDTypeParser typeForEncoding:@encode(BinaryArray<User>)];
    XCTAssert([[type stringForVariableName:@"var"] isEqualToString:@"struct BinaryArray<User> { "
               "struct User { char *x0; unsigned int x1; } x0[2]; "
               "} var"]);
}

- (void)testNamespace {
    CDParseType *type = [CDTypeParser typeForEncoding:@encode(ClassDump::Chocolate)];
    XCTAssert([[type stringForVariableName:@"var"] isEqualToString:@"struct Chocolate { float x0; } var"]);
    
    type = [CDTypeParser typeForEncoding:@encode(BinaryArray<ClassDump::Chocolate>)];
    XCTAssert([[type stringForVariableName:@"var"] isEqualToString:@"struct BinaryArray<ClassDump::Chocolate> { "
               "struct Chocolate { float x0; } x0[2]; "
               "} var"]);
}

@end
