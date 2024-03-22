/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */

/**
 * The schema returned when listing multiple teams
 */
export type ListingTeam = {
    id: number;
    name: string;
    total: number;
    classification: number;
    num_members: number;
    last_checkpoint_time: (string | null);
    last_checkpoint_score: (number | null);
};

