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
