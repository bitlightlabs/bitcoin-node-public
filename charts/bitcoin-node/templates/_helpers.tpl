{{/*
Expand the name of the chart.
*/}}
{{- define "bitcoin-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bitlight-node.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bitcoin-node.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bitcoin-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bitcoin-node.labels" -}}
helm.sh/chart: {{ include "bitcoin-node.chart" . }}
{{ include "bitcoin-node.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
bitcoin-node/network: {{ .Values.bitcoind.network }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bitcoin-node.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bitcoin-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "bitcoin-node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "bitcoin-node.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create JSON-RPC port for bitcoind
Listen for JSON-RPC connections on <port> (default: 8332, testnet3:
18332, testnet4: 48332, signet: 38332, regtest: 18443)
rpcport=<port>
*/}}
{{- define "bitcoin-node.rpcPort" -}}
{{- index .Values.bitcoind.service.port.rpc .Values.network }}
{{- end }}

{{/*
{{- end }}

{{/*
Create bitcoin Config
*/}}
{{- define "bitcoin-node.bitcoinCoreConfig" -}}
# Common settings
server=1
listen=1
txindex=1
rpcuser={{ .Values.bitcoind.rpcUser}}
rpcpassword={{ .Values.bitcoind.rpcPassword }}
{{ .Values.config.common }}

# ZMQ settings
zmqpubrawblock=tcp://0.0.0.0:{{ .Values.bitcoind.service.port.zmqpubrawblock }}
zmqpubrawtx=tcp://0.0.0.0:{{ .Values.bitcoind.service.port.zmqpubrawtx }}

# Network specific settings
{{- $network := .Values.network }}
{{- if eq $network "regtest" }}
{{ .Values.config.regtest }}
{{- else if eq $network "testnet3" }}
{{ .Values.config.testnet3 }}
{{- else if eq $network "testnet4" }}
{{ .Values.config.testnet4 }}
{{- end -}}
{{- end }}

{{/*
Create bitcoind image
*/}}
{{- define "bitcoin-node.bitcoinCoreImage" -}}
{{ .Values.bitcoind.image.repository }}:{{ .Values.bitcoind.image.tag }}
{{- end }}

{{/*
Create esplora image
*/}}
{{- define "bitcoin-node.esploraImage" -}}
{{ .Values.esplora.image.repository }}:{{ .Values.esplora.image.tag }}
{{- end }}