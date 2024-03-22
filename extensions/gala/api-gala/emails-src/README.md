# Emails for GALA Service

This directory contains the source files for the emails, these are written
with [react email](https://react.email/). The emails are each represented
by a file in the `emails` directory.

## Installing Dependencies

The dependencies are managed with [pnpm](https://pnpm.io/), to install them simply run:

```
$ pnpm install
```

## Development

React email offers a development server that supports hot-reload and sending emails, to
start it simply run:

```
$ pnpm run dev
```

## Building templates

After the emails are finished they must be exported, this is done with two commands, one
to export them as html and another to export them as plain text.

```
$ pnpm run export --outDir ../templates/
$ pnpm run export --outDir ../templates/ --plainText
```
