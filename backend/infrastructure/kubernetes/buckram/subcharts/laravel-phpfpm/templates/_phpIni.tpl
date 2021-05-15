{{/* vim: set filetype=mustache: */}}
{{/*
Set settings that would be found in a php.ini
configuration file for this service.
*/}}
{{- define "phpIni" -}}
    expose_php = Off

    memory_limit = {{ .Values.wwwConf.memoryLimit }}
    upload_max_filesize = {{ .Values.wwwConf.uploadMaxFilesize }}
    post_max_size = {{ .Values.wwwConf.postMaxSize }}
    max_execution_time = {{ .Values.wwwConf.maxExecutionTime }}
    max_input_time = {{ .Values.wwwConf.maxInputTime }}
    max_file_uploads = {{ .Values.wwwConf.maxFileUploads }}
    file_uploads = {{ .Values.wwwConf.fileUploads }}
    output_buffering = {{ .Values.wwwConf.outputBuffering }}
{{- end -}}
