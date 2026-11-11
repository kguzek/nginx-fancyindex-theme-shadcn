# Nginx FancyIndex Theme - shadcn/ui

This is a theme for Nginx's [FancyIndex](https://github.com/aperezdc/ngx-fancyindex) module which strives to make your directory tree look like a minimalistic, modern web app as though it were built using shadcn/ui.

Make your static file listing both beautiful and efficient with static HTML, CSS & JS assets!

## Showcase

I use this theme for my [personal static file listing](https://files.guzek.uk/misc/showcase/), which you can test for yourself.

![root directory listing](https://files.guzek.uk/misc/showcase/pictures/screenshots/root.png)
![pictures directory listing](https://files.guzek.uk/misc/showcase/pictures/screenshots/pictures.png)
![screenshots directory listing](https://files.guzek.uk/misc/showcase/pictures/screenshots/screenshots.png)
![404 page](https://files.guzek.uk/misc/showcase/pictures/screenshots/404.png)

## Installation

Before installing the theme, make sure you have FancyIndex enabled. If you already have this, you can skip to step 2.

### 1. FancyIndex installation

This theme requires Nginx compiled with the FancyIndex module. The recommended way to achieve this is to use my Docker image.

Docker installation instructions: <https://github.com/kguzek/nginx-fancyindex-docker/#usage>

Manual installation instructions: <https://github.com/aperezdc/ngx-fancyindex#requirements>

### 2. Theme installation

> [!Note]
> The provided examples assume you are using the Docker image for shadcn with your served files mounted using a read-only mount at `/usr/share/nginx/html` in the container, and the contents of this repository mounted at `/path/to/nginx-fancyindex-theme-shadcn`. Additionally, the drop-in files should be mounted according to the Docker image documentation.

To actually use this theme, you must download the asset files. The best way to do that is to simply clone the repository, which allows automatic updates by simply pulling from GitHub.

```sh
git clone https://github.com/kguzek/nginx-fancyindex-theme-shadcn.git
```

> [!Tip]
> Make sure to mount the repository directory in your Docker container.

Next, you must instruct FancyIndex to use the `header.html` and `footer.html` files in the [theme](./theme) folder. You can achieve this with a drop-in location configuration.

```nginx
# location.d/fancyindex-settings.conf

# shows files starting with a period
fancyindex_show_dotfiles on;
# hides the '.' and '..' linux metadirectories
fancyindex_ignore ^\.\.?$;
# for the custom header
fancyindex_header /.fancyindex/header.html;
# for the custom footer
fancyindex_footer /.fancyindex/footer.html;
# for the custom breadcrumbs
fancyindex_show_path off;
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
    # prevents users from reaching the file at /404.html, instead serving them the 404 page (optional since the effect is the same)
    internal;
}
```

### Example setup

Below is a full setup example, using the Docker image with Docker Compose.

```txt
/opt/files
├── compose.yaml
├── conf.d
├── location.d
│   └── fancyindex-settings.conf
├── nginx-fancyindex-theme-shadcn
│   ├── LICENSE
│   ├── README.md
│   ├── static
│   │   └── 404.html
│   └── theme
│       ├── footer.html
│       ├── header.html
│       ├── script.js
│       └── styles.css
└── server.d
    ├── custom-404-page.conf
    └── shadcn-theme.conf
```

```yaml
# /opt/files/compose.yaml
services:
  files:
    image: git.guzek.uk/kguzek/nginx-fancyindex:v0.5.0
    container_name: files
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      - /mnt/samba/public:/usr/share/nginx/html:ro
      - ./nginx-fancyindex-theme-shadcn/static:/usr/share/nginx/static:ro
      - ./nginx-fancyindex-theme-shadcn/theme:/usr/share/nginx/theme:ro
      - ./conf.d:/etc/nginx/conf.d:ro
      - ./server.d:/etc/nginx/server.d:ro
      - ./location.d:/etc/nginx/location.d:ro
```

This serves the files at `/mnt/samba/public` on port `8080` using the custom FancyIndex theme.

## Final notes

If you found this theme useful, show your appreciation by starring this repository!

For any feedback or suggestions, feel free to [open an issue](https://github.com/kguzek/nginx-fancyindex-theme-shadcn/issues/new).
