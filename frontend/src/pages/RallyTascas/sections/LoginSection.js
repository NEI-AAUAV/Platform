import { Button, Input, Modal, Text } from "@nextui-org/react";


const LoginSection = () => {
    return (
        <div style={{marginTop: '35vh'}}>
            <h3 className="rally-header mt-3">Login</h3>
            
            <Input
                clearable
                bordered
                fullWidth
                size="lg"
                placeholder="Pontos"
                status="primary"
            />
            <Input
                clearable
                bordered
                fullWidth
                size="lg"
                placeholder="Pontos"
                status="primary"
            />
        </div>
    );
}

export default LoginSection;
