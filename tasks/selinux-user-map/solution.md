# Reference solution — map a Linux user to a SELinux user

`semanage login` maps a Linux login to an SELinux user (which confines what that
login can do). Here the account is mapped to the `staff_u` SELinux user.

```bash
dnf install -y policycoreutils-python-utils   # semanage ships here (not pre-installed)
semanage login -a -s staff_u <U>
semanage login -l              # verify <U> -> staff_u
```
