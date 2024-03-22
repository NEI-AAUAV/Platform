/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { DetailedUser } from '../models/DetailedUser';
import type { UserUpdate } from '../models/UserUpdate';

import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';

export class UserService {

    /**
     * Get Users
     * @returns DetailedUser Successful Response
     * @throws ApiError
     */
    public static getUsersApiRallyV1UserGet(): CancelablePromise<Array<DetailedUser>> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/api/rally/v1/user/',
        });
    }

    /**
     * Get Me
     * @returns DetailedUser Successful Response
     * @throws ApiError
     */
    public static getMeApiRallyV1UserMeGet(): CancelablePromise<DetailedUser> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/api/rally/v1/user/me',
        });
    }

    /**
     * Update User
     * @param id
     * @param requestBody
     * @returns DetailedUser Successful Response
     * @throws ApiError
     */
    public static updateUserApiRallyV1UserIdPut(
        id: number,
        requestBody: UserUpdate,
    ): CancelablePromise<DetailedUser> {
        return __request(OpenAPI, {
            method: 'PUT',
            url: '/api/rally/v1/user/{id}',
            path: {
                'id': id,
            },
            body: requestBody,
            mediaType: 'application/json',
            errors: {
                422: `Validation Error`,
            },
        });
    }

}
