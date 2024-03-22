import {
  Body,
  Container,
  Head,
  Heading,
  Hr,
  Html,
  Img,
  Preview,
  Text,
} from '@react-email/components';
import * as React from 'react';

function backendVar(name: string): string {
  return `{{${name}}}`
}

export const NEIRegistrationEmail = () => (
  <Html>
    <Head />
    <Preview>Foste aceite na mesa</Preview>
    <Body style={main}>
      <Container style={container}>
        <Img
          src={`${backendVar("PUBLIC_URL")}/static/nei/nei.png`}
          width="42"
          height="42"
          alt="NEI"
          style={logo}
        />
        <Heading as="p" style={heading}>Olá {backendVar("name")}!</Heading>
        <Text style={paragraph}>
          Foste aceite na mesa "{backendVar("table")}"
        </Text>
        <Hr />
        <Text style={paragraph}>
          Estás a receber este email porque te inscreveste no jantar de gala.
        </Text>
        <Hr />
        <Text style={paragraph}>
          Cumprimentos,<br />
          A comissão de gala
        </Text>
      </Container>
    </Body>
  </Html>
);

export default NEIRegistrationEmail;

const logo = {
  borderRadius: 21,
  width: 42,
  height: 42,
};

const main = {
  fontFamily:
    '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif',
  backgroundColor: "#36d399",
  background: "linear-gradient(90deg, #36d399 0%, #548786 100%)",
  backgroundRepeat: "no-repeat",
  backgroundSize: "cover",
  backgroundPosition: "center"
};

const container = {
  margin: '0 auto',
  width: '560px',
  padding: "1rem",
  backgroundColor: "#fff",
  borderRadius: "1rem"
};

const heading = {
  fontSize: '24px',
  letterSpacing: '-0.5px',
  lineHeight: '1.3',
  fontWeight: '400',
  color: '#3c4149',
  padding: '17px 0 0',
};

const paragraph = {
  margin: '0 0 15px',
  fontSize: '15px',
  lineHeight: '1.4',
  color: '#3c4149',
};
