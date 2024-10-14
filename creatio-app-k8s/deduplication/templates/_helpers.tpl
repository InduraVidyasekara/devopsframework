{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "deduplication.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "deduplication.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "deduplication.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get KubeVersion removing pre-release information.
TODO: .Capabilities.KubeVersion.GitVersion is deprecated in Helm 3, switch to .Capabilities.KubeVersion.Version after migration.
*/}}
{{- define "service.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.GitVersion (regexFind "v[0-9]+\\.[0-9]+\\.[0-9]+" .Capabilities.KubeVersion.GitVersion ) -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19.x" (include "service.kubeVersion" .)) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{/*
Return if ingress is stable.
*/}}
{{- define "ingress.isStable" -}}
  {{- eq (include "ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return if ingress supports ingressClassName.
*/}}
{{- define "ingress.supportsIngressClassName" -}}
  {{- or (eq (include "ingress.isStable" .) "true") (and (eq (include "ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18.x" (include "service.kubeVersion" .))) -}}
{{- end -}}

{{/*
Return if ingress supports pathType.
*/}}
{{- define "ingress.supportsPathType" -}}
  {{- or (eq (include "ingress.isStable" .) "true") (and (eq (include "ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18.x" (include "service.kubeVersion" .))) -}}
{{- end -}}

{{/*
Returns rabbitmq connection stirng.
*/}}
{{- define "rabbitmq.connectionString" -}}
    amqp://{{ .Values.global.rabbitmq.user }}:{{ .Values.global.rabbitmq.password }}@{{ .Values.global.rabbitmq.host }}:{{ .Values.global.rabbitmq.port }}{{ .Values.global.rabbitmq.vhost }}
{{- end -}}

{{/*
Returns deduplication database connection stirng.
*/}}
{{- define "db.connectionString" -}}
  {{- if .Values.global.mongodb.user -}}
    mongodb://{{ .Values.global.mongodb.user }}:{{ .Values.global.mongodb.password }}@{{ .Values.global.mongodb.host }}:{{ .Values.global.mongodb.port }}{{ .Values.global.mongodb.additionalParams | default "" }}
  {{- else -}}
    mongodb://{{ .Values.global.mongodb.host }}:{{ .Values.global.mongodb.port }}{{ .Values.global.mongodb.additionalParams | default "" }}
  {{- end -}}
{{- end -}}

{{/*
Returns redis connection stirng.
*/}}
{{- define "redis.connectionString" -}}
    {{ .Values.global.redis.host }}:{{ .Values.global.redis.port }},defaultDatabase={{ .Values.global.redis.database }}{{ .Values.global.redis.additionalParams | default "" }}
{{- end -}}

{{/*
Returns elasticsearch url.
*/}}
{{- define "elasticsearch.url" -}}
  {{- if .Values.global.elasticsearch.user -}}
    {{ .Values.global.elasticsearch.protocol }}://{{ .Values.global.elasticsearch.user }}:{{ .Values.global.elasticsearch.password }}@{{ .Values.global.elasticsearch.host }}:{{ .Values.global.elasticsearch.port }}{{ .Values.global.elasticsearch.path | default "" }}
  {{- else -}}
    {{ .Values.global.elasticsearch.protocol }}://{{ .Values.global.elasticsearch.host }}:{{ .Values.global.elasticsearch.port }}{{ .Values.global.elasticsearch.path | default "" }}
  {{- end -}}
{{- end -}}