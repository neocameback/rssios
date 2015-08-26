// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Rss.m instead.

#import "_Rss.h"

const struct RssAttributes RssAttributes = {
	.createdAt = @"createdAt",
	.rssLink = @"rssLink",
	.rssTitle = @"rssTitle",
	.shouldCache = @"shouldCache",
	.updatedAt = @"updatedAt",
};

const struct RssRelationships RssRelationships = {
	.nodeList = @"nodeList",
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

	if ([key isEqualToString:@"shouldCacheValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"shouldCache"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createdAt;

@dynamic rssLink;

@dynamic rssTitle;

@dynamic shouldCache;

- (BOOL)shouldCacheValue {
	NSNumber *result = [self shouldCache];
	return [result boolValue];
}

- (void)setShouldCacheValue:(BOOL)value_ {
	[self setShouldCache:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveShouldCacheValue {
	NSNumber *result = [self primitiveShouldCache];
	return [result boolValue];
}

- (void)setPrimitiveShouldCacheValue:(BOOL)value_ {
	[self setPrimitiveShouldCache:[NSNumber numberWithBool:value_]];
}

@dynamic updatedAt;

@dynamic nodeList;

- (NSMutableOrderedSet*)nodeListSet {
	[self willAccessValueForKey:@"nodeList"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"nodeList"];

	[self didAccessValueForKey:@"nodeList"];
	return result;
}

@end

@implementation _Rss (NodeListCoreDataGeneratedAccessors)
- (void)addNodeList:(NSOrderedSet*)value_ {
	[self.nodeListSet unionOrderedSet:value_];
}
- (void)removeNodeList:(NSOrderedSet*)value_ {
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
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)removeObjectFromNodeListAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)insertNodeList:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)removeNodeListAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)replaceObjectInNodeListAtIndex:(NSUInteger)idx withObject:(RssNode*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"nodeList"];
}
- (void)replaceNodeListAtIndexes:(NSIndexSet *)indexes withNodeList:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"nodeList"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self nodeList]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"nodeList"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"nodeList"];
}
@end

