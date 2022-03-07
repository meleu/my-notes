## upcase video series

- link: <https://thoughtbot.com/upcase/tmux>

### Part 1: Introduction

tmux stands for terminal multiplexer.

Install with your system's package manager.

#### Initial Commands

Initial commands:
- `C-b` - the default prefix
- `<prefix> %` - split horizontally
- `<prefix> "` - split vertically
- `<prefix> o` - jump to the other pane
- `<prefix> c` - creates a new window

Check `man tmux` and `/KEY BINDINGS` for more.

#### Config file

`~/.tmux.conf`
```
# use C-a as the prefix key
unbind C-b
set -g prefix C-a
```

Reload the config file:
```
$ tmux source-file ~/.tmux.conf
```


#### session vs. window vs. pane

When you type `tmux` you're starting a new session.

You can also start a new session with:
```
tmux new-session -s session-name
```

And list the running sessions with:
```
tmux list-sessions
```

---


## cheatsheet

### **By resources**

#### *sessions*

```   
list-sessions        ls         -- List sessions managed by server
new-session          new        -- Create a new session
kill-session                    -- Destroy a given session
rename-session       rename     -- Rename a session
attach-session       attach     -- Attach or switch to a session
has-session          has        -- Check and report if a ses is on server
set-option           set        -- Set a session option
lock-session                    -- Lock all clients attached to a session
```

#### *windows*

```
list-windows
new-window           neww       -- Create a new window
kill-window          killw      -- Destroy a given window
rename-window        renamew    -- Rename a window
choose-session                  -- Put a window into session choice mode
choose-window                   -- Put a window into window choice mode
select-window        selectw    -- Select a window
find-window          findw      -- Search for a pattern in windows
last-window          last       -- Select the previously selected window
move-window          movew      -- Move a window to another
next-window          next       -- Move to the next window in a session
previous-window      prev       -- Move to the previous window in a session
refresh-client       refresh    -- Refresh a client
respawn-window       respawnw   -- Reuse a wd in which a command has exited
rotate-window        rotatew    -- Rotate positions of panes in a window
swap-window          swapw      -- Swap two windows
unlink-window        unlinkw    -- Unlink a window
select-layout        selectl    -- Choose a layout for a window
select-prompt                   -- Open a prompt to enter a window index
set-window-option    setw       -- Set a window option
```

#### *panes*

```
list-panes           lsp        -- List panes of a window
kill-pane            killp      -- Destroy a given pane
pipe-pane            pipep      -- Pipe out from a pane to a sh command
resize-pane          resizep    -- Resize a pane
display-panes        displayp   -- Disp an indicator for each visible pane
select-pane          selectp    -- Make a pane the active one in the window
up-pane              upp        -- Move up a pane
down-pane            downp      -- Move down a pane
resize-pane          resizep    -- Resize a pane
swap-pane            swapp      -- Swap two panes
split-window         splitw     -- Splits a pane into two
join-pane            joinp      -- Split a pane and move an existing one into the new space
break-pane           breakp     -- Break a pane from an existing into a new window
capture-pane         capturep   -- Capture the contents of a pane to a buffer
```

#### *clients*

```
switch-client        switchc    -- Switch the client to another session
suspend-client       suspendc   -- Suspend a client
refresh-client       refresh    -- Refresh a client
lock-client                     -- Lock a client
list-clients         lsc        -- List clients attached to server
detach-client        detach     -- Detach a client from the server
choose-client                   -- Put a window into client choice mode
show-messages        showmsgs   -- Show client's message log
display-message      display    -- Display a message in the status line
```

#### *server*

```
server-info          info       -- Show server information
start-server         start      -- Start a tmux server
kill-server                     -- Kill clients, sessions and server
lock-server          lock       -- Lock all clients attached to the server
```

#### *shell*

```
run-shell            run        -- Execute a command without creating a new window
if-shell             if         -- Execute a tmux command if a shell-command succeeded
pipe-pane            pipep      -- Pipe output from a pane to a shell command
```

#### *keys*

```
bind-key             bind       -- Bind a key to a command
unbind-key           unbind     -- Unbind a key
list-keys            lsk        -- List all key-bindings
```

#### *paste buffers*

```
capture-pane         capturep   -- Capture the contents of a pane to a buffer
copy-buffer          copyb      -- Copy session paste buffers
delete-buffer        deleteb    -- Delete a paste buffer
list-buffers         lsb        -- List paste buffers of a session
load-buffer          loadb      -- Load a file into a paste buffer
paste-buffer         pasteb     -- Insert a paste buffer into the window
save-buffer          saveb      -- Save a paste buffer to a file
set-buffer           setb       -- Set contents of a paster buffer
show-buffer          showb      -- Display the contents of a paste buffer
```

### **By functionality**

#### *options*

```
set-option           set        -- Set a session option
set-window-option    setw       -- Set a window option
```

#### *list stuff*

```
list-sessions        ls         -- List sessions managed by server
list-windows         lsw        -- List windows of a session
list-panes           lsp        -- List panes of a window
list-buffers         lsb        -- List paste buffers of a session
list-clients         lsc        -- List clients attached to server
list-commands        lscm       -- List supported sub-commands
list-keys            lsk        -- List all key-bindings
```

### **Typical usage**

#### *flags*

```
e.g.   
session-like: [-AdDP]   
window-like: [-adkP]
```

#### *arguments*

```
[-c start-directory]
[-F format]

[-n window-name]
[-s session-name]
[-b buffer-name]

[-t : target-client, target-session target-window, or target-pane]

[-x width]
[-y height]
[command]
```

#### *examples*

```
tmux new-session -s <session-name>
tmux attach-session -t <target-session>
tmux load-buffer -b <buffer-name> <path>
tmux save-buffer -b <buffer-name> <path>
tmux show-buffer -b <buffer-name>
tmux paste-buffer -b <buffer-name> -t <target-pane>
```

### **Working with sessions**

```
$ Rename the current session.
```

### **Working with clients**

```
d Detach the current client.
( Switch the attached client to the previous session.
) Switch the attached client to the next session.
D Choose a client to detach.
L Switch the attached client back to the last session.
r Force redraw of the attached client.
s Select a new session for the attached client interactively.
```

### **Working with windows**

```
c Create a new window.
, Rename the current window.
0 to 9 Select windows 0 to 9
l Move to the previously selected window.
n Change to the next window.
p Change to the previous window
w Choose the current window interactively
. Prompt for an index to move the current window.
& Kill the current window.
' Prompt for a window index to select
f Prompt to search for text in open windows.
i Display some information about the current window.
```

### **Working with panes**

```
" Split the current pane into two, top and bottom
% Split the current pane into two, left and right
z Toggle zoom state of the current pane.
o Select the next pane in the current window
Up, Down, Left, Right Change to the pane relative of the current pane.
; Move to the previously active pane
q Briefly display pane indexes
! Break the current pane out of the window
m Mark the current pane (see select-pane -m)
M Clear the marked pane
C-o Rotate the panes in the current window forwards
{ Swap the current pane with the previous pane.
} Swap the current pane with the next pane.
x Kill the current pane
Space Arrange the current window in the next preset layout
M-1 to M-5 Arrange panes (preset layouts)
```

### **Copy mode**
Set `vi` (or `emacs`) mode with:

```
set-window-option -g mode-keys vi   <or emacs>
```

```
       Function                vi             emacs
       Back to indentation     ^              M-m
       Clear selection         Escape         C-g
       Copy selection          Enter          M-w
       Cursor down             j              Down
       Cursor left             h              Left
       Cursor right            l              Right
       Cursor to bottom line   L
       Cursor to middle line   M              M-r
       Cursor to top line      H              M-R
       Cursor up               k              Up
       Delete entire line      d              C-u
       Delete to end of line   D              C-k
       End of line             $              C-e
       Goto line               :              g
       Half page down          C-d            M-Down
       Half page up            C-u            M-Up
       Next page               C-f            Page down
       Next word               w              M-f
       Paste buffer            p              C-y
       Previous page           C-b            Page up
       Previous word           b              M-b
       Quit mode               q              Escape
       Scroll down             C-Down or J    C-Down
       Scroll up               C-Up or K      C-Up
       Search again            n              n
       Search backward         ?              C-r
       Search forward          /              C-s
       Start of line           0              C-a
       Start selection         Space          C-Space
       Transpose chars                        C-t
```       

### **additional useful key bindings**

```
bind-key -t vi-copy v begin-selection
bind-key -t vi-copy y copy-pipe "reattach-to-user-namespace pbcopy"

unbind -t vi-copy Enter
bind-key -t vi-copy Enter copy-pipe "reattach-to-user-namespace pbcopy"

bind-key -n C-S-Left swap-window -t -1
bind-key -n C-S-Right swap-window -t +1

bind-key -n S-Right next-window
bind-key -n S-Left previous-window
```

### **sources**

- <https://gist.github.com/Bekbolatov/6840069e51382965fdad>


