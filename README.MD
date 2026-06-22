# 1. API Dio Client

## Overview

The `api` folder contains all files related to the Dio HTTP client.

This module is responsible for:

- Sending HTTP requests to the server
- Receiving API responses
- Handling request/response interceptors
- Managing API configurations
- Centralizing network-related logic

Keeping all Dio-related code inside this folder helps maintain a clean and scalable project structure.

---

## Required Dependency

Before using the API client, install the Dio package:

```bash
flutter pub add dio