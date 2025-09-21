{{- define "django-app.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{- define "django-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "django-app.labels" -}}
app.kubernetes.io/name: {{ include "django-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
# app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}