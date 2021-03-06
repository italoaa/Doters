import subprocess
import os
from qutebrowser.api import interceptor


# Meta
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

# ================== Settings ======================= {{{
config.load_autoconfig(False)
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
c.downloads.location.directory = '~/Downloads'
c.tabs.show = 'switching'
c.window.hide_decoration = False
config.set("colors.webpage.darkmode.enabled", True)
c.fonts.default_size = '13pt'
c.fonts.hints = 'bold 15pt default_family'
# == }}}


# ================== Key Bindigns ======================= {{{
c.aliases = {
        'q': 'quit',
        'w': 'session-save',
        'wq': 'quit --save'
        }
config.bind('<Alt-y>','hint links spawn /usr/local/bin/mpv --force-window --script-opts=ytdl_hook-ytdl_path=/usr/local/bin/youtube-dl {hint-url}')
config.bind('<Alt-Shift-y>','hint links spawn /usr/local/bin/mpv --no-video --force-window --script-opts=ytdl_hook-ytdl_path=/usr/local/bin/youtube-dl {hint-url}')
config.bind('<Ctrl-r>','config-source')
# == }}}

# Athetics
c.fonts.completion.entry = '15pt monospace'
c.completion.height = '30%'
c.statusbar.padding = {'bottom': 5, 'left': 5, 'right': 5, 'top': 5}
c.statusbar.widgets = ["keypress", "url", "scroll", "history", "tabs", "progress"]
c.colors.completion.fg = 'black'
c.colors.completion.odd.bg = '#F2F2F2'
c.colors.completion.even.bg = 'lightgrey'
c.hints.border = '2px solid black'
c.colors.hints.fg = 'red'
c.colors.hints.bg = 'black'
c.colors.hints.match.fg = 'lime'

# ================== Youtube Add Blocking ======================= {{{
def filter_yt(info: interceptor.Request):
    """Block the given request if necessary."""
    url = info.request_url
    if (
        url.host() == "www.youtube.com"
        and url.path() == "/get_video_info"
        and "&adformat=" in url.query()
    ):
        info.block()


interceptor.register(filter_yt)
# == }}}
