// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to File.m instead.

#import "_File.h"

@implementation FileID
@end

@implementation _File

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"File";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"File" inManagedObjectContext:moc_];
}

- (FileID*)objectID {
	return (FileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"downloadedBytesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"downloadedBytes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"expectedBytesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"expectedBytes"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"progressValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"progress"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"state"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic absoluteUrl;

@dynamic createdAt;

@dynamic desc;

@dynamic downloadedBytes;

- (double)downloadedBytesValue {
	NSNumber *result = [self downloadedBytes];
	return [result doubleValue];
}

- (void)setDownloadedBytesValue:(double)value_ {
	[self setDownloadedBytes:@(value_)];
}

- (double)primitiveDownloadedBytesValue {
	NSNumber *result = [self primitiveDownloadedBytes];
	return [result doubleValue];
}

- (void)setPrimitiveDownloadedBytesValue:(double)value_ {
	[self setPrimitiveDownloadedBytes:@(value_)];
}

@dynamic expectedBytes;

- (double)expectedBytesValue {
	NSNumber *result = [self expectedBytes];
	return [result doubleValue];
}

- (void)setExpectedBytesValue:(double)value_ {
	[self setExpectedBytes:@(value_)];
}

- (double)primitiveExpectedBytesValue {
	NSNumber *result = [self primitiveExpectedBytes];
	return [result doubleValue];
}

- (void)setPrimitiveExpectedBytesValue:(double)value_ {
	[self setPrimitiveExpectedBytes:@(value_)];
}

@dynamic name;

@dynamic progress;

- (int16_t)progressValue {
	NSNumber *result = [self progress];
	return [result shortValue];
}

- (void)setProgressValue:(int16_t)value_ {
	[self setProgress:@(value_)];
}

- (int16_t)primitiveProgressValue {
	NSNumber *result = [self primitiveProgress];
	return [result shortValue];
}

- (void)setPrimitiveProgressValue:(int16_t)value_ {
	[self setPrimitiveProgress:@(value_)];
}

@dynamic state;

- (int16_t)stateValue {
	NSNumber *result = [self state];
	return [result shortValue];
}

- (void)setStateValue:(int16_t)value_ {
	[self setState:@(value_)];
}

- (int16_t)primitiveStateValue {
	NSNumber *result = [self primitiveState];
	return [result shortValue];
}

- (void)setPrimitiveStateValue:(int16_t)value_ {
	[self setPrimitiveState:@(value_)];
}

@dynamic thumbnail;

@dynamic type;

@dynamic updatedAt;

@dynamic url;

@dynamic subtitles;

- (NSMutableOrderedSet<Subtitle*>*)subtitlesSet {
	[self willAccessValueForKey:@"subtitles"];

	NSMutableOrderedSet<Subtitle*> *result = (NSMutableOrderedSet<Subtitle*>*)[self mutableOrderedSetValueForKey:@"subtitles"];

	[self didAccessValueForKey:@"subtitles"];
	return result;
}

@end

@implementation _File (SubtitlesCoreDataGeneratedAccessors)
- (void)addSubtitles:(NSOrderedSet<Subtitle*>*)value_ {
	[self.subtitlesSet unionOrderedSet:value_];
}
- (void)removeSubtitles:(NSOrderedSet<Subtitle*>*)value_ {
	[self.subtitlesSet minusOrderedSet:value_];
}
- (void)addSubtitlesObject:(Subtitle*)value_ {
	[self.subtitlesSet addObject:value_];
}
- (void)removeSubtitlesObject:(Subtitle*)value_ {
	[self.subtitlesSet removeObject:value_];
}
- (void)insertObject:(Subtitle*)value inSubtitlesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"subtitles"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subtitles]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subtitles"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"subtitles"];
}
- (void)removeObjectFromSubtitlesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"subtitles"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subtitles]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subtitles"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"subtitles"];
}
- (void)insertSubtitles:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"subtitles"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subtitles]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subtitles"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"subtitles"];
}
- (void)removeSubtitlesAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"subtitles"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subtitles]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subtitles"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"subtitles"];
}
- (void)replaceObjectInSubtitlesAtIndex:(NSUInteger)idx withObject:(Subtitle*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"subtitles"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subtitles]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subtitles"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"subtitles"];
}
- (void)replaceSubtitlesAtIndexes:(NSIndexSet *)indexes withSubtitles:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"subtitles"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self subtitles]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"subtitles"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"subtitles"];
}
@end

@implementation FileAttributes 
+ (NSString *)absoluteUrl {
	return @"absoluteUrl";
}
+ (NSString *)createdAt {
	return @"createdAt";
}
+ (NSString *)desc {
	return @"desc";
}
+ (NSString *)downloadedBytes {
	return @"downloadedBytes";
}
+ (NSString *)expectedBytes {
	return @"expectedBytes";
}
+ (NSString *)name {
	return @"name";
}
+ (NSString *)progress {
	return @"progress";
}
+ (NSString *)state {
	return @"state";
}
+ (NSString *)thumbnail {
	return @"thumbnail";
}
+ (NSString *)type {
	return @"type";
}
+ (NSString *)updatedAt {
	return @"updatedAt";
}
+ (NSString *)url {
	return @"url";
}
@end

@implementation FileRelationships 
+ (NSString *)subtitles {
	return @"subtitles";
}
@end

