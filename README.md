# WordPress

WordPress 是一个功能非常强大的博客系统，插件众多，易于扩充功能，安装和使用都非常方便。目前 WordPress 已经成为主流的 Blog 搭建平台。

## 版本

该镜像与官方镜像同步。

## 说明

WordPress 需要搭配 MySQL 数据库才能运行，当您部署在 DaoCloud 平台上时，您可以在启动 WordPress 应用时绑定一个 MySQL 服务来自动完成。

您也可以通过手动设置下面的环境变量来指定 MySQL 连接：

- `WORDPRESS_DB_HOST` 数据库主机地址（默认为与其 `link` 的 `mysql` 容器的 IP 和 3306 端口：`<mysql-ip>:3306`）
- `WORDPRESS_DB_USER` 数据库用户名（默认为 `root`）
- `WORDPRESS_DB_PASSWORD` 数据库密码（默认为与其 `link` 的 `mysql` 容器提供的 `MYSQL_ROOT_PASSWORD` 变量的值）
- `WORDPRESS_DB_NAME` 数据库名（默认为 `wordpress`）
- `WORDPRESS_TABLE_PREFIX` 数据库表名前缀（默认为空，您可以从该变量覆盖 `wp-config.php` 中的配置）
- 安全相关（默认为随机的 SHA1 值）
	+ `WORDPRESS_AUTH_KEY`
	+ `WORDPRESS_SECURE_AUTH_KEY`
	+ `WORDPRESS_LOGGED_IN_KEY`
	+ `WORDPRESS_NONCE_KEY`
	+ `WORDPRESS_AUTH_SALT`
	+ `WORDPRESS_SECURE_AUTH_SALT`
	+ `WORDPRESS_LOGGED_IN_SALT`
	+ `WORDPRESS_NONCE_SALT`

如果 `WORDPRESS_DB_NAME` 变量指定的数据库不存在时，那么 `wordpress` 容器在启动时就会自动尝试创建该数据库，但是由 `WORDPRESS_DB_USER` 变量指定的用户需要有创建数据库的权限。

如果您想通过主机 IP 访问您的站点，那么您可以使用端口映射的功能：

```console
$ docker run --name some-wordpress --link some-mysql:mysql -p 8080:80 -d wordpress
```

然后您就可以在浏览器通过 `http://localhost:8080` 或 `http://host-ip:8080` 访问您的站点了。

如果您想使用外部数据库的话，可以通过上述环境变量设置对应数据库的连接方式：

```console
$ docker run --name some-wordpress -e WORDPRESS_DB_HOST=10.1.2.3:3306 \
    -e WORDPRESS_DB_USER=... -e WORDPRESS_DB_PASSWORD=... -d wordpress
```

## 使用 Stack 功能部署 WordPress 于自有主机

> Stack 是用一个 YAML 文件来描述容器配置和依赖的，这个描述文件完全兼容 Docker Compose 的语法。

您可以使用 Stack 功能将 WordPress 快速部署在您的自有主机上，您可以参考下面的 `docker-compose.yml` 文件：

```yaml
wordpress: 
  image: daocloud.io/daocloud/dao-wordpress:latest 
  links: 
    - db:mysql 
  ports: 
    - "80" 
  restart: always 
db: 
  image: mysql 
  environment: 
    - MYSQL_ROOT_PASSWORD=example 
  restart: always
```

## 注意

由于上传的文件如图片等会保存在容器中，容器重新部署可能会导致上传文件的丢失，因此不建议您用 Ghost 存储重要文件，但是当您部署于自有主机上时可以通过 Volume 功能挂载宿主机上的目录至容器来做持久化储存。