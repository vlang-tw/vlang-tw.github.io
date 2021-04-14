NGROL_GOLOBEL_CONFIG?=$(HOME)/.ngrok2/ngrok.yml

.PHONY: ngrok

ngrok:
	@ngrok start -config=$(NGROL_GOLOBEL_CONFIG) -config=ngrok.yml vscode-live-server