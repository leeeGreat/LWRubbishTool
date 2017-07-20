//
//  ViewController.m
//  ZCJTemplateTool
//
//  Created by inpark_1 on 2017/2/24.
//  Copyright © 2017年 inpark. All rights reserved.
//

#import "ViewController.h"
#import "MGTemplateEngine.h"
#import "ICUTemplateMatcher.h"

@interface ViewController()

@property (weak) IBOutlet NSTextField *number;

@property (strong) NSArray        *classFirstNameArray;
@property (strong) NSArray        *classSecondNameArray;
@property (strong) NSArray        *letters;
@property (strong) NSMutableSet   *classNameSet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数组的内容自己写
    self.classFirstNameArray = @[@"Myclass1",@"Myclass2",@"Myclass3",@"Myclass4"];
    self.classSecondNameArray = @[@"YourClass1",@"YourClass2",@"YourClass3",@"YourClass4",@"YourClass5",@"YourClass6"];
    self.classNameSet = [NSMutableSet new];
    //英文字母
    self.letters = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    
    
}

- (NSMutableArray *)getFirstMethodParams {
    //拼接参数名
    NSMutableArray *paramsArray = [NSMutableArray new];
    int paramsNumber = (arc4random() % 1) + 4;
    
    for (int i = 0; i < paramsNumber; i ++) {
        //这个参数有多少个字母组成
        int paramLength = (arc4random() % 6) + 2;
        //组成这个参数
        NSString *param;
        for (int j = 0; j < paramLength; j ++) {
            if (param.length == 0) {
                param = self.letters[arc4random() % 26];
            }
            else {
                param = [NSString stringWithFormat:@"%@%@",param,self.letters[arc4random() % 26]];
            }
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:param, @"key", @"NSString", @"value", nil];
        [paramsArray addObject:dic];
    }
    return paramsArray;
}

- (NSMutableArray *)getSecondMethodParams {
    //拼接参数名
    NSMutableArray *paramsArray = [NSMutableArray new];
    
    int paramsNumber = (arc4random() % 1) + 2;
    for (int i = 0; i < paramsNumber; i ++) {
        //这个参数有多少个字母组成
        int paramLength = (arc4random() % 6) + 2;
        //组成这个参数
        NSString *param;
        for (int j = 0; j < paramLength; j ++) {
            if (param.length == 0) {
                param = self.letters[arc4random() % 26];
            }
            else {
                param = [NSString stringWithFormat:@"%@%@",param,self.letters[arc4random() % 26]];
            }
        }
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:param, @"key", @"NSString", @"value", nil];
        [paramsArray addObject:dic];
    }
    return paramsArray;
}

- (NSMutableSet *)getClassName {
    //拼接类名
    NSMutableSet *classNameSet = [NSMutableSet new];
    for (int i = 0; i < self.number.intValue; i ++) {
        int firstName = arc4random() % self.classFirstNameArray.count;
        int secondName = arc4random() % self.classSecondNameArray.count;
        NSString *firstNameString = self.classFirstNameArray[firstName];
        NSString *secondNameString = self.classSecondNameArray[secondName];
        NSString *name =  [NSString stringWithFormat:@"%@%@",firstNameString,secondNameString];
        [classNameSet addObject:name];
    }
    return classNameSet;
}

- (NSMutableArray *)getImporNameArray {
    NSArray *nameArray = [self.classNameSet allObjects];
    NSMutableArray *nameMutableArray = [NSMutableArray new];
    [nameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:nameArray[idx], @"key", @"NSString", @"value", nil];
        [nameMutableArray addObject:dic];
    }];
    return nameMutableArray;
}

- (IBAction)creatImportFile:(id)sender {
    
    if (self.classNameSet.count == 0) {
        return;
    }
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    NSString *templatePath_h = [[NSBundle mainBundle] pathForResource:@"ImportClass_h" ofType:@"txt"];
    NSString *templatePath_m = [[NSBundle mainBundle] pathForResource:@"ImportClass_m" ofType:@"txt"];
    
    NSMutableArray *nameArray = [self getImporNameArray];
    NSDictionary *variable = [NSDictionary dictionaryWithObjectsAndKeys:
                              nameArray, @"ClassName",
                              nil];
    
    NSString *resultH = [engine processTemplateInFileAtPath:templatePath_h withVariables:variable];
    NSString *resultM = [engine processTemplateInFileAtPath:templatePath_m withVariables:variable];
    NSString *bundel=[[NSBundle mainBundle] resourcePath];
    NSString *deskTopLocation=[[bundel substringToIndex:[bundel rangeOfString:@"Library"].location] stringByAppendingFormat:@"Desktop/DummyClasses/Ipt"];
    NSString *pathH = [deskTopLocation stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h", @"ImportClass"]];
    NSString *pathM = [deskTopLocation stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m", @"ImportClass"]];
    BOOL isSuccessH = [resultH writeToFile:pathH atomically:YES encoding:NSUTF8StringEncoding error:nil];
    BOOL isSuccessM = [resultM writeToFile:pathM atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if (isSuccessH && isSuccessM) {
        NSLog(@"success");
    } else {
        NSLog(@"fail");
    }

}

- (IBAction)generateAction:(id)sender {
    
    MGTemplateEngine *engine = [MGTemplateEngine templateEngine];
    [engine setMatcher:[ICUTemplateMatcher matcherWithTemplateEngine:engine]];
    
    NSString *templatePath_h = [[NSBundle mainBundle] pathForResource:@"DummyClass_h" ofType:@"txt"];
    NSString *templatePath_m = [[NSBundle mainBundle] pathForResource:@"DummyClass_m" ofType:@"txt"];
    
    
    if (self.number.intValue == 0) {
        return;
    } else {
        NSMutableSet *classNameSet = [self getClassName];
        self.classNameSet = classNameSet;
        NSEnumerator *enumerator = [classNameSet objectEnumerator];
        NSString *className;
        while (className = [enumerator nextObject]) {
            NSMutableArray *firstParamsArray = [self getFirstMethodParams];
            NSMutableArray *secondParamsArray = [self getSecondMethodParams];
            NSDictionary *variables = [NSDictionary dictionaryWithObjectsAndKeys:
                                       firstParamsArray, @"firstMethodParams",
                                       secondParamsArray, @"secondMethodParams",
                                       className, @"ClassName",
                                       nil];
            NSString *resultH = [engine processTemplateInFileAtPath:templatePath_h withVariables:variables];
            NSString *resultM = [engine processTemplateInFileAtPath:templatePath_m withVariables:variables];
            
            NSString *bundel=[[NSBundle mainBundle] resourcePath];
            NSString *deskTopLocation=[[bundel substringToIndex:[bundel rangeOfString:@"Library"].location] stringByAppendingFormat:@"Desktop/DummyClasses"];
            NSString *pathH = [deskTopLocation stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h", className]];
            NSString *pathM = [deskTopLocation stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m", className]];
            BOOL isSuccessH = [resultH writeToFile:pathH atomically:YES encoding:NSUTF8StringEncoding error:nil];
            BOOL isSuccessM = [resultM writeToFile:pathM atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            if (isSuccessH && isSuccessM) {
                NSLog(@"success");
            } else {
                NSLog(@"fail");
            }
            
        }
    }
}

@end
