
const config = {
    "background": {
        "color": {
            "value": "#fff"
        }
    },
    "fullScreen": {
        "enable": true,
        "zIndex": 0
    },
    "interactivity": {
        "detect_on": "window",
        "events": {
            "onClick": {
                "mode": "push"
            },
            "onHover": {
                "enable": true,
                "mode": "repulse",
                "parallax": {
                    "force": 1
                }
            }
        },
        "modes": {
            "repulse": {
                "distance": 100
            }
        }
    },
    "motion": {
        "reduce": {
            "factor": 10,
            "value": false
        }
    },
    "particles": {
        "bounce": {
            "horizontal": {
                "random": {
                    "enable": true
                },
                "value": {
                    "min": 0.1,
                    "max": 1
                }
            },
            "vertical": {
                "random": {
                    "enable": true
                },
                "value": {
                    "min": 0.1,
                    "max": 1
                }
            }
        },
        "color": {
            "value": "#147a26",
            "animation": {
                "h": {
                    "speed": 20
                }
            }
        },
        "links": {
            "color": {
                "value": "#ffffff"
            },
            "opacity": 0.4
        },
        "move": {
            "enable": true,
            "gravity": {
                "acceleration": 1
            },
            "path": {},
            "outModes": {
                "bottom": "out",
                "left": "out",
                "right": "out",
                "top": "out"
            },
            "speed": 2
        },
        "number": {
            "density": {
                "enable": true,
                "area": 1250
            },
            "value": 80
        },
        "opacity": {
            "random": {
                "enable": true,
                "minimumValue": 0.6
            },
            "value": {
                "min": 0.6,
                "max": 1
            },
            "animation": {
                "speed": 1
            }
        },
        "shape": {
            "type": "triangle"
        },
        "size": {
            "random": {
                "enable": true,
                "minimumValue": 2
            },
            "value": {
                "min": 2,
                "max": 3
            }
        }
    }
};

export default config;