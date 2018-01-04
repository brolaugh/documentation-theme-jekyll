---
layout: post
title: "SOAP API Changelog"
date: "2018-01-04"
sidebar: soap_sidebar
permalink: docs-soap-api-changelog.html
categories: changelog
---

## [3.4.8] - 2018-01-04

### Fixed

#### Remove non functional url decoding
Before we started using git (which we did in 2012) someone added a non standard way of encoding the text messages would cause our suppliers to decode into something else from what the original text was. This resulted in non URL friendly characters to not be encoded back into their original values. This has now been fixed as we're now using a standard .NET URL encoder and decoder.