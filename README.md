<div align="center">

# asdf-atmos [![Build](https://github.com/cloudposse/asdf-atmos/actions/workflows/build.yml/badge.svg)](https://github.com/cloudposse/asdf-atmos/actions/workflows/build.yml) [![Lint](https://github.com/cloudposse/asdf-atmos/actions/workflows/lint.yml/badge.svg)](https://github.com/cloudposse/asdf-atmos/actions/workflows/lint.yml)

[atmos](https://atmos.tools/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [asdf-atmos  ](#asdf-atmos--)
- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add atmos
# or
asdf plugin add atmos https://github.com/cloudposse/asdf-atmos.git
```

atmos:

```shell
# Show all installable versions
asdf list-all atmos

# Install specific version
asdf install atmos latest

# Set a version globally (on your ~/.tool-versions file)
asdf global atmos latest

# Now atmos commands are available
atmos version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/cloudposse/asdf-atmos/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Cloud Posse](https://github.com/cloudposse/)
