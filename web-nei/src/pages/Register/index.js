import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import NEIService from "services/NEIService";

const Register = () => {
	const formSubmitted = async (event) => {
		event.preventDefault();

		const formData = new FormData(event.target);
		const data = Object.fromEntries(formData.entries());

		if (data.password !== data.confirm_password) {
			// TODO
			return;
		}

		delete data.confirm_password;

		const access = await NEIService.register(data);
		console.log(access);
	}

	return <form className="d-flex flex-column mx-auto" onSubmit={formSubmitted}>
		<TextField name="name" placeholder="Name" type="text" label={null} variant="outlined" required
			sx={{
				mt: 1, flex: 1,
				'& legend': { display: 'none' },
				'& fieldset': { top: 0, borderColor: 'var(--border) !important' },
				'& .MuiInputBase-input': { p: 1 },
				'& .MuiOutlinedInput-root': { padding: '4px', color: 'var(--text-primary)', },
			}}
		/>
		<TextField name="surname" placeholder="Surname" type="text" label={null} variant="outlined" required
			sx={{
				mt: 1, flex: 1,
				'& legend': { display: 'none' },
				'& fieldset': { top: 0, borderColor: 'var(--border) !important' },
				'& .MuiInputBase-input': { p: 1 },
				'& .MuiOutlinedInput-root': { padding: '4px', color: 'var(--text-primary)', },
			}}
		/>
		<TextField name="email" placeholder="Email" type="email" label={null} variant="outlined" required
			sx={{
				mt: 1, flex: 1,
				'& legend': { display: 'none' },
				'& fieldset': { top: 0, borderColor: 'var(--border) !important' },
				'& .MuiInputBase-input': { p: 1 },
				'& .MuiOutlinedInput-root': { padding: '4px', color: 'var(--text-primary)', },
			}}
		/>
		<TextField
			name="password" placeholder="Password" type="password" label={null} variant="outlined" required
			inputProps={{ minLength: 8 }}
			sx={{
				mt: 1, flex: 1,
				'& legend': { display: 'none' },
				'& fieldset': { top: 0, borderColor: 'var(--border) !important' },
				'& .MuiInputBase-input': { p: 1 },
				'& .MuiOutlinedInput-root': { padding: '4px', color: 'var(--text-primary)', },
			}}
		/>
		<TextField name="confirm_password" placeholder="Repeat password" type="password" label={null} variant="outlined"
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
			Register
		</Button>
	</form>;
}

export default Register;
