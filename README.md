# Cross-compiling to Linux with Clang in 2 steps

Copyright: [CC-BY-4.0](LICENSE.txt)

Credit: this expands on [this article](https://medium.com/@haraldfernengel/cross-compiling-c-c-from-macos-to-raspberry-pi-in-2-easy-steps-23f391a8c63), which focused on macOS -> ARM EABI Linux.

**Prerequisites**

[Clang](https://clang.llvm.org) on your host machine. What is nice about Clang
is it has cross-compiling capability already so we don't need to specifically
download a cross-compiler. That being said, you still need to collect a number
of dependencies to cross-compile.

Clang is the default compiler on macOS (often hidden behind a misleading alias
`gcc`/`g++`), and is available for Linux as well.

## Completeness: contribution welcomed

The system libraries for Linux are definitely provided by GNU. But C/C++
standard libraries can come from many sources. In tables below, "GNU" and
"LLVM" refer to the provider of the C/C++ standard libraries.

### From macOS to Linux

|              |   x86_64 ELF Linux   | ARM EABI Linux |
|:-------------|:--------------------:|:--------------:|
|get binutils  |          `✔`         |      `✔`       |    
|get libs    |  `✔`(GNU)  `-`(LLVM) |    `✔`(GNU)    |
|build program |  `✔`(GNU)  `-`(LLVM) |    `✔`(GNU)    |
|run program   |  `✔`(GNU)  `-`(LLVM) |    `-`(GNU)    |

### From x86_64 ELF Linux to another Linux (different arch and/or ABI)
> Frequently used for embedded devices.

TODO: backburner

---

## :clubs: Step 1. Prepare binutils

[GNU `binutils`](https://www.gnu.org/software/binutils/) is a collection of
binary manipulation utilities, like linker `ld` and `gold`, assembler `as`,
symbol dumper `nm`.

### :small_blue_diamond: For x86_64 ELF Linux

```sh
# from macOS: assume you use HomeBrew as the package manager
$ brew install x86_64-elf-binutils
```

The binaries are found at `/usr/local/Cellar/x86_64-elf-binutils/[version]/x86_64-elf/bin`.
Let's name the program path `GNU_BINUTILS_DIR`.

### :small_blue_diamond: For ARM EABI Linux

```sh
# from macOS: assume you use HomeBrew as the package manager
$ brew install arm-linux-gnueabihf-binutils
```

The binaries are found at `/usr/local/Cellar/arm-linux-gnueabihf-binutils/[version]/arm-linux-gnueabihf/bin`.
Let's name the program path `GNU_BINUTILS_DIR`.

## :clubs: Step 2. Get Linux's libraries (and their headers)

You may download from an official source, but a more direct and foolproof way
is actually pull these from a Linux remote machine. For this purpose, we need
to use `rsync` (it should be already installed on your machine) and your remote
login username and address `username@1.2.3.4`.

This will create a `sysroot` directory here. It acts as the root path `/` of
a Linux.

There are two types of libraries:
- system libraries (POSIX and Linux-specific): this is provided by GNU, the
  maintainer of Linux. Practically GNU is the only provider.
- C/C++ standard libraries: this can be provided by GNU (via its compiler GCC),
  by LLVM (via its compiler Clang), or else.
  > GCC's offer covers more architecture and ABIs.

### :small_blue_diamond: GNU C/C++ libs, for x86_64 ELF Linux

```sh
$ ./x86_64-elf-gnu-rsync.sh username@1.2.3.4
```

Log into the remote machine and get the GCC version `[x].[y].[z]`, let's name
it `LINUX_GCC_VERSION`.
```sh
# 'gcc -dumpversion' only prints the major version
$ gcc --version | head -1 | tr ' ' '\n' | tail -1
```

### :small_blue_diamond: GNU C/C++ libs, for ARM EABI Linux

```sh
$ ./arm-eabi-gnu-rsync.sh username@1.2.3.4
```

Log into the remote machine and get the GCC version `[x].[y].[z]`, let's name
it `LINUX_GCC_VERSION`.
```sh
# 'gcc -dumpversion' only prints the major version
$ gcc --version | head -1 | tr ' ' '\n' | tail -1
```

### :small_blue_diamond: LLVM C/C++ libs, for x86_64 ELF Linux

Usually LLVM/Clang is not installed on a Linux distribution. Verify it is
installed (with a simple `clang --version` on your Linux target) before
proceeding.

```sh
TODO: script unfinished!
$ ./x86_64-elf-llvm-rsync.sh username@1.2.3.4
```

Log into the remote machine and get the Clang version `[x].[y].[z]`, let's name
it `LINUX_CLANG_VERSION`.
```sh
$ clang -dumpversion
```

## :clubs: Verify

### :small_blue_diamond: GNU standard libs, for x86_64 ELF Linux

```sh
# from macOS, assume your compiler is Clang

# MODIFY accordingly. The following variables were retrieved from step 1 and 2.
GNU_BINUTILS_DIR=/usr/local/Cellar/x86_64-elf-binutils/2.34/x86_64-elf/bin
LINUX_GCC_VERSION=7.5.0

$ ./x86_64-elf-gnu-compile.sh $GNU_BINUTILS_DIR $LINUX_GCC_VERSION
```

You may upload the product programs in `out` to your x86_64 ELF Linux to
execute them, and you would see something like this:
```sh
# In target machine x86_64 ELF Linux
$ out/hello_c
hello, world!
The process ID is 8292.
$ out/hello_cc
hello, world!
The process ID is 8293.
```

### :small_blue_diamond: GNU standard libs, for ARM EABI Linux

```sh
# from macOS, assume your compiler is Clang

# MODIFY accordingly. The following variables were retrieved from step 1 and 2.
GNU_BINUTILS_DIR=/usr/local/Cellar/arm-linux-gnueabihf-binutils/2.34/arm-linux-gnueabihf/bin
LINUX_GCC_VERSION=7.5.0

$ ./arm-eabi-gnu-compile.sh $GNU_BINUTILS_DIR $LINUX_GCC_VERSION
```

### :small_blue_diamond: LLVM standard libs, for x86_64 ELF Linux

```sh
TODO: script unfinished!
$ ./x86_64-elf-llvm-compile.sh $GNU_BINUTILS_DIR $LINUX_CLANG_VERSION
```

■
