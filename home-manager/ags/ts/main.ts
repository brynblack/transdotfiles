import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { NotificationPopups } from "./notification.js";
import { convertGtkToScss } from "./transpile.js";
import { execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const Workspaces = Widget.Box({
  class_name: 'workspaces',
  children: Hyprland.bind('workspaces').transform(ws => {
    const sortedWs = ws.sort((a, b) => a.id - b.id);
    return sortedWs.map(({ id }) => Widget.Button({
      on_clicked: () => Hyprland.messageAsync(`dispatch workspace ${id}`),
      child: Widget.Label(`${id}`),
      class_name: Hyprland.active.workspace.bind('id')
        .transform(i => `${i === id ? 'focused' : ''}`),
    }));
  }),
});

const Active = Widget.Label({
  class_name: 'active',
  truncate: 'end',
  maxWidthChars: 64,
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
    maxWidthChars: 32,
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
      child: Widget.Icon().bind('icon', item, 'icon'),
      on_primary_click: (_, event) => item.activate(event),
      on_secondary_click: (_, event) => item.openMenu(event),
    }).bind('tooltip_markup', item, 'tooltip_markup'));
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

      if (Audio.speaker.stream) {
        const icon = Audio.speaker.stream.isMuted ? 0 : [101, 67, 34, 1, 0].find(
          threshold => threshold <= Audio.speaker.volume * 100);

        if (icon) {
          self.icon = `audio-volume-${category[icon]}-symbolic`;
        }
      }
    }, 'speaker-changed'),
    Widget.Slider({
      class_name: 'slider',
      hexpand: true,
      draw_value: false,
      on_change: ({ value }) => Audio.speaker.volume = value,
      setup: self => self.hook(Audio, () => {
        if (Audio.speaker.stream) {
          self.value = Audio.speaker.stream.isMuted ? 0 : Audio.speaker?.volume;
        }
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
    Active,
  ],
});

const Center = Widget.Box({
  spacing: 8,
  children: [
    Media,
    Workspaces,
    Tray,
    Clock,
  ],
});

const Right = Widget.Box({
  hpack: 'end',
  spacing: 8,
  children: [
    Volume,
  ],
});

const Bar = (monitor = 0) => Widget.Window({
  name: `bar-${monitor}`,
  class_name: 'bar',
  margins: [],
  monitor,
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  child: Widget.CenterBox({
    start_widget: Left,
    center_widget: Center,
    end_widget: Right,
  }),
});


const contents = Utils.readFile('/home/brynleyl/.config/gtk-3.0/gtk.css');
const output = convertGtkToScss(contents);
Utils.writeFile(output, 'style/_gtk.scss')

const scss = `${App.configDir}/style/style.scss`
const css = `/tmp/style.css`
console.log(Utils.exec(`sass ${scss} ${css}`))

Utils.monitorFile(
    // directory that contains the scss files
    `${App.configDir}/style`,

    // reload function
    function() {
        // main scss file
        const scss = `${App.configDir}/style/style.scss`

        // target css file
        const css = `/tmp/style.css`

        // compile, reset, apply
        console.log(Utils.exec(`sass ${scss} ${css}`))
        App.resetCss()
        App.applyCss(css)
    },
)

Utils.monitorFile(
    // directory that contains the scss files
    `/home/brynleyl/.config/gtk-3.0/gtk.css`,

    // reload function
    function() {
        const contents = Utils.readFile('/home/brynleyl/.config/gtk-3.0/gtk.css');
        const output = convertGtkToScss(contents);
        Utils.writeFile(output, 'style/_gtk.scss')
    },
)

App.config({
  style: css,
  windows: [
    Bar(),
    NotificationPopups(),
  ],
});


