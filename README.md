
---

## Dev Environment Setup with Devbox

### Install Devbox

```bash
curl -fsSL https://get.jetify.com/devbox | bash
```

### Initialize Devbox

```bash
devbox init
devbox shell
devbox add <package>
```

> Replace `<package>` with the package name you want to install (e.g., `nodejs`, `python`, etc.)

---

## 📋 Taskfile Bash Completion (Optional)

Enable bash auto-completion for `task`:

```bash
eval "$(task --completion bash)"
```

You can add the above line to your `.bashrc` or `.bash_profile` for persistent completions.

---

## To add aws config to the project
```bash
    aws eks update-kubeconfig --name microservices --region us-east-1
    aws sts get-caller-identity --profile MY-PROFILE
```

---