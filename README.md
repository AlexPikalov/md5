# Development Plan

- [x] setup memory layout to include K, s, last_chunk,
      constants - a0, b0, c0, d0 etc
- [x] implement and test logic that creates a last chunk
- [x] implement single 512-bit chunk hashing
- [x] test single chunk hashing logic on the last chunk (mess-
      ages which length is less then 448 bits (56 bytes) fit into
      the last chunk
- [ ] implement message by-chunk-processing logic
