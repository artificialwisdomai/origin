🚀 Personal Intelligence Demonstration

# Introduction

This chatbot will open a web interface binding to all interfaces on port `7080`. The chatbot
defaults to inferencing a llama2 model that is tuned for `chat` and has `70B` parameters. This
chatbot uses the [Pykoi](https://github.com/CambioML/pykoi) inferencing framework.

**N.B.** Perhaps, some day, there will be `llama2-chatbot-prod.py`.

# Pre-requisites

Install the poetry dependency management tool with the [pipx workflow](https://python-poetry.org/docs/#installing-with-pipx):

```console
sudo apt install pipx
pipx install poetry
```

Ensure port `7080` is open for business and your cloud provider's **ingress** is open for business.

```console
sudo iptables -I INPUT -p tcp --dport 7080 -j ACCEPT
```

# Install

Poetry is dependency management done right (aka build-time).

```console
pushd workloads/chatbot/pykoi; poetry build; popd
```


# Lifecycle dead chicken testing

Poetry also seems to have an interest in runtime. It is good enough to test, but not
good enough for production.

Start the chatbot with [poetry run](https://python-poetry.org/docs/basic-usage/#using-poetry-run) to start the chatbot:

```console
pushd workloads/chatbots/pykoi; poetry run workload; popd
```

Stop the chatbot by entering CTRL-C in the terminal, which sends a signal to terminate poetry and its children.


# Lifecycle with systemd service manager

Start the chatbot with `systemd`:

```console
systemd-run magic incantation
```

Monitor the chatbot with `systemd`:

```console
journalctl -xu magic incantation
```

Stop the chatbot with `systemd`:

```console
systemctl stop magic incantation
```

