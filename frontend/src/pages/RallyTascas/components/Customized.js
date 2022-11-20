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

export const TabButton = ({ active, children, ...props }) =>
  <Button
    auto
    css={{
      minWidth: 135,
      fontWeight: 'bold',
      margin: '0.5rem',
      border: '$space$1 solid transparent',
      background: active ? '#FF4646' : 'transparent',
      color: active ? 'white' : '#FF4646',
      borderColor: '#FF4646',
      height: '$12', // space[12]
      boxShadow: '$md', // shadows.md
      '&:hover': {
        background: active ? '#FF4646' : '#FF464666',
      },
    }}
    {...props}
  >
    {children}
  </Button>
