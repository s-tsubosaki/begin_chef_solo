# for ubuntu only
default[:nginx][:dir]     = '/etc/nginx'
default[:nginx][:log_dir] = '/var/log/nginx'
default[:nginx][:user]    = 'www-data'
default[:nginx][:binary]  = '/usr/sbin/nginx'

# increase if you accept large uploads
default[:nginx][:client_max_body_size] = '4m'

default[:nginx][:gzip] = 'on'
default[:nginx][:gzip_static] = 'on'
default[:nginx][:gzip_vary] = 'on'
default[:nginx][:gzip_disable] = 'MSIE [1-6].(?!.*SV1)'
default[:nginx][:gzip_http_version] = '1.0'
default[:nginx][:gzip_comp_level] = '2'
default[:nginx][:gzip_proxied] = 'any'
default[:nginx][:gzip_types] = ['application/x-javascript',
                                'application/xhtml+xml',
                                'application/xml',
                                'application/xml+rss',
                                'text/css',
                                'text/javascript',
                                'text/plain',
                                'text/xml']
# NGinx will compress 'text/html' by default

default[:nginx][:keepalive] = 'on'
default[:nginx][:keepalive_timeout] = 65

default[:nginx][:worker_processes] = 4
default[:nginx][:worker_connections] = 1024
default[:nginx][:server_names_hash_bucket_size] = 64