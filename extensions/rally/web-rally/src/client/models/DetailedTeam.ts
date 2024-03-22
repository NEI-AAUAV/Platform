/* generated using openapi-typescript-codegen -- do no edit */
/* istanbul ignore file */
/* tslint:disable */
/* eslint-disable */

import type { ListingUser } from './ListingUser';

export type DetailedTeam = {
    id: number;
    name: string;
    total: number;
    classification: number;
    question_scores: Array<boolean>;
    time_scores: Array<number>;
    times: Array<string>;
    pukes: Array<number>;
    skips: Array<number>;
    card1: number;
    card2: number;
    card3: number;
    score_per_checkpoint: Array<number>;
    members: Array<ListingUser>;
};

