import NEIService from "services/NEIService";
import { useRef } from "react";

const ForgotPassword = () => {
	const emailRef = useRef(null);
	const errorMessage = useRef(null);
	const successMessage = useRef(null);

	const formSubmitted = async (event) => {
		event.preventDefault();

		const formData = new FormData(event.target);
		try {
			await NEIService.forgotPassword(formData);

			successMessage.current.classList.remove("hidden");
			emailRef.current.classList.remove("input-error");
			errorMessage.current.classList.add("hidden");
		} catch (error) {
			emailRef.current.classList.add("input-error");
			errorMessage.current.classList.remove("hidden");
		}
	};

	return (
		<>
			<div className="m-auto sm:max-w-md h-fit bg-base-200 rounded-2xl py-6 px-14 drop-shadow-lg shadow-secondary z-10 flex flex-col align-middle max-w-[80%]">
				<div className="text-3xl text-center mb-2">Recupera a tua conta</div>
				<form onSubmit={formSubmitted}>
					<div className="flex flex-col">
						<label className="label">
							<span className="label-text">Email</span>
						</label>
						<input
							className="input input-bordered w-full mb-1"
							name="email"
							placeholder="Email"
							type="email"
							ref={emailRef}
						/>
						<button
							className="btn btn-primary sm:btn-wide m-auto btn-block mt-10"
							type="submit"
						>
							Login
						</button>
						<p
							className="text-xs text-error hidden mt-2 text-center"
							ref={errorMessage}
						>
							Erro a enviar o email de recuperação
						</p>
						<p
							className="text-xs text-success hidden mt-2 text-center"
							ref={successMessage}
						>
							Email de recuperação enviado com sucesso
						</p>
					</div>
				</form>
			</div>
		</>
	);
};

export default ForgotPassword;
