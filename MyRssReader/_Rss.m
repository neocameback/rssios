// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Rss.m instead.

#import "_Rss.h"

const struct RssAttributes RssAttributes = {
	.rssLink = @"rssLink",
	.rssTitle = @"rssTitle",
};

@implementation RssID
@end

@implementation _Rss

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Rss" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Rss";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Rss" inManagedObjectContext:moc_];
}

- (RssID*)objectID {
	return (RssID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic rssLink;

@dynamic rssTitle;

@end

