import { useState } from 'react';
import { Input, Spacer, Loading } from "@nextui-org/react";
import { TabButton } from "../components/Customized";

import service from 'services/RallyTascasService';
import { useRallyAuth } from 'stores/useRallyAuth';


const inputStyles = {
    maxWidth: 300,
    width: '100%',
    '& input': {
        color: 'white',
        fontWeight: 'bold'
    },
    '& span': {
        color: 'white',
    },
    '& label': {
        background: '#00020E77'
    }
}

const LoginSection = ({ onSuccess }) => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const [failed, setFailed] = useState(false);

    const handleLogin = () => {
        if (!(username && password)) return;
        setLoading(true);
        setFailed(false);

        const data = new FormData();
        data.set("username", username);
        data.set("password", password);

        service.login(data)
            .then((data) => {
                useRallyAuth.getState().login(data);
                const { isAdmin, isStaff } = useRallyAuth.getState();
                if (!isAdmin && !isStaff) {
                    service.getOwnTeam()
                        .then((team) => {
                            useRallyAuth.getState().setTeamName(team.name);
                            setLoading(false);
                            onSuccess();
                        })
                } else {
                    setLoading(false);
                    onSuccess();
                }
            })
            .catch(() => {
                setLoading(false);
                setFailed(true);
            })
    }

    return (
        <div className="text-center">
            <h3 className="rally-header" style={{ marginTop: '7rem' }}>Log in</h3>
            {!!failed && <p className="rally-login-help">Email ou palavra-passe incorreta.</p>}
            <Spacer y={1} />
            <Input
                placeholder="Email"
                css={inputStyles}
                value={username}
                onChange={e => setUsername(e.target.value)}
            />
            <Spacer y={1.6} />
            <Input.Password
                type="password"
                placeholder="Password"
                css={inputStyles}
                value={password}
                onChange={e => setPassword(e.target.value)}
            />
            <Spacer y={1.6} />
            <TabButton active login style={{ margin: 'auto' }} onPress={handleLogin}>
                {!loading ? 'Submeter' : <Loading color="currentColor" size="sm" />}
            </TabButton>
        </div>
    );
}

export default LoginSection;
