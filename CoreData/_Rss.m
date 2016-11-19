// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Rss.m instead.

#import "_Rss.h"

@implementation RssID
@end

@implementation _Rss

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
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

	if ([key isEqualToString:@"isBookmarkRssValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isBookmarkRss"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"shouldCacheValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shouldCache"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createdAt;

@dynamic isBookmarkRss;

- (BOOL)isBookmarkRssValue {
	NSNumber *result = [self isBookmarkRss];
	return [result boolValue];
}

- (void)setIsBookmarkRssValue:(BOOL)value_ {
	[self setIsBookmarkRss:@(value_)];
}

- (BOOL)primitiveIsBookmarkRssValue {
	NSNumber *result = [self primitiveIsBookmarkRss];
	return [result boolValue];
}

- (void)setPrimitiveIsBookmarkRssValue:(BOOL)value_ {
	[self setPrimitiveIsBookmarkRss:@(value_)];
}

@dynamic originalTitle;

@dynamic rssLink;

@dynamic rssTitle;

@dynamic shouldCache;

- (BOOL)shouldCacheValue {
	NSNumber *result = [self shouldCache];
	return [result boolValue];
}

- (void)setShouldCacheValue:(BOOL)value_ {
	[self setShouldCache:@(value_)];
}

- (BOOL)primitiveShouldCacheValue {
	NSNumber *result = [self primitiveShouldCache];
	return [result boolValue];
}

- (void)setPrimitiveShouldCacheValue:(BOOL)value_ {
	[self setPrimitiveShouldCache:@(value_)];
}

@dynamic updatedAt;

@dynamic nodeList;

- (NSMutableOrderedSet<RssNode*>*)nodeListSet {
	[self willAccessValueForKey:@"nodeList"];

	NSMutableOrderedSet<RssNode*> *result = (NSMutableOrderedSet<RssNode*>*)[self mutableOrderedSetValueForKey:@"nodeList"];

	[self didAccessValueForKey:@"nodeList"];
	return result;
}

@end

@implementation _Rss (NodeListCoreDataGeneratedAccessors)
- (void)addNodeList:(NSOrderedSet<RssNode*>*)value_ {
	[self.nodeListSet unionOrderedSet:value_];
}
- (void)removeNodeList:(NSOrderedSet<RssNode*>*)value_ {
	[self.nodeListSet minusOrderedSet:value_];
}
- (void)addNodeListObject:(RssNode*)value_ {
	[self.nodeListSet addObject:value_];
}
- (void)removeNodeListObject:(RssNode*)value_ {
	[self.nodeListSet removeObject:value_];
}
- (void)insertObject:(RssNode*)value inNodeListAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)removeObjectFromNodeListAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)insertNodeList:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)removeNodeListAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)replaceObjectInNodeListAtIndex:(NSUInteger)idx withObject:(RssNode*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)replaceNodeListAtIndexes:(NSIndexSet *)indexes withNodeList:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList] ?: [NSOrderedSet orderedSet]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"nodeList"];
}
@end

@implementation RssAttributes 
+ (NSString *)createdAt {
	return @"createdAt";
}
+ (NSString *)isBookmarkRss {
	return @"isBookmarkRss";
}
+ (NSString *)originalTitle {
	return @"originalTitle";
}
+ (NSString *)rssLink {
	return @"rssLink";
}
+ (NSString *)rssTitle {
	return @"rssTitle";
}
+ (NSString *)shouldCache {
	return @"shouldCache";
}
+ (NSString *)updatedAt {
	return @"updatedAt";
}
@end

@implementation RssRelationships 
+ (NSString *)nodeList {
	return @"nodeList";
}
@end

