# Nginx Fancyindex Theme - shadcn/ui

This is a theme for Nginx's [Fancyindex](https://github.com/aperezdc/ngx-fancyindex) module which looks to look like a minimalistic, modern web app as though it were built using shadcn/ui.

Make your static directory file listing tree both beautiful and efficient with static HTML, CSS & JS assets!

## Showcase

I use this theme for my [personal static file listing](https://files.guzek.uk/misc/showcase/), which you can test for yourself!

![root directory listing](https://files.guzek.uk/misc/showcase/pictures/screenshots/root.png)
![pictures directory listing](https://files.guzek.uk/misc/showcase/pictures/screenshots/pictures.png)
![screenshots directory listing](https://files.guzek.uk/misc/showcase/pictures/screenshots/screenshots.png)
![404 page](https://files.guzek.uk/misc/showcase/pictures/screenshots/404.png)

## Installation

This theme requires Nginx compiled with the Fancyindex module. The recommended way to achieve this is to use my Docker image.

### Fancyindex with docker

Installation instructions: <https://github.com/kguzek/nginx-fancyindex-docker/#usage>

### Fancyindex manual

Manual installation instructions: <https://github.com/aperezdc/ngx-fancyindex#requirements>

### Theme installation

> [!Note]
> The provided examples assume you are using the Docker image for shadcn with your served files mounted using a read-only mount at `/usr/share/nginx/html` in the container, and the contents of this repository mounted at `/path/to/nginx-fancyindex-theme-shadcn`. Additionally, the drop-in files should be mounted according to the Docker image documentation.

To actually use this theme, you must clone the static assets and instruct Fancyindex to use the `header.html` and `footer.html` files in the [theme](./theme) folder. You can achieve this with a drop-in location configuration.

```nginx
# location.d/fancyindex-settings.conf
fancyindex_show_dotfiles on; # shows files starting with a period
fancyindex_ignore ^\.\.?$; # hides the '.' and '..' linux metadirectories
fancyindex_header /.fancyindex/header.html; # for the custom header
fancyindex_footer /.fancyindex/footer.html; # for the custom footer
fancyindex_show_path off; # for the custom breadcrumbs
```

You must also make the entire [theme](./theme) folder reachable at `/.fancyindex` in your server - you can use a drop-in server configuration for this.

```nginx
# server.d/shadcn-theme.conf
location /.fancyindex {
  alias /path/to/nginx-fancyindex-theme-shadcn/theme;
}
```

For the custom 404 page, use another server-level configuration:

```nginx
# server.d/custom-404-page.conf
error_page 404 /404.html;

location = /404.html {
    root /path/to/nginx-fancyindex-theme-shadcn/static;
    internal; # prevents users from reaching the file at /404.html, instead serving them the 404 page (optional since the effect is the same)
}
```

## Final notes

If you found this theme useful, show your appreciation by starring this repository!

For any feedback or suggestions, feel free to [open an issue](https://github.com/kguzek/nginx-fancyindex-theme-shadcn/issues/new).
