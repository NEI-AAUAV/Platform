import React, { useState, useEffect } from "react";
import { useSearchParams } from "react-router-dom";
import Spinner from "components/Spinner";
import { MailIcon } from "assets/icons/google";

import NEIService from 'services/NEIService';

function SuccessfulVerification() {
	return (
		<div className="flex flex-col items-center">
			<MailIcon className="text-success max-w-sm p-8" width="100%" height="100%" />

			<h1 className="text-primary text-center word-break">Email validado com sucesso</h1>

			<a className="btn btn-primary mt-8" href="/">Voltar a página inicial</a>
		</div>
	);
}

function FailedVerification() {
	return (
		<div className="flex flex-col items-center">
			<MailIcon className="text-error max-w-sm p-8" width="unset" height="unset" />

			<h1 className="text-primary text-center word-break">Link de verificação inválido</h1>

			<a className="btn btn-primary mt-8" href="/">Voltar a página inicial</a>
		</div>
	);
}

function EmailVerify() {
	const [searchParams] = useSearchParams();
	const [state, setState] = useState("success");

	useEffect(() => {
		if (!searchParams) return;

		const token = searchParams.get("token");

		if (!token) {
			setState("failed");
			return
		}

		NEIService.verifyEmail({ token })
			.then(data => setState("success"))
			.catch(() => setState("failed"));
	}, [searchParams]);

	const Current = () => {
		switch (state) {
			case "loading": return <Spinner className="flex-grow max-w-lg" />;
			case "success": return <SuccessfulVerification />;
			case "failed": return <FailedVerification />;
		}
	}

	return (
		<div className="flex justify-center">
			<Current />
		</div>
	);
};

export default EmailVerify;
