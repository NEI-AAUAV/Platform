import bg from 'assets/images/nei-outline.svg';

export default {
    autoPlay: true,
    // background: {
    //     color: {
    //         value: "transparent"
    //     },
    //     image: "",
    //     position: "50% 50%",
    //     repeat: "no-repeat",
    //     size: "80%",
    //     opacity: 1,
    //     image: `url(${bg})`
    // },
    defaultThemes: {},
    delay: 0,
    fullScreen: {
        enable: false,
        zIndex: 1
    },
    detectRetina: false,
    duration: 0,
    fpsLimit: 60,
    pauseOnBlur: true,
    interactivity: {
        detectsOn: "window",
        resize: false,
        events: {
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
            // attract: {
            //     distance: 150,
            //     duration: 0.4,
            //     easing: "ease-out-quad",
            //     factor: 1,
            //     maxSpeed: 50,
            //     speed: 0.3
            // },
            bounce: {
                distance: 150
            },
            bubble: {
                distance: 50,
                duration: 2,
                mix: false,
                opacity: 8,
                size: 6,
            },
            // connect: {
            //     distance: 80,
            //     links: {
            //         opacity: 0.5
            //     },
            //     radius: 60,
                
            // },
            // push: {
            //     default: true,
            //     // groups: {},
            //     quantity: 4
            // },
            // remove: {
            //     quantity: 2
            // },
            // repulse: {
            //     distance: 150,
            //     duration: 0.4,
            //     factor: 100,
            //     speed: 0.3,
            //     maxSpeed: 50,
            //     easing: "ease-out-quad",
            //     divs: {
            //         distance: 150,
            //         duration: 0.4,
            //         factor: 100,
            //         speed: 0.3,
            //         maxSpeed: 50,
            //         easing: "ease-out-quad",
            //         // selectors: {}
            //     }
            // },
            // slow: {
            //     factor: 1,
            //     radius: 0
            // },
            // trail: {
            //     delay: 1,
            //     pauseOnStop: false,
            //     quantity: 1
            // },
            // light: {
            //     area: {
            //         gradient: {
            //             start: {
            //                 value: "#ffffff"
            //             },
            //             stop: {
            //                 value: "#000000"
            //             }
            //         },
            //         radius: 1000
            //     },
            //     shadow: {
            //         color: {
            //             value: "#000000"
            //         },
            //         length: 2000
            //     }
            // }
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
            value: "#548786", //"rgb(90, 183, 125)",
            animation: {
                h: {
                    count: 0,
                    enable: false,
                    offset: 0,
                    speed: 0.3,
                    decay: 0,
                    sync: true
                },
                s: {
                    count: 0,
                    enable: false,
                    offset: 0,
                    speed: 0.3,
                    decay: 0,
                    sync: true
                },
                l: {
                    count: 0,
                    enable: false,
                    offset: 0,
                    speed: 0.3,
                    decay: 0,
                    sync: true
                }
            }
        },
        groups: {},
        move: {
            angle: {
                offset: 0,
                value: 90
            },
            attract: {
                distance: 150,
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
            speed: 0.3,
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
            value: 400
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
        reduceDuplicates: true,
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
            value: 4,
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
                speed: 0.3,
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
                value: "#fff"
            },
            consent: false,
            distance: 30,
            enable: true,
            frequency: 1,
            opacity: 1,
            shadow: {
                blur: 5,
                color: {
                    value: "#000"
                },
                enable: false
            },
            triangles: {
                enable: true,
                frequency: 1
            },
            width: 3,
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
            speed: 0.3
        }
    },
    polygon: {
        draw: {
            enable: true,
            stroke: {
                color: {
                    value: "rgb(255,255,255)"
                },
                width: 3,
                opacity: 0
            }
        },
        enable: true,
        inline: {
            arrangement: "equidistant"
        },
        move: {
            radius: 3,
            type: "radius"
        },
        scale: 2,
        type: "inline",
        data: {
            path:
                "m112.4 63.2 44 18-44.4 158.8 88.8-36.4 88 36.4-44-158.8 44.4-18.4 36.8 89.2-37.2 88-88.4 36.8-88.4-36.8-36.8-88.4 37.2-88.4 44 158.4 44 18.4 44.4-18 44.4-159.2-88.8 36.8-44-18.4zm28.2 101c3.5-18.5 13.2-32.9 29.6-42.4 35.4-20.7 81.3 0 89.5 40.2.1.7.2 1.3.4 2.2 0 .5.1.7.1 1.1 0 .4 0 .7-.1 1.1-3.1 10.6-6 21.1-9 31.5-2.5-1.8-2.8-3.2-2-5.9 1.2-4.5 2.3-9 3.4-13.7-16.3 0-32 0-47.6 0 0 6.9 0 13.7 0 20.5 2.4.2 4.6.3 6.8.5 2.6.2 4.2 1.5 4.5 3.6.3 2.3-.8 4-3.5 4.9-.5 0-.8.1-1.3.2-.3 0-.5 0-.8-.2-3.1-1.4-6.2-2.8-9.3-4.1-.7-.2-1.6 0-2.4.2-2.1.8-4.3 1.7-6.4 2.6-.9.4-1.7 1-2.6 1.6-.2 0-.3 0-.5 0-.5.1-.8.2-1.3.4-1.8.5-3.5.9-5.3 1.5-2.5 1.3-5 2.5-7.6 3.5-.4-.7-.7-1.3-1-2.1-2.5.8-4.9 1.5-7.4 2.3 1 1 1.9 1.7 2.5 2.5-3.1 1.2-6 2.3-9 3.4-2.2-2.1-4.2-4-6.2-6.1-.3-.5-.5-.9-.8-1.4 0-.6 0-1.1-.1-1.6-2.2-7.9-4.5-15.7-6.7-23.6-2-7.3-3.9-14.6-5.9-22 0-.3 0-.5 0-.7m14.9 36c1.5 2.3 3 4.6 4.4 6.7 4.1-1.4 7.9-2.6 11.2-3.7-1.2-8.5-2.4-16.6-3.6-24.9-6 0-12.3 0-18.8 0 .6 7.8 2.8 15 6.8 21.9m74.5-54.4c-.2.6-.7 1.3-.6 1.8.5 2.7 1.2 5.4 1.6 8.1.6 4.5 1 9 1.5 13.6 6.5 0 12.9 0 19.4 0-.9-9.5-4.2-17.9-9.6-25.5-.9-1.2-1.7-1.4-3.1-.9-2.9 1.1-5.9 1.9-9.2 2.9m-72.9.1c-4.7 7.1-7.5 14.9-8.3 23.5 6.5 0 12.8 0 18.9 0 1.2-7.8 2.4-15.4 3.5-23-2.6-.9-5.4-1.7-8.1-2.7-3.7-1.3-3.7-1.3-6 2.2m24.7 32.3c-1.7 0-3.3 0-5.1 0 .2 7.9 1.4 15.4 3.4 22.7 5.4-.7 10.6-1.4 15.7-2 0-7 0-13.8 0-20.7-4.6 0-9.1 0-14 0m22.9-19.6c0 3.6 0 7.2 0 10.7 6.5 0 12.6 0 19.3 0-1-7.2-2-14.1-3-21.1-5.8.7-11 1.3-16.3 1.9 0 2.7 0 5.4 0 8.5m-27.1 2.4c-.3 2.8-.6 5.5-.9 8.4 6.6 0 12.8 0 19.1 0 0-6.5 0-12.9 0-19.2-5.3-.6-10.5-1.1-16-1.7-.7 4-1.4 8.1-2.2 12.5m11.4-36.4c-2.2 5-4.4 10-6.9 15.5 5.1.4 9.4.9 13.7 1.3 0-6.5 0-12.5 0-19-2.4.7-4.5 1.3-6.8 2.2m15.7 14.5c0 .6.1 1.2.1 2.2 4.5-.5 8.8-1 13.5-1.5-2.1-4.7-4-9-6.1-13.3-1.5-3.3-3.5-4.1-7.5-3.4 0 5.2 0 10.4 0 16m-37.6-3.1c2.2.7 4.5 1.4 6.8 2.1 1.3-3.5 2.6-6.8 3.8-10-.2-.2-.3-.3-.5-.5-3.4 2.4-6.7 4.7-10.1 7.1-.3.2-.2.8 0 1.3m58.6-.5c.3.7.6 1.4.9 2.3 1.4-.4 2.7-.7 3.9-1.1 1.3-.3 2.5-.8 4.4-1.4-4.3-2.8-8.1-5.3-11.9-7.9-.1.2-.2.3-.4.5 1 2.4 2 4.9 3.1 7.6zm34.6 28.8c.1.3.1.5 0 .8-.1-.2-.2-.4-.2-.7 0-.2.2-.1.2-.1zm-99.9 55.3c2.9-1.1 5.8-2.2 9-3.4.4 0 .6 0 .8.2 2.6 1.6 5.1 3.2 7.6 4.7.1-.1.2-.2.3-.4-1-2.3-2.1-4.7-3-7.1 0 0 .1 0 .1 0 2.6-1.1 5.1-2.3 7.7-3.5 2 4.1 3.8 8.2 5.8 12.3 1.5 3.1 3.7 4 7.2 3.2 0-5.9 0-11.8 0-17.5-2.1 0-4 0-5.9 0 .8-.6 1.6-1.2 2.5-1.6 2.1-.9 4.3-1.8 6.4-2.6.8-.2 1.7-.4 2.4-.2 3.1 1.3 6.2 2.7 9.2 4.1-1.9.1-3.7 0-5.6-.1 0 6.2 0 12.1 0 18.5 4.1-.9 7.9-1.8 11.7-2.8 2.2-.6 4.2-.7 5.8 1.1 1.4 1.6 1.3 3.6-.1 6-1.5.6-3.1 1.2-4.9 1.9-11.4 3.2-22.6 3.2-33.7.2-4.2-1.8-8.3-3.5-12.8-5.4-3.6-2.5-7-4.9-10.5-7.3 0-.1 0-.3 0-.3zm96.8 7.1c.3.2.6.5 1.1.8 1.3 1.9 2.7 3.6 3.6 5.5.8 1.8 1.5 3.8 1.5 5.8.1 3.4-3.5 6.1-6.7 4.9-2.2-.8-4.4-2.2-5.8-3.9-3.6-4.5-6.8-9.3-10.2-13.9-.3-.4-.6-.8-1.1-1.4-1.8 2.2-3.6 4.2-5.3 6.3-1.8 2.3-6.8 2.1-7.4-1.8 5-2.2 9.8-4.1 14.6-6.1.9-.4 1.7-1.1 2.6-1.6.2 0 .3 0 .5.1 4.2 1.8 8.4 3.6 12.6 5.3zm-30.7 1.3c-1.4-5-2.7-10-3.8-15.1 3.3 1 6.4 2.1 9.6 3.4.3.7.5 1.3.8 2.2.5-.7.9-1.1 1.3-1.3 3.2 1.4 6.4 2.8 9.6 4.1-.8.5-1.6 1.2-2.5 1.6-4.8 2-9.6 3.9-14.5 5.9-.3-.2-.4-.4-.5-.8zm-73.2-15.9c-4.1-4.2-6.9-9.5-9.2-15-4.2-10.2-5.3-20.8-3.6-31.9 2.1 7.1 4 14.4 6 21.7 2.2 7.9 4.5 15.7 6.7 23.6.1.5.1 1 .1 1.6zm98.2-13.7c-.2-.1-.2-.2-.3-.4 2.9-10.5 5.8-21 8.9-31.6.3 4.3 1.1 8.7.6 13.1-.5 5-1.8 10-3.1 14.9-.9 3.5-2.4 4.2-6.1 4zm-62.1 9.7c-.2.1-.5.3-1 .4.2-.2.5-.3 1-.4zm61.1-8c0 0 .1 0 .2 0 2.5 1.5 4.8 3.2 7.3 4.7 1.8 1.2 3.3 2.6 3 5.1-.3 2.3-1.9 3.3-3.8 4-2.2.8-4.4 1.8-6.8 2.8 2.3 3.3 4.5 6.5 6.8 9.8-4.2-1.5-8.4-3.3-12.5-5.2 1.9-7.2 3.8-14.2 5.8-21.2zm-.1-.1c-1.9 7.1-3.8 14.1-5.8 21.2-.2.1-.3.1-.5.1-3.3-1.3-6.5-2.7-9.6-4.3 2.8-5 7.7-6.6 12.9-8.5-6.9-4.5-13.5-8.7-20.5-13.3 1.9 7.3 3.6 14.1 5.3 21-3.1-1.2-6.2-2.3-9.4-3.4-.2-.1-.3-.2-.4-.3-2.2-8.5-4.4-16.8-6.6-25.1-.8-3.5.8-6.2 4-6.2 1.1 0 2.3.5 3.3 1.1 9.1 5.8 18.1 11.7 27.3 17.7z",
            size: {
                width: 400,
                height: 400
            }
        },
        // position: {
        //     x: 0,
        //     y: 0
        // },
    },

}