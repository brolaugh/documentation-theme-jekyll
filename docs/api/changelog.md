---
layout: post
title: "REST API Changelog"
date: "2017-11-17"
sidebar: api_sidebar
permalink: docs-api-changelog.html
categories: changelog
---

## [1.7.3] - 2017-11-23

### Fixed

#### Add first in bundle to SMS Bundles
When we moved from sending SMS synchronously to asynchronously we didn't reimplement the usage of first in bundle which has caused a customers not being able to see SMS bundles in WebbSMS that was sent through the REST API.

## [1.7.2] - 2017-11-22

### Added

#### Add support for phone numbers starting with plus (+)
Previously we didn't support numbers that started with pluses since they caused crashing. We've now added support for this by removing the pluses internally before they go out to the GSM network.

## [1.7.1] - 2017-11-17

### Added

#### Add ability to provide email address for email copies through curly brace templating

`Parameters.insertPhoneNumberHere.email` is now used to fill a recipients email in order to be able to send email copies without the use of contacts. If you want to use the `email` argument without email copies you can set the root property `Email` to `false`.

### Fixed

#### Made SMS and email copies send the same text when using curly brace templating on the `sms/send` endpoint

Previously SMS and email copies were templated separately which made it so that when we implemented the curly bracket based templating, email copies was not affected making the SMS text and the email text differ if curly brace templating was used.

``` plain
Hi my name is {name} how are you today {title} {lastName}?
```

The text above would result in no change for the email copies while the SMS would look something along the lines of this:

``` plain
Hi my name is Earl how are you today Sir Newton?
```