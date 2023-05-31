/********************************************************************
 Copyright (C) 2012 Martin Gr‰ﬂlin <mgraesslin@kde.org>
 Copyright (C) 2016 Marco Martin <mart@kde.org>
 Copyright (C) 2016 David Rosca <nowrep@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/
/*global effect, effects, animate, animationTime, Effect*/
var slidingTooltips = {
    duration: animationTime(150),
    loadConfig: function () {
        "use strict";
        slidingTooltips.duration = animationTime(150);
    },
    cleanup: function(window) {
        "use strict";

        delete window.moveAnimation;
        delete window.fadeAnimation;
    },
    geometryChange: function (window, oldGeometry) {
        "use strict";

        //only plasma tooltips
        if (!window.tooltip || window.windowClass != "plasmashell plasmashell") {
            return;
        }

        var newGeometry = window.geometry;

        if (oldGeometry.x == newGeometry.x && oldGeometry.y == newGeometry.y &&
            oldGeometry.width == newGeometry.width && oldGeometry.height == newGeometry.height) {
            return;
        }

        //only do the transition for near enough tooltips,
        //don't cross the whole screen: ugly
        var distance = Math.abs(oldGeometry.x - newGeometry.x) + Math.abs(oldGeometry.y - newGeometry.y);
        if (distance > (newGeometry.width + newGeometry.height) * 2) {
            return;
        }

        //don't resize it "too much", set as four times
        if ((newGeometry.width / oldGeometry.width) > 4 ||
            (oldGeometry.width / newGeometry.width) > 4 ||
            (newGeometry.height / oldGeometry.height) > 4 ||
            (oldGeometry.height / newGeometry.height) > 4) {
            return;
        }

        //WindowForceBackgroundContrastRole
        window.setData(7, true);

        var fromX = oldGeometry.x;
        var fromY = oldGeometry.y;
        var toX = newGeometry.x;
        var toY = newGeometry.y;
        var cancelAnimation = false;

        if (Math.abs(oldGeometry.x - newGeometry.x) < 2 ||
            Math.abs(oldGeometry.x + oldGeometry.width - newGeometry.x - newGeometry.width) < 2) {
            fromX = toX;
            cancelAnimation = true;
        }

        if (Math.abs(oldGeometry.y - newGeometry.y) < 2 ||
            Math.abs(oldGeometry.y + oldGeometry.height - newGeometry.y - newGeometry.height) < 2) {
            fromY = toY;
            cancelAnimation = true;
        }

        if (window.moveAnimation && cancelAnimation) {
            cancel(window.moveAnimation[0]);
            delete window.moveAnimation;
        }

        if (window.moveAnimation) {
            if (window.moveAnimation[0]) {
                retarget(window.moveAnimation[0], {
                        value1: toX,
                        value2: toY
                    }, slidingTooltips.duration);
            }
        } else {
            window.moveAnimation = animate({
                window: window,
                duration: slidingTooltips.duration,
                animations: [{
                    type: Effect.Position,
                    to: {
                        value1: toX,
                        value2: toY
                    },
                    from: {
                        value1: fromX,
                        value2: fromY
                    },
                    sourceAnchor: Effect.Top | Effect.Left,
                    targetAnchor: Effect.Top | Effect.Left
                }]
            });
        }
    },

    init: function () {
        "use strict";
        effect.configChanged.connect(slidingTooltips.loadConfig);
        effects.windowGeometryShapeChanged.connect(slidingTooltips.geometryChange);
        effect.animationEnded.connect(slidingTooltips.cleanup);
    }
};
slidingTooltips.init();
