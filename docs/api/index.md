---
layout: post
title: "iP.1 REST API"
sidebar: api_sidebar
permalink: docs-api.html
categories: changelog
---


API Wide Requirements
---------------------

There are a few HTTP headers that are required. Firstly, authentication needs to be in place (see [Authentication](docs-authentication.html)). Secondly, `Content-Type` and `Content-Length` needs to be set to `application/json; utf8` and the size of the body respectively. This makes sure the API understands that you send json formatted and utf8 encoded data in your request body.

Authentication
--------------

All API calls require authentication with your account credentials. The REST API uses [`HTTP Basic Authentication`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication#Basic_authentication_scheme) using your account ID and API key. For how to get API credentials checkout [this page](docs-authentication.html).

To get your Basic Authentication string, take your account ID (i. e. `ip1-12345`) and your API-key (i. e. `cCnbXFfyTM5BTKh7uNV`) and run them through a Base64 encoder in the following way:

```
ip1-12345:CnbXFfyTM5BTKh7uNV
```

You should get at string that looks something like this:

```
aXAxLTEyMzQ1OkNuYlhGZnlUTTVCVEtoN3VOVg==
```

This is your HTTP Basic Authentication string and should be given as an HTTP header in the following way:

```
Authorization: Basic aXAxLTEyMzQ1OkNuYlhGZnlUTTVCVEtoN3VOVg==`
```