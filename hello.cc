#include <iostream>
#include <unistd.h>   // Ensure POSIX works
// #include <filesystem> // Ensure C++17 works

int main() {
  std::cout << "hello, world!" << std::endl;
  std::cout << "The process ID is " << getpid() << "." << std::endl;
  // std::cout << std::filesystem::path("path/foo/bar").c_str() << std::endl;
}
