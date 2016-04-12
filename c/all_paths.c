#include <stdio.h>
#include <stdint.h>

#define SQUARE_SIZE 10

int main() {
  int64_t paths = 0;
  for(int64_t i = 0; i < (int64_t) (1)<<(SQUARE_SIZE*2); i++) {
    int64_t bitCount = __builtin_popcount(i);
    if(bitCount == SQUARE_SIZE) {
      paths++;
    }
  }

  printf("%lld\n", paths);
  return 0;
}
