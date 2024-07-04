import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { NotificationPopups } from "./notification.js"
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const Logo = Widget.Icon({
    class_name: 'logo',
    icon: '/home/brynleyl/.config/ags/logo.png',
});

const Workspaces = Widget.Box({
    class_name: 'workspaces',
    children: Hyprland.bind('workspaces').transform(ws => {
        const sortedWs = ws.sort((a, b) => a.id - b.id);
        return sortedWs.map(({ id }) => Widget.Button({
            on_clicked: () => Hyprland.sendMessage(`dispatch workspace ${id}`),
            child: Widget.Label(`${id}`),
            class_name: Hyprland.active.workspace.bind('id')
                .transform(i => `${i === id ? 'focused' : ''}`),
        }));
    }),
});

const Active = Widget.Label({
    class_name: 'active',
    truncate: 'end',
    maxWidthChars: "64",
    label: Hyprland.active.client.bind('title'),
    visible: Hyprland.active.client.bind('title').as(title => title.length > 0),
});

const Media = Widget.Button({
    class_name: 'media',
    onClicked: () => Mpris.getPlayer('')?.playPause(),
    on_scroll_up: () => Mpris.getPlayer('')?.next(),
    on_scroll_down: () => Mpris.getPlayer('')?.previous(),
    child: Widget.Label({
        truncate: 'end',
        maxWidthChars: '32',
        label: '-',
    }).hook(Mpris, self => {
        if (Mpris.players[0]) {
            const { track_artists, track_title } = Mpris.players[0];
            self.label = `${track_artists.join(', ')} - ${track_title}`;
        } else {
            self.label = 'Nothing is playing';
        }
    }, 'player-changed'),
    visible: Mpris.bind('players').as(p => !!p.length),
});

const Tray = Widget.Box({
    class_name: 'tray',
    children: SystemTray.bind('items').transform(items => {
        return items.map(item => Widget.Button({
            child: Widget.Icon({ binds: [['icon', item, 'icon']] }),
            on_primary_click: (_, event) => item.activate(event),
            on_secondary_click: (_, event) => item.openMenu(event),
            binds: [['tooltip-markup', item, 'tooltip-markup']],
        }));
    }),
});

const Volume = Widget.Box({
    class_name: 'volume',
    css: 'min-width: 180px',
    children: [
        Widget.Icon().hook(Audio, self => {
            if (!Audio.speaker)
                return;

            const category = {
                101: 'overamplified',
                67: 'high',
                34: 'medium',
                1: 'low',
                0: 'muted',
            };

            const icon = Audio.speaker.stream.isMuted ? 0 : [101, 67, 34, 1, 0].find(
                threshold => threshold <= Audio.speaker.volume * 100);

            self.icon = `audio-volume-${category[icon]}-symbolic`;
        }, 'speaker-changed'),
        Widget.Slider({
            class_name: 'slider',
            hexpand: true,
            draw_value: false,
            on_change: ({ value }) => Audio.speaker.volume = value,
            setup: self => self.hook(Audio, () => {
                self.value = Audio.speaker.stream.isMuted ? 0 : Audio.speaker?.volume;
            }, 'speaker-changed'),
        }),
    ],
});

const Clock = Widget.Label({
    class_name: 'clock',
    setup: self => self
        .poll(1000, self => execAsync(['date', '+%H:%M · %b %e'])
            .then(date => self.label = date)),
});

const Left = Widget.Box({
    spacing: 8,
    children: [
        Logo,
        Workspaces,
        Active,
    ],
});

const Center = Widget.Box({
    spacing: 8,
    children: [
        Media,
    ],
});

const Right = Widget.Box({
    hpack: 'end',
    spacing: 8,
    children: [
        Tray,
        Volume,
        Clock,
    ],
});

const Bar = (monitor = 0) => Widget.Window({
    name: `bar-${monitor}`,
    class_name: 'bar',
    margins: [5, 5, 0, 5],
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        start_widget: Left,
        center_widget: Center,
        end_widget: Right,
    }),
});

import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';

monitorFile(
    `${App.configDir}/style.css`,
    function() {
        App.resetCss();
        App.applyCss(`${App.configDir}/style.css`);
    },
);

App.config({
    style: './style.css',
    windows: [
        Bar(),
        NotificationPopups(),
    ],    
});

