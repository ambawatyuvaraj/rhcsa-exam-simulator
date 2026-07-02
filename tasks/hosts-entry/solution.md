# Reference solution — Static /etc/hosts entry

```bash
echo "<IP>    <HN>" >> /etc/hosts
```
Verify: `getent hosts <HN>`.
