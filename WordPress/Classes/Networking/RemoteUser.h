#import <Foundation/Foundation.h>

@interface RemoteUser : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSNumber *primaryBlogID;
@property (nonatomic, strong) NSString *avatarURL;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, assign) BOOL emailVerified;

@end
