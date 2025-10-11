declare module 'react-typist' {
  import { Component } from 'react';

  interface TypistProps {
    children?: React.ReactNode;
    className?: string;
    cursor?: {
      show?: boolean;
      blink?: boolean;
      element?: string;
      hideWhenDone?: boolean;
      hideWhenDoneDelay?: number;
    };
    avgTypingDelay?: number;
    startDelay?: number;
    stdTypingDelay?: number;
    onTypingDone?: () => void;
  }

  export default class Typist extends Component<TypistProps> {}
}
