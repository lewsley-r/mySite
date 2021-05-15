{{/* vim: set filetype=mustache: */}}
{{/*
Create a valid laravel site to inject as nginx configuration,
which points to our PHP-FPM service
*/}}
{{- define "laravelNginxToPhpFpm" -}}
{{- $name := default "laravel-phpfpm" .Values.phpfpm.backend -}}
{{- $port := default "9000" .Values.phpfpm.port -}}
{{- printf "%s-%s:%s" .Release.Name $name $port | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Create a valid laravel site to inject as nginx configuration,
which points to our PHP-FPM service
*/}}
{{- define "laravelNginx" -}}

      server {
          listen 80;
          client_max_body_size {{ default "20M" .Values.nginx.clientMaxBodySize -}};
          server_tokens off;

          root /var/www/app/public;
          index index.php index.html index.htm;

          location / {
              try_files $uri $uri/ /index.php?$query_string;

              if (!-d $request_filename) {
                  rewrite ^(.+)/$ /$1;
              }

              if (!-e $request_filename) {
                  rewrite ^(.*)$ /index.php?$1 last;
                  break;
              }
          }

          location ~ \.php$ {
              include fastcgi_params;
              fastcgi_pass {{ template "laravelNginxToPhpFpm" . }};
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_index index.php;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_intercept_errors off;
              fastcgi_buffer_size 16k;
              fastcgi_buffers 4 16k;
          }

          location ~ /\.ht {
              deny all;
          }

      }

{{- end -}}
