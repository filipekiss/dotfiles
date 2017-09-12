# My custom functions

If a function is worth explaning, it's here

## tm() and fs() functions

These functions are used to handle my workflow during multiple tmux sessions. fs() is a fast-switch
and tm() loads sessions from my tmuxp configuration

However, both functions are a little smart, so I won't get frustrated:

 - fs() will invoke tm(), allowing you to select a new session to load from your ~/.tmuxp
   configuration folder if there's currently one or none sessions open
 - fs() will change between the two sessions and the tm() function will not be invoked if only two
   sessions are open
 - tm() will show all open session along side your tmuxp configurations. The current session will
   not be shown on the list. Selecting a session that's already created will attach your client to
   it. Selecting a new session will run `tmuxp load <session>` as expected.
