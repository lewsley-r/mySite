{{/* vim: set filetype=mustache: */}}
{{/*
Set settings that would be found in a php.ini
configuration file for this service.
*/}}
{{- define "additionalPhp" -}}
    <?php

    return json_decode(<<<ENDJ
    {{ toJson .Values.additional }}
    ENDJ
    , true);
{{- end -}}
