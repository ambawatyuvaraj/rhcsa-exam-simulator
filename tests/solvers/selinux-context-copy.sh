#!/usr/bin/env bash
cp --preserve=context "/var/www/html/$F" "/var/www/html/$F2"
restorecon -v "/var/www/html/$F2"
