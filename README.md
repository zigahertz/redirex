# Redirex

# production application

Visit the app at [https://zz-redirex.fly.dev/](https://zz-redirex.fly.dev/)

The home page is a form to enter a URL for shortening.

The [stats route](https://zz-redirex.fly.dev/stats) displays a table of all URLs along with the shortened version of the URL and visit count.

# local development

- clone repository
- Run `mix setup` to install dependencies and create the local DB
- Start Phoenix endpoint with `iex -S mix phx.server`

visit [`localhost:4000`](http://localhost:4000) from your browser.

## Dev Notes

I used LiveView to create the web client (see `RedirexWeb.LinkLive`). I used a Phoenix controller (`RedirexWeb.LinkController`) to handle both the CSV download and URL redirect.

URLs are shortened to a randomized hash consisting of seven alphanumeric characters. This hash doubles as the primary key for the `links` table in Postgres.

Automated tests encapsulate basic functionality of the `Redirex.Links` context, LiveView, and controller actions.

Concurrency performance was tested using ApacheBench using commands like

```bash
 ab -n 1200 -c 26 https://zz-redirex.fly.dev/CluhETf
```

Typical results can be seen [here](/concurrency_benchmark.jpg)
