# serve

A tiny Windows CMD command for saving project shortcuts and running `bun dev` from anywhere.

## Features

- Save a project path under a short name.
- Run `bun dev` with `serve <project-name>`.
- List saved projects with `serve list`.
- Works in plain Windows Command Prompt.
- Stores config in `%USERPROFILE%\.serve-projects.txt`.

## Commands

```cmd
serve add <project-name> --path "C:\path\to\project"
serve list
serve <project-name>
```

## Examples

```cmd
serve add tic-tac-toe --path "C:\projects\tic-tac-toe"
serve add portfolio --path "D:\dev\portfolio"
serve list
serve tic-tac-toe
serve portfolio
```

## Installation

1. Put `serve.cmd` in a folder such as:
   ```cmd
   C:\Users\your-name\bin
   ```
2. Add that folder to your Windows `PATH`.
3. Open a new Command Prompt window.
4. Run:
   ```cmd
   serve help
   ```

## How it works

When you run:

```cmd
serve add my-app --path "C:\projects\my-app"
```

the script saves a line like this to:

```cmd
%USERPROFILE%\.serve-projects.txt
```

```txt
my-app|C:\projects\my-app
```

Later, when you run:

```cmd
serve my-app
```

it:

1. Looks up the saved path.
2. Changes into that directory using `cd /d`.
3. Runs `bun dev`.

## Notes

- Adding the same project name again replaces the old path.
- If the saved path does not exist, the command exits with an error.
- Project names are matched case-insensitively.
- This is designed for CMD, not PowerShell.

## File structure

```txt
serve.cmd
README.md
```

## License

MIT
