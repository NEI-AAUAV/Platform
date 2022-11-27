import { styled, Button } from "@nextui-org/react";

// IconButton component will be available as part of the core library soon
export const IconButton = styled("button", {
  dflex: "center",
  border: "none",
  outline: "none",
  cursor: "pointer",
  padding: "0",
  margin: "0",
  bg: "transparent",
  transition: "$default",
  "&:hover": {
    opacity: "0.8",
  },
  "&:active": {
    opacity: "0.6",
  },
});

export const TabButton = ({ active, login, children, ...props }) => {
  const color = login ? '#FC8551' : '#FF4646';
  return <Button
    auto
    css={{
      minWidth: 135,
      fontWeight: 'bold',
      margin: '0.5rem',
      border: '$space$1 solid transparent',
      background: active ? color : 'transparent',
      color: active ? 'white' : color,
      borderColor: color,
      height: '$12', // space[12]
      boxShadow: '$md', // shadows.md
      '&:hover': {
        background: active ? color : '#FF464666',
      },
      '@sm': {
        margin: login ? '0.5rem' : '0.5rem 3rem',
      }
    }}
    {...props}
  >
    {children}
  </Button>
}