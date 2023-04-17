import os
import sys
import re

n_dir = sys.argv[1]
version = sys.argv[2]

version_numbers = [int(num) for num in version.split('.')]

folders = os.listdir(n_dir)

for folder in folders:
    match = re.match(r'(\w+)_(\d+\.\d+\.\d+\.\d+)', folder)
    if match:
        product_name, product_version = match.groups()
        product_numbers = [int(num) for num in product_version.split('.')]
        if len(product_numbers) == len(version_numbers):
            if product_numbers <= version_numbers:
                print(f'Removing folder {folder}...')
                os.system(f'rm -rf {os.path.join(n_dir, folder)}')
        elif len(product_numbers) < len(version_numbers):
            if product_numbers + [0]*(len(version_numbers)-len(product_numbers)) <= version_numbers:
                print(f'Removing folder {folder}...')
                os.system(f'rm -rf {os.path.join(n_dir, folder)}')
        else: # len(product_numbers) > len(version_numbers)
            if product_numbers[:len(version_numbers)] <= version_numbers:
                print(f'Removing folder {folder}...')
                os.system(f'rm -rf {os.path.join(n_dir, folder)}')