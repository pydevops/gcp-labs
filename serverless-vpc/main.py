import os
import datetime
import random

import redis

r = redis.StrictRedis(host=os.environ['REDIS_HOST'], decode_responses=True)


def main(request=None):
    cache_key = datetime.datetime.now().minute
    val = r.get(cache_key)
    if not val:
        val = random.random()
        out = f'set value: {val}'
        r.set(cache_key, val)
    else:
        out = f'value from cache: {val}'
        #r.delete(cache_key)
    return out