import { ExtensionContext, commands } from 'vscode';

import {
	LanguageClient,
	LanguageClientOptions,
	ServerOptions,
} from 'vscode-languageclient/node';

let client: LanguageClient;

export function activate(context: ExtensionContext) {
    let executablePath = 'bazel';

	let serverOptions: ServerOptions = {
		command: executablePath,
		args: ["run", "//utils/ls_explorer:carbonls"]
	};

    let clientOptions: LanguageClientOptions = {
		documentSelector: [{ scheme: 'file', language: 'carbon' }],
		synchronize: {},
		outputChannelName: 'carbonls'
	};

	client = new LanguageClient(
		'carbonls',
		'CarbonLS',
		serverOptions,
		clientOptions
	);

    context.subscriptions.push(commands.registerCommand('carbonls.restart', async () => {
		await client.stop();
		client.start();
	}));

	client.start();
}

export function deactivate(): Thenable<void> | undefined {
	if (!client) {
		return undefined;
	}
	return client.stop();
}