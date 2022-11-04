
import "./index.css"


const SportMatch = ({ id, x, y, team1, team2, score1, score2, live, horizontal }) => (

    <g transform={`translate(${x} ${y})`} className={"match " + (live ? "-open" : "-pending")} data-identifier="16" data-match-id="288716770">
        <defs>
            <clipPath id="match-clippath-8">
                <rect x="14" y="0" width="280" height="70" rx="10" ry="10"></rect>
            </clipPath>
        </defs>
        <text x="0" y="35" dy="6" width="24" text-anchor="middle" className="match--identifier">{id}</text>
        {live &&
            <rect x="14" y="0" width="284" height="74" rx="10" ry="10" className="match--wrapper-background -underway"></rect>
        }
        <rect x="16" y="2" width="280" height="70" rx="10" ry="10" className="match--base-background"></rect>

        {
            horizontal ?
                <svg x="16" y="2" className="match--player" data-participant-id="179891148">
                    <text x="90" y="55" dy="7" text-anchor="end" className="match--team-name"></text>
                    <image href="NEI_2_white.png" x="25" y="-6" height="82" width="82" />

                    <text x="140" y="35" dy="8" text-anchor="middle" className="match--score">{score1} - {score2}</text>

                    <image href="nei.png" x="173" y="-6" height="82" width="82" />
                    <text x="190" y="55" dy="7" text-anchor="start" className="match--team-name"></text>
                </svg>
                :
                <svg x="16" y="2" className="match--player" data-participant-id="179891148">
                    <text x="50" y="15" dy="7" className="match--team-name">{team1}</text>
                    <image href="NEI_2_white.png" x="7" y="3" height="40" width="40" />

                    <text x="260" y="15" dy="8" text-anchor="middle" className="match--score">{score1}</text>
                    <text x="260" y="50" dy="8" text-anchor="middle" className="match--score">{score2}</text>

                    <image href="NEET.png" x="7" y="33" height="40" width="40" />
                    <text x="50" y="50" dy="7" className="match--team-name">{team2}</text>
                </svg>
        }

        <text x="211" y="59" width="21" height="25" text-anchor="middle" className="match--fa-icon" data-tooltip="Report Scores"></text>
    </g>
);

const SportBracket = () => {
    return (
        <>
            <svg className="bracket-svg" width="900" height="942" viewBox="0 0 900 942">
                <g className="parent">
                    <g>
                        <SportMatch id="0" team1="NAE-ESSUA" team2="NAE-ISCA" score1="10" score2="0" x={0} y={350} horizontal />
                        <SportMatch id="1" team1="Eng. Informática" team2="EET" score1="2" score2="9" x={350} y={350} live />
                        <SportMatch id="2" team1="NEEET" team2="NAE-ISCA" score1="5" score2="0" x={700} y={500} live horizontal />
                        <SportMatch id="3" team1="NMec" team2="NEI" score1="20" score2="90" x={700} y={350} />

                        <g transform="translate(488 260)" className="match -open " data-identifier="7" data-match-id="288716761">
                            <defs>
                                <clipPath id="match-clippath-7">
                                    <rect x="26" y="30" width="200" height="45" rx="10" ry="10">
                                    </rect>
                                </clipPath>
                            </defs>
                            <a className="match--station-link">
                                <rect x="26" y="11" rx="10" ry="10" width="200" height="25" className="match--station-background">
                                </rect>
                                <text x="126" y="24" width="200" height="20" text-anchor="middle" className="match--station">
                                    <tspan dx="4" className="match--fa-icon"></tspan>
                                    <tspan dx="4">Sun  9:09 pm WEST</tspan>
                                </text>
                            </a>
                            <text x="11" y="56" width="24" height="10" text-anchor="middle" className="match--identifier">7</text>
                            <rect x="24" y="28" width="204" height="49" rx="10" ry="10" className="match--wrapper-background -underway">
                            </rect>
                            <rect x="26" y="30" width="200" height="45" rx="10" ry="10" className="match--base-background">
                            </rect>
                            <g clip-path="url(#match-clippath-7)">
                                <svg x="0" y="30" className="match--player" data-participant-id="179891156">
                                    <title>golf</title>
                                    <defs>
                                        <clipPath id="clipPath6193537">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath6193537">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">2</text>
                                    <text clip-path="url(#clipPath6193537)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">golf</text>
                                </svg>
                                <svg x="0" y="53" className="match--player" data-participant-id="179891155">
                                    <title>catia</title>
                                    <defs>
                                        <clipPath id="clipPath7651391">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath7651391">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">7</text>
                                    <text clip-path="url(#clipPath7651391)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">catia</text>
                                    <line x1="26" y1="-0.5" x2="197" y2="-0.5" className="match--player-divider">
                                    </line>
                                </svg>
                            </g>
                            <text x="211" y="59" width="21" height="25" text-anchor="middle" className="match--fa-icon" data-tooltip="Report Scores"></text>
                        </g>
                        <g transform="translate(244 260)" className="match -complete " data-identifier="6" data-match-id="288716760">
                            <defs>
                                <clipPath id="match-clippath-6">
                                    <rect x="26" y="30" width="200" height="45" rx="10" ry="10">
                                    </rect>
                                </clipPath>
                            </defs>
                            <text x="11" y="56" width="24" height="10" text-anchor="middle" className="match--identifier">6</text>
                            <rect x="24" y="28" width="204" height="49" rx="10" ry="10" className="match--wrapper-background ">
                            </rect>
                            <rect x="26" y="30" width="200" height="45" rx="10" ry="10" className="match--base-background">
                            </rect>
                            <g clip-path="url(#match-clippath-6)">
                                <svg x="0" y="30" className="match--player" data-participant-id="179891163">
                                    <title>miro</title>
                                    <defs>
                                        <clipPath id="clipPath7234531">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath7234531">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">3</text>
                                    <text clip-path="url(#clipPath7234531)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">miro</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">0</text>
                                </svg>
                                <svg x="0" y="53" className="match--player" data-participant-id="179891160">
                                    <title>carlota</title>
                                    <defs>
                                        <clipPath id="clipPath8701629">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath8701629">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">8</text>
                                    <text clip-path="url(#clipPath8701629)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name  -winner">carlota</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background -winner">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score -winner">1</text>
                                    <line x1="26" y1="-0.5" x2="226" y2="-0.5" className="match--player-divider">
                                    </line>
                                </svg>
                            </g>
                        </g>
                        <g transform="translate(0 260)" className="match -open " data-identifier="5" data-match-id="288716759">
                            <defs>
                                <clipPath id="match-clippath-5">
                                    <rect x="26" y="30" width="200" height="45" rx="10" ry="10">
                                    </rect>
                                </clipPath>
                            </defs>
                            <text x="11" y="56" width="24" height="10" text-anchor="middle" className="match--identifier">5</text>
                            <rect x="24" y="28" width="204" height="49" rx="10" ry="10" className="match--wrapper-background -underway">
                            </rect>
                            <rect x="26" y="30" width="200" height="45" rx="10" ry="10" className="match--base-background">
                            </rect>
                            <g clip-path="url(#match-clippath-5)">
                                <svg x="0" y="30" className="match--player" data-participant-id="179891147">
                                    <title>ze</title>
                                    <defs>
                                        <clipPath id="clipPath8924670">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath8924670">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">4</text>
                                    <text clip-path="url(#clipPath8924670)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">ze</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">1</text>
                                </svg>
                                <svg x="0" y="53" className="match--player" data-participant-id="179891121">
                                    <title>rauqle</title>
                                    <defs>
                                        <clipPath id="clipPath8261854">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath8261854">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">5</text>
                                    <text clip-path="url(#clipPath8261854)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">rauqle</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">0</text>
                                    <line x1="26" y1="-0.5" x2="226" y2="-0.5" className="match--player-divider">
                                    </line>
                                </svg>
                            </g>
                        </g>
                        <g transform="translate(0 117)" className="match -complete " data-identifier="4" data-match-id="288716758">
                            <defs>
                                <clipPath id="match-clippath-4">
                                    <rect x="26" y="30" width="200" height="45" rx="10" ry="10">
                                    </rect>
                                </clipPath>
                            </defs>
                            <text x="11" y="56" width="24" height="10" text-anchor="middle" className="match--identifier">4</text>
                            <rect x="24" y="28" width="204" height="49" rx="10" ry="10" className="match--wrapper-background ">
                            </rect>
                            <rect x="26" y="30" width="200" height="45" rx="10" ry="10" className="match--base-background">
                            </rect>
                            <g clip-path="url(#match-clippath-4)">
                                <svg x="0" y="30" className="match--player" data-participant-id="179891147">
                                    <title>ze</title>
                                    <defs>
                                        <clipPath id="clipPath9602027">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath9602027">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">4</text>
                                    <text clip-path="url(#clipPath9602027)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">ze</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">0</text>
                                </svg>
                                <svg x="0" y="53" className="match--player" data-participant-id="179891160">
                                    <title>carlota</title>
                                    <defs>
                                        <clipPath id="clipPath3610242">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath3610242">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">8</text>
                                    <text clip-path="url(#clipPath3610242)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">carlota</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">0</text>
                                    <line x1="26" y1="-0.5" x2="226" y2="-0.5" className="match--player-divider">
                                    </line>
                                </svg>
                            </g>
                        </g>
                        <g transform="translate(488 38)" className="match -complete " data-identifier="3" data-match-id="288716757">
                            <defs>
                                <clipPath id="match-clippath-3">
                                    <rect x="26" y="30" width="200" height="45" rx="10" ry="10">
                                    </rect>
                                </clipPath>
                            </defs>
                            <text x="11" y="56" width="24" height="10" text-anchor="middle" className="match--identifier">3</text>
                            <rect x="24" y="28" width="204" height="49" rx="10" ry="10" className="match--wrapper-background ">
                            </rect>
                            <rect x="26" y="30" width="200" height="45" rx="10" ry="10" className="match--base-background">
                            </rect>
                            <g clip-path="url(#match-clippath-3)">
                                <svg x="0" y="30" className="match--player" data-participant-id="179891163">
                                    <title>miro</title>
                                    <defs>
                                        <clipPath id="clipPath4906868">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath4906868">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">3</text>
                                    <text clip-path="url(#clipPath4906868)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">miro</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">0</text>
                                </svg>
                                <svg x="0" y="53" className="match--player" data-participant-id="179891155">
                                    <title>catia</title>
                                    <defs>
                                        <clipPath id="clipPath926509">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath926509">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">7</text>
                                    <text clip-path="url(#clipPath926509)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">catia</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">0</text>
                                    <line x1="26" y1="-0.5" x2="226" y2="-0.5" className="match--player-divider">
                                    </line>
                                </svg>
                            </g>
                        </g>
                        <g transform="translate(244 38)" className="match -complete " data-identifier="2" data-match-id="288716756">
                            <defs>
                                <clipPath id="match-clippath-2">
                                    <rect x="26" y="30" width="200" height="45" rx="10" ry="10">
                                    </rect>
                                </clipPath>
                            </defs>
                            <text x="11" y="56" width="24" height="10" text-anchor="middle" className="match--identifier">2</text>
                            <rect x="24" y="28" width="204" height="49" rx="10" ry="10" className="match--wrapper-background ">
                            </rect>
                            <rect x="26" y="30" width="200" height="45" rx="10" ry="10" className="match--base-background">
                            </rect>
                            <g clip-path="url(#match-clippath-2)">
                                <svg x="0" y="30" className="match--player" data-participant-id="179891156">
                                    <title>golf</title>
                                    <defs>
                                        <clipPath id="clipPath7530644">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath7530644">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">2</text>
                                    <text clip-path="url(#clipPath7530644)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">golf</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">0</text>
                                </svg>
                                <svg x="0" y="53" className="match--player" data-participant-id="179891120">
                                    <title>diog</title>
                                    <defs>
                                        <clipPath id="clipPath1643341">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath1643341">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">6</text>
                                    <text clip-path="url(#clipPath1643341)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name  -winner">diog</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background -winner">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score -winner">0</text>
                                    <line x1="26" y1="-0.5" x2="226" y2="-0.5" className="match--player-divider">
                                    </line>
                                </svg>
                            </g>
                        </g>
                        <g transform="translate(0 38)" className="match -complete " data-identifier="1" data-match-id="288716755">
                            <defs>
                                <clipPath id="match-clippath-1">
                                    <rect x="26" y="30" width="200" height="45" rx="10" ry="10">
                                    </rect>
                                </clipPath>
                            </defs>
                            <text x="11" y="56" width="24" height="10" text-anchor="middle" className="match--identifier">1</text>
                            <rect x="24" y="28" width="204" height="49" rx="10" ry="10" className="match--wrapper-background ">
                            </rect>
                            <rect x="26" y="30" width="200" height="45" rx="10" ry="10" className="match--base-background">
                            </rect>
                            <g clip-path="url(#match-clippath-1)">
                                <svg x="0" y="30" className="match--player" data-participant-id="179891148">
                                    <title>epofro</title>
                                    <defs>
                                        <clipPath id="clipPath7170799">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath7170799">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">1</text>
                                    <text clip-path="url(#clipPath7170799)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">epofro</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">0</text>
                                </svg>
                                <svg x="0" y="53" className="match--player" data-participant-id="179891121">
                                    <title>rauqle</title>
                                    <defs>
                                        <clipPath id="clipPath3646008">
                                            <rect x="50" y="0" width="143" height="22">
                                            </rect>
                                        </clipPath>
                                        <clipPath id="portraitClipPath3646008">
                                            <path>
                                            </path>
                                        </clipPath>
                                    </defs>
                                    <path d="M 50 0 h 147 v 22 h -147 Z" className="match--player-background">
                                    </path>
                                    <path d="M 26 0 h 24 v 22 h -24 Z" className="match--seed-background">
                                    </path>
                                    <text x="38" y="14" width="10" height="12" text-anchor="middle" className="match--seed">5</text>
                                    <text clip-path="url(#clipPath3646008)" x="55" y="15" width="147" height="12" text-anchor="start" className="match--team-name ">rauqle</text>
                                    <path d="M 197 0 h 29 v 22 h -29 Z" className="match--player-score-background ">
                                    </path>
                                    <text x="211" y="15" width="21" height="12" text-anchor="middle" className="match--player-score ">0</text>
                                    <line x1="26" y1="-0.5" x2="226" y2="-0.5" className="match--player-divider">
                                    </line>
                                </svg>
                            </g>
                        </g>
                    </g>
                    <g className="round-headers">
                        <svg className="round-header" y="0">
                            <g className="round-header-label -editable" data-toggle="modal" data-href="/tournaments/11743846/rounds/new_or_edit?number=1&amp;title=Round+1">
                                <text y="25">Round 1</text>
                            </g>
                        </svg>
                        <svg className="round-header" y="222.1065573770492">
                            <g className="round-header-label -editable" data-toggle="modal" data-href="/tournaments/11743846/rounds/new_or_edit?number=2&amp;title=Round+2">
                                <text y="25">Round 2</text>
                            </g>
                        </svg>
                    </g>
                </g>
            </svg>
        </>
    )
}

export default SportBracket;