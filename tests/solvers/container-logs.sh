#!/usr/bin/env bash
podman logs "$CN" > "/root/$OUT" 2>/dev/null
