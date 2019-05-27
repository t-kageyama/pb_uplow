//
//  main.m
//  printpb
//
//  Created by Toru Kageyama <info@comona.co.jp> on 2019/05/27.
//  Copyright © 2019 Comon Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONV_NONE			0
#define CONV_LOWER			1
#define CONV_UPPER			2

/**
 * print string.
 * @param str string to convert
 * @param convType 0 to non convert, 1 to lower 2 to upper.
 */
void printString(NSString *str, NSUInteger convType) {
	switch (convType) {
		case CONV_LOWER:
			printf("%s", [[str lowercaseString] UTF8String]);
			break;
		case CONV_UPPER:
			printf("%s", [[str uppercaseString] UTF8String]);
			break;
		default:
			printf("%s", [str UTF8String]);
			break;
	}
}

/**
 * print usage.
 */
static void doUsage() {
	printf("printpb [-c u|l]\n");
}

/**
 * program entry point.
 * @param argc argument count.
 * argv arguments.
 */
int main(int argc, const char * argv[]) {

	NSUInteger convType = CONV_NONE;
	BOOL isInConv = NO;
	BOOL convFound = NO;
	
	for (int i = 0; i < argc; i++) {
		if ((strcmp(argv[i], "-?") == 0) || (strcmp(argv[i], "--help") == 0)) {
			doUsage();
			exit(0);
		}
		else if (strcmp(argv[i], "-c") == 0) {
			if (convFound) {
				doUsage();
				exit(1);
			}
			isInConv = YES;
			convFound = YES;
		}
		else if ((strlen(argv[i]) > 0) && (strncmp(argv[i], "-", 1) == 0)) {
			doUsage();
			exit(1);
		}
		else {
			if (isInConv) {
				if (strcmp(argv[i], "l") == 0) {
					convType = CONV_LOWER;
				}
				else if (strcmp(argv[i], "u") == 0) {
					convType = CONV_UPPER;
				}
				isInConv = NO;
			}
		}
	}

	if (convFound && (convType == CONV_NONE)) {
		doUsage();
		exit(1);
	}

	@autoreleasepool {
		// insert code here...
		PasteboardRef pboard = NULL;
		OSStatus status = PasteboardCreate(kPasteboardClipboard, &pboard);
		if (status == errSecSuccess) {
			ItemCount itemCount = 0;
			PasteboardGetItemCount(pboard, &itemCount);
			if (itemCount > 0) {
				PasteboardItemID itemId = NULL;
				status = PasteboardGetItemIdentifier(pboard, 1, &itemId);
				if (status == errSecSuccess) {
					CFArrayRef flavorTypeArray;
					status = PasteboardCopyItemFlavors(pboard, itemId, &flavorTypeArray);
					if (status == errSecSuccess) {
						CFIndex count = CFArrayGetCount(flavorTypeArray);
						for (CFIndex index = 0; index < count; index++) {
							CFStringRef flavorType = (CFStringRef) CFArrayGetValueAtIndex (flavorTypeArray, index);
							if (UTTypeConformsTo(flavorType, kUTTypeUTF16PlainText)) {
								CFDataRef flavorData = NULL;
								status = PasteboardCopyItemFlavorData(pboard, itemId, flavorType, &flavorData);
								if (status == errSecSuccess) {
									CFStringRef str = CFStringCreateWithBytes(kCFAllocatorDefault, CFDataGetBytePtr(flavorData), CFDataGetLength(flavorData), kCFStringEncodingUTF16, false);
									if (str != NULL) {
										CFRange range;
										range.length = CFStringGetLength(str);
										range.location = 0;
										CFIndex needed = 0;
										CFIndex converted = CFStringGetBytes(str, range, kCFStringEncodingUTF8, '?', false, NULL, 0, &needed);
										if (converted > 0) {
											//NSLog(@"needed: %ld", (long) needed);
											UInt8 *ms = (UInt8 *) calloc(needed, sizeof(UInt8));
											CFIndex written = 0;
											CFStringGetBytes(str, range, kCFStringEncodingUTF8, '?', FALSE, ms, needed, &written);
											NSString *const nsStr = [[NSString alloc] initWithBytes:ms length:written encoding: NSUTF8StringEncoding];
											//NSLog(@"nsStr : %@", nsStr);
											free(ms);
											
											printString([nsStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"], convType);
										}
										
										CFRelease(str);
									}
									CFRelease(flavorData);
								}
								break;
							}
						}
						CFRelease(flavorTypeArray);
					}
				}
			}
			CFRelease(pboard);
		}
	}
	return 0;
}
