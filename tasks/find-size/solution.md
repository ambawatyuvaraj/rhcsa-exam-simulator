# Reference solution — find files within a size range

```bash
find /opt/sizesrc -type f -size +10k -size -100k > /root/<OUT>
```

`-size +10k` means strictly larger than 10*1024 bytes; `-size -100k` means
strictly smaller than 100*1024 bytes. Combining both gives the open range.
