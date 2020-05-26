#include <stdio.h>
#include <unistd.h> // Ensure POSIX works

int main() {
  printf("hello, world!\n");
  printf("The process ID is %d.\n", getpid());
}
