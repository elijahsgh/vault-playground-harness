# poetry init -n
# poetry config virtualenvs.in-project true --local
# poetry add aiohttp[speedups]

import aiohttp
import asyncio
import json
import random
from uuid import uuid4

vault_token = ""
number_of_keys = 1000000

with open('current_root_token') as f:
    vault_token = f.read().strip()


async def load():
    requests = []

    headers = {'X-Vault-Token': vault_token }

    async with aiohttp.ClientSession(base_url='http://localhost:8200') as session:
        for i in range(number_of_keys):
            data = {
                'data': {
                    str(random.randint(1,9999)): str(random.randint(1, 9999))
                }
            }

            async with session.post(f'/v1/kv/data/{uuid4()}?version=2', headers=headers, json=data) as r:
                print('.', end='', flush=True)


if __name__ == '__main__':
    asyncio.run(load())
