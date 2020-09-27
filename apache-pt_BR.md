## Apache Virtual Hosting

Usei isso num Ubuntu Server 18.04 com Apache 2.

Passos para abilitar um virtual host num servidor rodando apache:
```shell
sudo mkdir /var/www/your_domain
sudo chown $USER:$USER /var/www/your_domain
# criar /var/www/your_domain/index.html
```
Criar o arquivo `/etc/apache2/sites-available/your_domain.conf`:
```
<VirtualHost *:80>
  ServerAdmin webmaster@localhost
  ServerName your_domain
  ServerAlias www.your_domain
  DocumentRoot /var/www/your_domain
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

De volta a linha de comando:
```shell
sudo a2ensite your_domain.conf
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
sudo systemctl restart apache2
```
