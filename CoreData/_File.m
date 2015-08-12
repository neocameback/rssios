// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to File.m instead.

#import "_File.h"

const struct FileAttributes FileAttributes = {
	.createdAt = @"createdAt",
	.desc = @"desc",
	.downloadedBytes = @"downloadedBytes",
	.expectedBytes = @"expectedBytes",
	.name = @"name",
	.type = @"type",
	.updatedAt = @"updatedAt",
	.url = @"url",
};

@implementation FileID
@end

@implementation _File

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
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

	return keyPaths;
}

@dynamic createdAt;

@dynamic desc;

@dynamic downloadedBytes;

- (double)downloadedBytesValue {
	NSNumber *result = [self downloadedBytes];
	return [result doubleValue];
}

- (void)setDownloadedBytesValue:(double)value_ {
	[self setDownloadedBytes:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveDownloadedBytesValue {
	NSNumber *result = [self primitiveDownloadedBytes];
	return [result doubleValue];
}

- (void)setPrimitiveDownloadedBytesValue:(double)value_ {
	[self setPrimitiveDownloadedBytes:[NSNumber numberWithDouble:value_]];
}

@dynamic expectedBytes;

- (double)expectedBytesValue {
	NSNumber *result = [self expectedBytes];
	return [result doubleValue];
}

- (void)setExpectedBytesValue:(double)value_ {
	[self setExpectedBytes:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveExpectedBytesValue {
	NSNumber *result = [self primitiveExpectedBytes];
	return [result doubleValue];
}

- (void)setPrimitiveExpectedBytesValue:(double)value_ {
	[self setPrimitiveExpectedBytes:[NSNumber numberWithDouble:value_]];
}

@dynamic name;

@dynamic type;

@dynamic updatedAt;

@dynamic url;

@end

