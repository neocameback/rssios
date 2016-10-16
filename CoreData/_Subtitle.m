// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Subtitle.m instead.

#import "_Subtitle.h"

@implementation SubtitleID
@end

@implementation _Subtitle

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Subtitle" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Subtitle";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Subtitle" inManagedObjectContext:moc_];
}

- (SubtitleID*)objectID {
	return (SubtitleID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic absoluteUrl;

@dynamic createdAt;

@dynamic extension;

@dynamic languageCode;

@dynamic link;

@dynamic name;

@dynamic type;

@dynamic updatedAt;

@dynamic bookmarkedNode;

@dynamic file;

@dynamic rssNode;

@end

@implementation SubtitleAttributes 
+ (NSString *)absoluteUrl {
	return @"absoluteUrl";
}
+ (NSString *)createdAt {
	return @"createdAt";
}
+ (NSString *)extension {
	return @"extension";
}
+ (NSString *)languageCode {
	return @"languageCode";
}
+ (NSString *)link {
	return @"link";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)type {
	return @"type";
}
+ (NSString *)updatedAt {
	return @"updatedAt";
}
@end

@implementation SubtitleRelationships 
+ (NSString *)bookmarkedNode {
	return @"bookmarkedNode";
}
+ (NSString *)file {
	return @"file";
}
+ (NSString *)rssNode {
	return @"rssNode";
}
@end

