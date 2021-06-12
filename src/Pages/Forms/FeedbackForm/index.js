import React, { useState } from "react";
import Typist from 'react-typist';
import { Form, Button, Alert } from 'react-bootstrap';

const FeedbackForm = () => {

    const [form, setForm] = useState({
        'email': '',
        'message': ''
    });
    const [sent, setSent] = useState(false);
    const [error, setError] = useState(null);

    const formUpdated = (event) => {
        setForm(prev => {
            return {
                ...prev,
                [event.target.name]: event.target.value
            }
        });
    }

    const formSubmitted = (event) => {
        event.preventDefault();
        console.log("Submitted");
        setSent(true);
        // setError("Error message");
    }

    if (sent) {
        return (
            <div className="d-flex flex-column">
                <h2 className="text-center">
                    Obrigado pela tua mensagem!
                </h2>
                <p className="text-center mb-0">
                    Vamos analisá-la e entraremos em contacto em breve!
                </p>
                <button
                    className="btn btn-outline-primary mx-auto mt-5"
                    onClick={() => window.history.back()}
                >
                    Voltar
                </button>
            </div>
        )
    }


    return (
        <div>
            <h2 className="text-center">
                <Typist>Dá-nos o teu feedback!</Typist>
            </h2>
            <p className="text-center mb-0">
                Utiliza este formulário para nos fazeres chegar as tuas sugestões acerca do website.
            </p>
            <p className="text-center">
                Estamos ansiosos por ler o que nos tens a dizer! :)
            </p>

            {
                error &&
                <Alert variant="danger" className="small">
                    Ocorreu um erro na submissão do formulário: {error}
                </Alert>
            }

            <Form
                onSubmit={formSubmitted}
            >
                <Form.Group className="mb-3" controlId="formBasicEmail">
                    <Form.Label>Email</Form.Label>
                    <Form.Control
                        type="email"
                        placeholder="Qual o teu email?"
                        required="true"
                        value={form.email}
                        onChange={formUpdated}
                        name="email"
                    />
                </Form.Group>

                <Form.Group controlId="exampleForm.ControlTextarea1">
                    <Form.Label>A tua mensagem</Form.Label>
                    <Form.Control
                        as="textarea"
                        rows={7}
                        required="true"
                        value={form.message}
                        onChange={formUpdated}
                        name="message"
                    />
                </Form.Group>



                <Button variant="outline-primary" type="submit" className="col-12">
                    Submeter
                </Button>
            </Form>
        </div>
    );
}

export default FeedbackForm;