# event-datetime

This is used with the "events post" plugin and circumvents a bug in WP 6.2.2+ wher shortcodes are handled too early in the page's creation and thus we can't get `postid` for the post in question within a query loop.

The "magic" is in block.json:
``` json
    "usesContext": ["postId"],
```