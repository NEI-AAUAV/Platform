export default {
    "autoPlay": true,
    "background": {
        "color": {
            "value": "#000000"
        },
        "image": "",
        "position": "50% 50%",
        "repeat": "no-repeat",
        "size": "cover",
        "opacity": 1
    },
    "backgroundMask": {
        "composite": "destination-out",
        "cover": {
            "color": {
                "value": "#fff"
            },
            "opacity": 1
        },
        "enable": false
    },
    "defaultThemes": {},
    "delay": 0,
    "fullScreen": {
        "enable": true,
        "zIndex": 0
    },
    "detectRetina": true,
    "duration": 0,
    "fpsLimit": 120,
    "interactivity": {
        "detectsOn": "window",
        "events": {
            "onClick": {
                "enable": false
            },
            "onDiv": {

                "enable": false,
                "type": "circle"
            },
            "onHover": {
                "enable": true,
                "mode": "bubble",
                "parallax": {
                    "enable": false,
                    "force": 2,
                    "smooth": 10
                }
            },
            "resize": true
        },
        "modes": {
            "attract": {
                "distance": 200,
                "duration": 0.4,
                "easing": "ease-out-quad",
                "factor": 1,
                "maxSpeed": 50,
                "speed": 1
            },
            "bounce": {
                "distance": 200
            },
            "bubble": {
                "distance": 40,
                "duration": 2,
                "mix": false,
                "opacity": 8,
                "size": 15,
                "divs": {
                    "distance": 200,
                    "duration": 0.4,
                    "mix": false

                }
            },
            "connect": {
                "distance": 80,
                "links": {
                    "opacity": 0.5
                },
                "radius": 60
            },
            "grab": {
                "distance": 100,
                "links": {
                    "blink": false,
                    "consent": false,
                    "opacity": 1
                }
            },
            "push": {
                "default": true,
                "quantity": 4
            },
            "remove": {
                "quantity": 2
            },
            "repulse": {
                "distance": 200,
                "duration": 0.4,
                "factor": 100,
                "speed": 1,
                "maxSpeed": 50,
                "easing": "ease-out-quad"
            },
            "slow": {
                "factor": 3,
                "radius": 200
            },
            "trail": {
                "delay": 1,
                "pauseOnStop": false,
                "quantity": 1
            },
            "light": {
                "area": {
                    "gradient": {
                        "start": {
                            "value": "#ffffff"
                        },
                        "stop": {
                            "value": "#000000"
                        }
                    },
                    "radius": 1000
                },
                "shadow": {
                    "color": {
                        "value": "#000000"
                    },
                    "length": 2000
                }
            }
        }
    },
    "particles": {
        "bounce": {
            "horizontal": {
                "random": {
                    "enable": false,
                    "minimumValue": 0.1
                },
                "value": 1
            },
            "vertical": {
                "random": {
                    "enable": false,
                    "minimumValue": 0.1
                },
                "value": 1
            }
        },
        "collisions": {
            "absorb": {
                "speed": 2
            },
            "bounce": {
                "horizontal": {
                    "random": {
                        "enable": false,
                        "minimumValue": 0.1
                    },
                    "value": 1
                },
                "vertical": {
                    "random": {
                        "enable": false,
                        "minimumValue": 0.1
                    },
                    "value": 1
                }
            },
            "enable": false,
            "mode": "bounce",
            "overlap": {
                "enable": true,
                "retries": 0
            }
        },
        "color": {
            "value": "#fff",
            "animation": {
                "h": {
                    "count": 0,
                    "enable": false,
                    "offset": 0,
                    "speed": 1,
                    "decay": 0,
                    "sync": true
                },
                "s": {
                    "count": 0,
                    "enable": false,
                    "offset": 0,
                    "speed": 1,
                    "decay": 0,
                    "sync": true
                },
                "l": {
                    "count": 0,
                    "enable": false,
                    "offset": 0,
                    "speed": 1,
                    "decay": 0,
                    "sync": true
                }
            }
        },
        "groups": {},
        "move": {
            "angle": {
                "offset": 0,
                "value": 90
            },
            "attract": {
                "distance": 200,
                "enable": false,
                "rotate": {
                    "x": 3000,
                    "y": 3000
                }
            },
            "center": {
                "x": 50,
                "y": 50,
                "mode": "percent",
                "radius": 0
            },
            "decay": 0,
            "distance": 10,
            "direction": "none",
            "drift": 0,
            "enable": true,
            "gravity": {
                "acceleration": 9.81,
                "enable": false,
                "inverse": false,
                "maxSpeed": 50
            },
            "path": {
                "clamp": true,
                "delay": {
                    "random": {
                        "enable": false,
                        "minimumValue": 0
                    },
                    "value": 0
                },
                "enable": false,
                "options": {}
            },
            "outModes": {
                "default": "out"
            },
            "random": false,
            "size": false,
            "speed": 1,
            "spin": {
                "acceleration": 0,
                "enable": false
            },
            "straight": false,
            "trail": {
                "enable": false,
                "length": 10,
                "fill": {}
            },
            "vibrate": false,
            "warp": false
        },
        "number": {
            "density": {
                "enable": false,
                "width": 1920,
                "height": 1080
            },
            "limit": 0,
            "value": 600
        },
        "opacity": {
            "random": {
                "enable": false,
                "minimumValue": 0.1
            },
            "value": 1,
            "animation": {
                "count": 0,
                "enable": false,
                "speed": 2,
                "decay": 0,
                "sync": false,
                "destroy": "none",
                "startValue": "random"
            }
        },
        "reduceDuplicates": false,
        "shadow": {
            "blur": 0,
            "color": {
                "value": "#000"
            },
            "enable": false,
            "offset": {
                "x": 0,
                "y": 0
            }
        },
        "shape": {
            "options": {},
            "type": ["triangle"]
        },
        "size": {
            "random": {
                "enable": false,
                "minimumValue": 1
            },
            "value": 5,
            "animation": {
                "count": 0,
                "enable": false,
                "speed": 5,
                "decay": 0,
                "sync": false,
                "destroy": "none",
                "startValue": "random"
            }
        },
        "stroke": {
            "width": 0
        },
        "zIndex": 0,
        "life": {
            "count": 0,
            "delay": {
                "random": {
                    "enable": false,
                    "minimumValue": 0
                },
                "value": 0,
                "sync": false
            },
            "duration": {
                "random": {
                    "enable": false,
                    "minimumValue": 0.0001
                },
                "value": 0,
                "sync": false
            }
        },
        "rotate": {
            "random": {
                "enable": false,
                "minimumValue": 0
            },
            "value": 0,
            "animation": {
                "enable": false,
                "speed": 0,
                "decay": 0,
                "sync": false
            },
            "direction": "clockwise",
            "path": false
        },
        "destroy": {
            "bounds": {},
            "mode": "none",
            "split": {
                "count": 1,
                "factor": {
                    "random": {
                        "enable": false,
                        "minimumValue": 0
                    },
                    "value": 3
                },
                "rate": {
                    "random": {
                        "enable": false,
                        "minimumValue": 0
                    },
                    "value": {
                        "min": 4,
                        "max": 9
                    }
                },
                "sizeOffset": true
            }
        },
        "roll": {
            "darken": {
                "enable": false,
                "value": 0
            },
            "enable": false,
            "enlighten": {
                "enable": false,
                "value": 0
            },
            "mode": "vertical",
            "speed": 25
        },
        "tilt": {
            "random": {
                "enable": false,
                "minimumValue": 0
            },
            "value": 0,
            "animation": {
                "enable": false,
                "speed": 0,
                "decay": 0,
                "sync": false
            },
            "direction": "clockwise",
            "enable": false
        },
        "twinkle": {
            "lines": {
                "enable": false,
                "frequency": 0.05,
                "opacity": 1
            },
            "particles": {
                "enable": false,
                "frequency": 0.05,
                "opacity": 1
            }
        },
        "wobble": {
            "distance": 5,
            "enable": false,
            "speed": {
                "angle": 50,
                "move": 10
            }
        },
        "orbit": {
            "animation": {
                "count": 0,
                "enable": false,
                "speed": 1,
                "decay": 0,
                "sync": false
            },
            "enable": false,
            "opacity": 1,
            "rotation": {
                "random": {
                    "enable": false,
                    "minimumValue": 0
                },
                "value": 45
            },
            "width": 1
        },
        "links": {
            "blink": false,
            "color": {
                "value": "#fff"
            },
            "consent": false,
            "distance": 100,
            "enable": false,
            "frequency": 1,
            "opacity": 1,
            "shadow": {
                "blur": 5,
                "color": {
                    "value": "#000"
                },
                "enable": false
            },
            "triangles": {
                "enable": false,
                "frequency": 1
            },
            "width": 1,
            "warp": false
        },
        "repulse": {
            "random": {
                "enable": false,
                "minimumValue": 0
            },
            "value": 0,
            "enabled": false,
            "distance": 1,
            "duration": 1,
            "factor": 1,
            "speed": 1
        }
    },
    "pauseOnBlur": true,
    "pauseOnOutsideViewport": true,
    "smooth": true,
    "style": {},
    "zLayers": 100,
    "canvasMask": {
        "enable": true,
        "override": {
            "color": true,
            "opacity": false
        },
        "pixels": {
            "filter": {},
            "offset": 4
        },
        "position": {
            "x": 50,
            "y": 50
        },
        "scale": 5,
        "image": {
            "src": "https://particles.js.org/images/amongus_cyan.png"
        }
    }
}