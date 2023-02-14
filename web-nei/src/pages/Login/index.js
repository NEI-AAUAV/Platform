import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import NEIService from "services/NEIService";
import { Link } from "react-router-dom";

const Login = () => {
	const formSubmitted = async (event) => {
		event.preventDefault();

		const formData = new FormData(event.target);
		const access = await NEIService.login(formData);
		console.log(access);
	}

	return <>
		<form className="d-flex flex-column mx-auto text-center" onSubmit={formSubmitted}>
			<TextField name="username" placeholder="Email" type="email" label={null} variant="outlined"
				sx={{
					mt: 1, flex: 1,
					'& legend': { display: 'none' },
					'& fieldset': { top: 0, borderColor: 'var(--border) !important' },
					'& .MuiInputBase-input': { p: 1 },
					'& .MuiOutlinedInput-root': { padding: '4px', color: 'var(--text-primary)', },
				}}
			/>
			<TextField name="password" placeholder="Password" type="password" label={null} variant="outlined"
				sx={{
					mt: 1, flex: 1,
					'& legend': { display: 'none' },
					'& fieldset': { top: 0, borderColor: 'var(--border) !important' },
					'& .MuiInputBase-input': { p: 1 },
					'& .MuiOutlinedInput-root': { padding: '4px', color: 'var(--text-primary)', },
				}}
			/>
			<Button variant="outlined" type="submit"
				sx={{
					mt: 1, flex: 1, borderColor: 'var(--border) !important', color: 'var(--text-primary)',
					'& .MuiTouchRipple-root': { padding: '4px', color: 'var(--text-primary)' },
				}}
			>
				Login
			</Button>
			<p className="mt-2">
				Don't have an account? <Link to={"/register"}>Register</Link>
			</p>
		</form>
	</>;
}

export default Login;
