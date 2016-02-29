//
//  YSHttpTool.m
//  iWeibo
//
//  Created by yang on 15/11/16.
//  Copyright © 2015年 yang. All rights reserved.
//

#import "YSHttpTool.h"
#import "AFNetworking.h"


@implementation YSHttpTool

+ (void)POSTWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        !success ? : success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        !failure ? : failure(error);
    }];
}


+ (void)POSTWithURL:(NSString *)url params:(NSDictionary *)params dataArray:(NSArray<YSDataObject *> *)dataArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (YSDataObject *data in dataArray) {
            [formData appendPartWithFileData:data.data name:data.name fileName:data.filename mimeType:data.mimeType];
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        !success ? : success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        !failure ? : failure(error);
    }];
}


+ (void)GETWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        !success ? : success(responseObject);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        !failure ? : failure(error);
    }];
}

@end



@implementation YSDataObject


@end
