// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Node.m instead.

#import "_Node.h"

const struct NodeAttributes NodeAttributes = {
	.bookmarkStatus = @"bookmarkStatus",
	.isAddedToBoomark = @"isAddedToBoomark",
	.isDeletedFlag = @"isDeletedFlag",
	.nodeImage = @"nodeImage",
	.nodeSource = @"nodeSource",
	.nodeTitle = @"nodeTitle",
	.nodeType = @"nodeType",
	.nodeUrl = @"nodeUrl",
};

@implementation NodeID
@end

@implementation _Node

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Node" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Node";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Node" inManagedObjectContext:moc_];
}

- (NodeID*)objectID {
	return (NodeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isAddedToBoomarkValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isAddedToBoomark"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isDeletedFlagValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isDeletedFlag"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic bookmarkStatus;

@dynamic isAddedToBoomark;

- (BOOL)isAddedToBoomarkValue {
	NSNumber *result = [self isAddedToBoomark];
	return [result boolValue];
}

- (void)setIsAddedToBoomarkValue:(BOOL)value_ {
	[self setIsAddedToBoomark:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsAddedToBoomarkValue {
	NSNumber *result = [self primitiveIsAddedToBoomark];
	return [result boolValue];
}

- (void)setPrimitiveIsAddedToBoomarkValue:(BOOL)value_ {
	[self setPrimitiveIsAddedToBoomark:[NSNumber numberWithBool:value_]];
}

@dynamic isDeletedFlag;

- (BOOL)isDeletedFlagValue {
	NSNumber *result = [self isDeletedFlag];
	return [result boolValue];
}

- (void)setIsDeletedFlagValue:(BOOL)value_ {
	[self setIsDeletedFlag:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsDeletedFlagValue {
	NSNumber *result = [self primitiveIsDeletedFlag];
	return [result boolValue];
}

- (void)setPrimitiveIsDeletedFlagValue:(BOOL)value_ {
	[self setPrimitiveIsDeletedFlag:[NSNumber numberWithBool:value_]];
}

@dynamic nodeImage;

@dynamic nodeSource;

@dynamic nodeTitle;

@dynamic nodeType;

@dynamic nodeUrl;

@end

