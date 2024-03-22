export default {
    autoPlay: true,
    background: {
        color: {
            value: "#000000"
        },
        image: "",
        position: "50% 50%",
        repeat: "no-repeat",
        size: "cover",
        opacity: 1
    },
    backgroundMask: {
        composite: "destination-out",
        cover: {
            color: {
                value: "#fff"
            },
            opacity: 1
        },
        enable: false
    },
    defaultThemes: {},
    delay: 0,
    fullScreen: {
        enable: true,
        zIndex: 1
    },
    detectRetina: false,
    duration: 0,
    fpsLimit: 60,
    interactivity: {
        detectsOn: "window",
        events: {
            onClick: {
                enable: false,
                mode: "push"
            },
            onDiv: {
                selectors: "#repulse-div",
                enable: false,
                mode: "repulse",
                type: "circle"
            },
            onHover: {
                enable: true,
                mode: "bubble",
                parallax: {
                    enable: false,
                    force: 2,
                    smooth: 10
                }
            },
            resize: {
                delay: 0.5,
                enable: true
            }
        },
        modes: {
            attract: {
                distance: 200,
                duration: 0.4,
                easing: "ease-out-quad",
                factor: 1,
                maxSpeed: 50,
                speed: 1
            },
            bounce: {
                distance: 200
            },
            bubble: {
                distance: 40,
                duration: 2,
                mix: false,
                opacity: 8,
                size: 6,
                divs: {
                    distance: 200,
                    duration: 0.4,
                    mix: false,
                }
            },
            connect: {
                distance: 80,
                links: {
                    opacity: 0.5
                },
                radius: 60
            },
            grab: {
                distance: 400,
                links: {
                    blink: false,
                    consent: false,
                    opacity: 1
                }
            },
            push: {
                default: true,
                quantity: 4
            },
            remove: {
                quantity: 2
            },
            repulse: {
                distance: 200,
                duration: 0.4,
                factor: 100,
                speed: 1,
                maxSpeed: 50,
                easing: "ease-out-quad",
                divs: {
                    distance: 200,
                    duration: 0.4,
                    factor: 100,
                    speed: 1,
                    maxSpeed: 50,
                    easing: "ease-out-quad",
                }
            },
            slow: {
                factor: 1,
                radius: 0
            },
            trail: {
                delay: 1,
                pauseOnStop: false,
                quantity: 1
            },
            light: {
                area: {
                    gradient: {
                        start: {
                            value: "#ffffff"
                        },
                        stop: {
                            value: "#000000"
                        }
                    },
                    radius: 1000
                },
                shadow: {
                    color: {
                        value: "#000000"
                    },
                    length: 2000
                }
            }
        }
    },
    particles: {
        bounce: {
            horizontal: {
                random: {
                    enable: false,
                    minimumValue: 0.1
                },
                value: 1
            },
            vertical: {
                random: {
                    enable: false,
                    minimumValue: 0.1
                },
                value: 1
            }
        },
        collisions: {
            absorb: {
                speed: 2
            },
            bounce: {
                horizontal: {
                    random: {
                        enable: false,
                        minimumValue: 0.1
                    },
                    value: 1
                },
                vertical: {
                    random: {
                        enable: false,
                        minimumValue: 0.1
                    },
                    value: 1
                }
            },
            enable: false,
            mode: "bounce",
            overlap: {
                enable: true,
                retries: 0
            }
        },
        color: {
            value: "#ffffff",
            animation: {
                h: {
                    count: 0,
                    enable: false,
                    offset: 0,
                    speed: 1,
                    decay: 0,
                    sync: true
                },
                s: {
                    count: 0,
                    enable: false,
                    offset: 0,
                    speed: 1,
                    decay: 0,
                    sync: true
                },
                l: {
                    count: 0,
                    enable: false,
                    offset: 0,
                    speed: 1,
                    decay: 0,
                    sync: true
                }
            }
        },
        move: {
            angle: {
                offset: 0,
                value: 90
            },
            attract: {
                distance: 200,
                enable: false,
                rotate: {
                    x: 600,
                    y: 1200
                }
            },
            center: {
                x: 50,
                y: 50,
                mode: "percent",
                radius: 0
            },
            decay: 0,
            distance: {},
            direction: "none",
            drift: 0,
            enable: true,
            gravity: {
                acceleration: 9.81,
                enable: false,
                inverse: false,
                maxSpeed: 50
            },
            path: {
                clamp: true,
                delay: {
                    random: {
                        enable: false,
                        minimumValue: 0
                    },
                    value: 0
                },
                enable: false,
                options: {}
            },
            outModes: {
                default: "bounce",
                bottom: "bounce",
                left: "bounce",
                right: "bounce",
                top: "bounce"
            },
            random: false,
            size: false,
            speed: 1,
            spin: {
                acceleration: 0,
                enable: false
            },
            straight: false,
            trail: {
                enable: false,
                length: 10,
                fill: {}
            },
            vibrate: false,
            warp: false
        },
        number: {
            density: {
                enable: false,
                width: 1920,
                height: 1080
            },
            limit: 0,
            value: 100
        },
        opacity: {
            random: {
                enable: false,
                minimumValue: 0.1
            },
            value: {
                min: 0.05,
                max: 0.4
            },
            animation: {
                count: 0,
                enable: true,
                speed: 2,
                decay: 0,
                sync: false,
                destroy: "none",
                startValue: "random",
                minimumValue: 0.05
            }
        },
        reduceDuplicates: false,
        shadow: {
            blur: 0,
            color: {
                value: "#000"
            },
            enable: false,
            offset: {
                x: 0,
                y: 0
            }
        },
        shape: {
            options: {},
            type: "circle"
        },
        size: {
            random: {
                enable: true,
                minimumValue: 1
            },
            value: 1,
            animation: {
                count: 0,
                enable: false,
                speed: 40,
                decay: 0,
                sync: false,
                destroy: "none",
                startValue: "random",
                minimumValue: 0.1
            }
        },
        stroke: {
            width: 0
        },
        zIndex: {
            random: {
                enable: false,
                minimumValue: 0
            },
            value: 0,
            opacityRate: 1,
            sizeRate: 1,
            velocityRate: 1
        },
        life: {
            count: 0,
            delay: {
                random: {
                    enable: false,
                    minimumValue: 0
                },
                value: 0,
                sync: false
            },
            duration: {
                random: {
                    enable: false,
                    minimumValue: 0.0001
                },
                value: 0,
                sync: false
            }
        },
        rotate: {
            random: {
                enable: false,
                minimumValue: 0
            },
            value: 0,
            animation: {
                enable: false,
                speed: 0,
                decay: 0,
                sync: false
            },
            direction: "clockwise",
            path: false
        },
        destroy: {
            bounds: {},
            mode: "none",
            split: {
                count: 1,
                factor: {
                    random: {
                        enable: false,
                        minimumValue: 0
                    },
                    value: 3
                },
                rate: {
                    random: {
                        enable: false,
                        minimumValue: 0
                    },
                    value: {
                        min: 4,
                        max: 9
                    }
                },
                sizeOffset: true
            }
        },
        roll: {
            darken: {
                enable: false,
                value: 0
            },
            enable: false,
            enlighten: {
                enable: false,
                value: 0
            },
            mode: "vertical",
            speed: 25
        },
        tilt: {
            random: {
                enable: false,
                minimumValue: 0
            },
            value: 0,
            animation: {
                enable: false,
                speed: 0,
                decay: 0,
                sync: false
            },
            direction: "clockwise",
            enable: false
        },
        twinkle: {
            lines: {
                enable: false,
                frequency: 0.05,
                opacity: 1
            },
            particles: {
                enable: false,
                frequency: 0.05,
                opacity: 1
            }
        },
        wobble: {
            distance: 5,
            enable: false,
            speed: {
                angle: 50,
                move: 10
            }
        },
        orbit: {
            animation: {
                count: 0,
                enable: false,
                speed: 1,
                decay: 0,
                sync: false
            },
            enable: false,
            opacity: 1,
            rotation: {
                random: {
                    enable: false,
                    minimumValue: 0
                },
                value: 45
            },
            width: 1
        },
        links: {
            blink: false,
            color: {
                value: "#ffffff"
            },
            consent: false,
            distance: 40,
            enable: true,
            frequency: 1,
            opacity: 0.4,
            shadow: {
                blur: 5,
                color: {
                    value: "#000"
                },
                enable: false
            },
            triangles: {
                enable: false,
                frequency: 1
            },
            width: 1,
            warp: false
        },
        repulse: {
            random: {
                enable: false,
                minimumValue: 0
            },
            value: 0,
            enabled: false,
            distance: 1,
            duration: 1,
            factor: 1,
            speed: 1
        }
    },
    pauseOnBlur: true,
    pauseOnOutsideViewport: true,
    smooth: false,
    style: {},
    zLayers: 100,
    polygon: {
        draw: {
            enable: true,
            stroke: {
                color: {
                    value: "rgba(255,255,255,0.2)"
                },
                width: 0.5,
                opacity: 0.2
            }
        },
        enable: true,
        inline: {
            arrangement: "equidistant"
        },
        move: {
            radius: 10,
            type: "path"
        },
        scale: 2,
        type: "inline",
        data: {
            path:
                "M112.4 63.2 156.4 81.2 112 240 200.8 203.6 288.8 240 244.8 81.2 289.2 62.8 326 152 288.8 240 200.4 276.8 112 240 75.2 151.6 112.4 63.2 156.4 221.6 200.4 240 244.8 222 289.2 62.8 200.4 99.6 156.4 81.2Z",//"M200.3 118.2A1 1 0 00200.4 230.5 1 1 0 00200.3 118.2M158.5 137Q200.6 155 242.2 137M144.2 173.6 256.4 173.7M158.8 212Q200.5 194.9 242 212M187 119.8Q157.2 173.6 187 228.9M214 119.9Q242.7 173.7 214 228.8M200.3 118.2 200.4 230.5M257.9 238.3 242 215.8 231.1 227.6 219.8 185.9 256.9 209 242 215.8",
            size: {
                width: 400,
                height: 400
            }
        },
    }
}