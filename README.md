# MD5 hashing (NASM assembly implementation)

**THIS IS WIP**

This is a toy project created for learning assembly programming language. As of now the algorithm is implemented with following limitations:

1. message length is an integer number of bytes
2. no support for stream inputs (messages of initially undetermined length)
3. code is not position-independent

## Usage

A message that has to be MD5-hashed should be provided to the `md5cli` through stdin.

```bash
# manually typed string
echo "Hello MD5!" | md5cli

# file
md5cli < <PATH_TO_FILE>
```

As of now, the maximal length of a message (file size) is 1024 bytes. Read buffer memory allocation is WIP.

## License

MIT License 2025 Oleksandr Pikalov
