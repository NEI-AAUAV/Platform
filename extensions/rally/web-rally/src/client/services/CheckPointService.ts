/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */
import type { DetailedCheckPoint } from '../models/DetailedCheckPoint';
import type { ListingTeam } from '../models/ListingTeam';

import type { CancelablePromise } from '../core/CancelablePromise';
import { OpenAPI } from '../core/OpenAPI';
import { request as __request } from '../core/request';

export class CheckPointService {

    /**
     * Get Checkpoints
     * @returns DetailedCheckPoint Successful Response
     * @throws ApiError
     */
    public static getCheckpointsApiRallyV1CheckpointGet(): CancelablePromise<Array<DetailedCheckPoint>> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/api/rally/v1/checkpoint/',
        });
    }

    /**
     * Get Next Checkpoint
     * Return the next checkpoint a team must head to.
     * @returns DetailedCheckPoint Successful Response
     * @throws ApiError
     */
    public static getNextCheckpointApiRallyV1CheckpointMeGet(): CancelablePromise<DetailedCheckPoint> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/api/rally/v1/checkpoint/me',
        });
    }

    /**
     * Get Checkpoint Teams
     * If a staff is authenticated, returned all teams that just passed
     * through a staff's checkpoint.
     * If an admin is authenticated, returned all teams.
     * @param checkpointId
     * @returns ListingTeam Successful Response
     * @throws ApiError
     */
    public static getCheckpointTeamsApiRallyV1CheckpointTeamsGet(
        checkpointId?: (number | null),
    ): CancelablePromise<Array<ListingTeam>> {
        return __request(OpenAPI, {
            method: 'GET',
            url: '/api/rally/v1/checkpoint/teams',
            query: {
                'checkpoint_id': checkpointId,
            },
            errors: {
                422: `Validation Error`,
            },
        });
    }

}
