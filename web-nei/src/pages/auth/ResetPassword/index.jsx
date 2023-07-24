import NEIService from "services/NEIService";
import { useRef } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";

export function Component() {
	const navigate = useNavigate();
	const errorMessage = useRef(null);
	const [searchParams] = useSearchParams();

	const formSubmitted = async (event) => {
		event.preventDefault();

		const token = searchParams.get("token");

		const formData = new FormData(event.target);
		try {
			await NEIService.resetPassword(formData, { token });

			navigate("/");
		} catch (error) {
			errorMessage.current.classList.remove("hidden");
		}
	};

	return (
		<>
			<div className="m-auto sm:max-w-md h-fit bg-base-200 rounded-2xl py-6 px-14 drop-shadow-lg shadow-secondary z-10 flex flex-col align-middle max-w-[80%]">
				<div className="text-3xl text-center mb-2">Altera a tua password</div>
				<form onSubmit={formSubmitted}>
					<div className="flex flex-col">
						<label className="label">
							<span className="label-text">Nova Password</span>
						</label>
						<input
							className="input input-bordered w-full"
							name="password"
							placeholder="Password"
							type="password"
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
							Erro a alterar a password
						</p>
					</div>
				</form>
			</div>
		</>
	);
}
