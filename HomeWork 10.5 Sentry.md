# Домашнее задание к занятию "10.5 (16) 16.Платформа мониторинга Sentry"

## Задание 1 - Регистрируемся в sentry.io - Free cloud

- Sentry Project DashBoard:

<img src="img/HW 10.5 Sentry Projects.png"/>

## Задание 2 - Sentry - sample event

- Stack trace:

<img src="img/HW 10.5 Sentry EventResolv.png"/>

- Resolv issue:

<img src="img/HW 10.5 Sentry Issues.png"/>

## Задание 3 - Sentry - Alerting

- Email alert message:

<img src="img/HW 10.5 Sentry EmailAlert.png"/>

## Задание 4 * - Sentry test SDK

- Test SDK

<img src="img/HW 10.5 Sentry TestSDK.png"/>

- [test.py](Sentry/test.py)

```python
import logging 
import sentry_sdk 
from sentry_sdk.integrations.logging import LoggingIntegration

sentry_logging = LoggingIntegration(
    level=logging.INFO,
    event_level=logging.ERROR
    )

sentry_sdk.init(
dsn="https://fc386139ed7940f9a61805dfa7e62b4c@o4504606064050176.ingest.sentry.io/4504606071062528", 
integrations=[sentry_logging],
traces_sample_rate=1.0
)

logging.debug("I am ignored")
logging.info("I am a breadcrumb")
logging.error("I am an event", extra=dict(bar=43))
logging.exception("An exception happened")
```
