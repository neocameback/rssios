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

@dynamic type;

@dynamic updatedAt;

@dynamic url;

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

