# Reference solution — User with specific UID

```bash
useradd -u 3533 manalo
echo 'flectrag' | passwd --stdin manalo
```

Verify:
```bash
id manalo                 # uid=3533(manalo) ...
```
