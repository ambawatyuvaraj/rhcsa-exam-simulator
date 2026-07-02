# Reference solution — create directories and copy files

```bash
mkdir -p <BASE>/<SUB>
touch <BASE>/<SUB>/keep.txt
cp /etc/hostname <BASE>/host.copy
```

`mkdir -p` creates parent directories as needed, `touch` makes an empty file,
and `cp` copies the source file.
