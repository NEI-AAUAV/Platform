import React, { cloneElement, createContext, isValidElement, useContext } from "react";

const SelectCtx = createContext(() => {});

export const selectMock = {
  Select: ({ onValueChange, children }) => (
    <SelectCtx.Provider value={onValueChange}>
      <div>{children}</div>
    </SelectCtx.Provider>
  ),
  SelectTrigger: ({ children }) => <div>{children}</div>,
  SelectValue: ({ placeholder }) => <span>{placeholder}</span>,
  SelectContent: ({ children }) => <div>{children}</div>,
  SelectItem: ({ value, children }) => {
    const onValueChange = useContext(SelectCtx);
    return (
      <button type="button" data-testid={`opt-${value}`} onClick={() => onValueChange(value)}>
        {children}
      </button>
    );
  },
};

const pass = ({ children }) => <div>{children}</div>;

export const dialogMock = {
  DialogContent: pass,
  DialogHeader: pass,
  DialogTitle: pass,
};

export const alertDialogMock = {
  AlertDialogContent: pass,
  AlertDialogHeader: pass,
  AlertDialogTitle: pass,
  AlertDialogDescription: pass,
  AlertDialogFooter: pass,
  AlertDialogCancel: ({ children, onClick }) => (
    <button type="button" onClick={onClick}>{children}</button>
  ),
  AlertDialogAction: ({ children, onClick }) =>
    isValidElement(children) ? (
      cloneElement(children, { onClick })
    ) : (
      <button type="button" onClick={onClick}>{children}</button>
    ),
};
