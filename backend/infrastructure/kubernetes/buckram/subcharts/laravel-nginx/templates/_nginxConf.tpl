{{/* vim: set filetype=mustache: */}}
{{/*
Setup the nginx server config with default values and
javascript to mask the IP Address, zip and email.
*/}}
{{- define "nginxConf" -}}

     user  nginx;
     worker_processes  1;
     load_module modules/ngx_http_js_module.so;
     load_module modules/ngx_stream_js_module.so;
     
     error_log  /var/log/nginx/error.log warn;
     pid        /var/run/nginx.pid;
     
     
     events {
         worker_connections  1024;
     }
     
     
     http {
         include       /etc/nginx/mime.types;
         default_type  application/octet-stream;
         js_include mask_ip_uri.js;
         js_set $remote_addr_masked maskRemoteAddress;
         js_set $request_uri_masked maskRequestURI;
     
         log_format masked '$remote_addr_masked - $remote_user [$time_local] '
           '"$request_method $request_uri_masked $server_protocol" '
           '$status $body_bytes_sent "$http_referer" "$http_user_agent"';
     
         access_log  /var/log/nginx/access.log masked;
     
         sendfile        on;
         #tcp_nopush     on;
     
         keepalive_timeout  65;
     
         #gzip  on;
     
         include /etc/nginx/conf.d/*.conf;
     }

{{- end -}}
